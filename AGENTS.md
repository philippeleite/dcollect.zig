# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project

`dcollect` is a Zig CLI that reads an IBM z/OS **DCOLLECT** binary dataset (big-endian, EBCDIC) and loads the parsed records into a SQLite database.

```
dcollect [-h|--help] [-v|--version] <dcollect_file> <sqlite_db_file>
```

## Toolchain & commands

- Zig **0.17.x** (`build.zig.zon` sets `minimum_zig_version = "0.17.0"`). Uses the new `std.Io` / `std.process.Init` APIs, so older Zig will not compile it.
- No external Zig dependencies. SQLite is vendored as an amalgamation in `lib/sqlite/` (treat as third-party; do not edit).

| Task               | Command                                                                |
| ------------------ | ---------------------------------------------------------------------- |
| Build              | `zig build` → `zig-out/bin/dcollect`                                   |
| Run                | `zig build run -- <file> <db>`                                         |
| Test               | `zig build test --summary all`                                         |
| Release-like build | `zig build -Doptimize=ReleaseSafe -Dstrip=true -Dsingle-threaded=true` |

Custom build options: `-Dstrip`, `-Dsingle-threaded`. The version string comes from `build.zig.zon` and is exposed to code as `@import("zon").version`.

The first build/test is slow (~1 min): it compiles `sqlite3.c` and runs `translate-c` on `sqlite3.h`.

## Layout

```
src/main.zig      entry point: ArgParser, FileParser (record loop), counters output, end-to-end test
src/common.zig    Context, Database (SQLite wrapper), Binder, Header, record routing, genericProcess
src/util.zig      EBCDIC<->ASCII tables (bcd2asc/asc2bcd), packed-date/time decoders, bitFlag, commaInt
src/recordX.zig   one file per DCOLLECT record type (D, A, V, DC, SC, MC, SG, BC, VL, AI, M)
lib/sqlite/       vendored SQLite amalgamation (compiled with custom -D flags in build.zig)
testdata/         git-ignored; holds the local sample file `testdata/DCOLLECT`
.github/workflows/release.yml   builds Windows/Linux/macOS zips on `v*` tags
```

## How parsing works

1. `FileParser.parseFile` reads the file through a 4 KiB `std.Io.Reader`: peeks a big-endian `u16` record length, then `take(reclen)` for the full record.
2. `common.processRecord` converts bytes `[4..6]` (record type) from EBCDIC in place and looks it up in a comptime `StaticStringMap` built from `record_modules`. Unknown types go to a no-op (they still count toward the commit batch, but not the per-type counters).
3. `genericProcess(m)` casts the bytes to `m.Record` (an `extern struct`), runs `std.mem.byteSwapAllFields` (big-endian → native), and calls `rec.bind(&binder)`. A debug assert checks that the number of bound values equals the number of `?` in `insertSQL`.
4. Inserts run in transactions committed every 5000 records (`Database.COMMIT_THRESHOLD`); the final commit happens in `Database.deinit`.
5. On startup `Database.init` runs each record's `tableSQL`, which **drops and recreates** the table.

## Adding a new record type

Copy an existing `src/recordX.zig` and follow the same shape:

- `pub const RecordX = extern struct { header: Header, ... }` with field names matching IBM's DCOLLECT mapping (lowercase, e.g. `dcddsnam`). Reserved padding is `_resN: [n]u8`. Use `align(1)` on multi-byte fields that are not naturally aligned (e.g. `i64 align(1)`).
- `pub const tableSQL` (`DROP TABLE IF EXISTS ...; CREATE TABLE record_x (...)`) and `pub const insertSQL` (`INSERT ... VALUES (?,...)`), both as Zig multiline strings.
- Bit flags as `pub const <byte>_<name> = util.bitFlag(RecordX, "<field>", 0x80);`.
- `pub inline fn bind(self: *RecordX, b: *common.Binder) !void`: bind **in exactly the same order** as the columns in `insertSQL`. Call `util.bcd2asc` on EBCDIC text fields before `b.text`. Convert dates with `util.dcdate` (packed yyyydddF) / `util.smfdate`, times with `util.smftime` (binary hundredths) or `util.pdtime` (packed hhmmssth), and 8-byte STCK timestamps with `util.stckTimestamp`, into a local buffer.
- Module-level exports: `pub const Record = RecordX;`, `pub const record_key = "X ";` (two chars, space-padded), `pub const process = common.genericProcess(@This());`.
- A `test "record size"` asserting `@sizeOf(RecordX)` equals the length from IBM docs, plus `@offsetOf` checks for the key fields.
- If `testdata/DCOLLECT` has no record of that type, add a synthetic-record test (see `recordM.zig`): build the bytes big-endian/EBCDIC (`util.asc2bcd`), run them through `common.processRecord` on a `common.TestHarness` (in-memory DB) and check columns with `queryText`. Mark the type with ¹ ("not validated against real data") in the README matrix.
- Register it in `record_modules` in `src/common.zig`, add expected counts to the test in `src/main.zig` if the sample file contains that type, and update the README tables (SQLite tables + implemented-types matrix).

## Conventions & gotchas

- Byte-level data is big-endian and EBCDIC. Conversions happen **in place** on the record buffer.
- Text columns are bound with their full fixed width (trailing spaces are kept). Fields that may be X'00'-filled when unset are trimmed with `util.trimPad`.
- Repeating groups (e.g. `DSGSSTAT(32)` in SG) are stored as one TEXT column holding a JSON array built with `util.jsonArray`; query them with `json_each()`. Pass integer arrays as `u16`/wider, since `[N]u8` serializes as a string.
- When the struct has 4-byte fields but the documented length is not a multiple of 4, mark those fields `align(1)` so `@sizeOf` matches the IBM length (see MC, SG).
- Errors: return Zig errors and log with `std.log.err`; `main` prints the error name and exits with code 1.
- Stdout goes through `Context.print`. In tests, set `ctx.stdout_override` to a discarding writer, because under `zig build test` stdout is reserved for the build runner protocol.
- Tests are inline `test` blocks next to the code; there is no separate test directory. The end-to-end test in `main.zig` needs `testdata/DCOLLECT` (git-ignored, local only) and uses `:memory:` as the database.
- The `record size` tests print with `std.debug.print`, so `zig build test` shows extra stderr output (and may show a "failed command" line) even when all tests pass. Check the `N/N tests passed` summary.
- SQLite is built with `SQLITE_THREADSAFE=0`, synchronous off and an in-memory journal. That is fine for this single-writer bulk loader; do not add threads that share the connection.
