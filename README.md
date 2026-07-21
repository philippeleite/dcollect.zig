# dcollect.zig

`dcollect` is a command-line tool that reads IBM z/OS DCOLLECT binary datasets and writes parsed records into a SQLite database for easy querying.

## What this project does

- Reads a DCOLLECT file generated on z/OS.
- Parses supported record types.
- Creates (or overwrites) SQLite tables for those record types.
- Loads parsed records into SQLite so you can analyze storage and dataset metadata using SQL.

## Requirements

- Zig `0.16.0` or newer
- A DCOLLECT dataset file transferred in **binary mode** (for example, via FTP)

## Build

```bash
zig build
```

The executable is generated at:

```text
zig-out/bin/dcollect
```

## Run

```bash
dcollect [options] <dcollect_file> <sqlite_db_file>
```

### Options

- `-h`, `--help`: Show help message
- `-v`, `--version`: Show version information

### Example

```bash
dcollect MY.DCOLLECT.BIN dcollect.db
```

When finished, the tool prints:

- input file name
- input file size
- count of processed records by type

## SQLite output

Current tables created by the importer:

- `record_d`
- `record_a`
- `record_v`
- `record_dc`

> Note: these tables are recreated during import (`DROP TABLE IF EXISTS ...`), so re-running the tool on the same database path replaces previous imported data.

## Quick SQL examples

```sql
-- Total imported datasets (D records)
SELECT COUNT(*) FROM record_d;

-- Top 20 largest allocated datasets by secondary-space-related value
SELECT dcddsnam, dcdallsp
FROM record_d
ORDER BY dcdallsp DESC
LIMIT 20;

-- Volumes with highest percent used
SELECT dcvvolsr, dcvperct
FROM record_v
ORDER BY dcvperct DESC
LIMIT 20;
```

## Implemented DCOLLECT record types

| Type | Description | Implemented |
| ---- | ----------- | :---------: |
| D | Active Data Set Record | ✅ |
| A | VSAM Association Information | ✅ |
| V | Volume Information | ✅ |
| M | Migrated Data Set Information | ❌ |
| B | Backup Data Set Information | ❌ |
| C | DASD Capacity Planning Information | ❌ |
| T | Tape Capacity Planning Information | ❌ |
| DC | Data Class Construct Information | ✅ |
| SC | Storage Class Construct Information | ❌ |
| MC | Management Class Construct Information | ❌ |
| BC | Base Configuration Information | ❌ |
| SG | Storage Group Construct Information | ❌ |
| VL | Storage Group Volume Information | ❌ |
| AG | Aggregate Group Information | ❌ |
| DR | OAM Drive Record Information | ❌ |
| LB | OAM Library Record Information | ❌ |
| CN | Cache Names from Base Configuration Information | ❌ |
| AI | Accounting Information from ACS Routines | ❌ |

## Notes

- Unknown or unsupported record types are skipped.
- For reliable parsing, ensure the DCOLLECT file is not text-converted during transfer.
