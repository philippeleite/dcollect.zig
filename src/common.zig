const std = @import("std");
const c = @import("sqlite");
const util = @import("util.zig");
const D = @import("recordD.zig");
const A = @import("recordA.zig");
const V = @import("recordV.zig");
const DC = @import("recordDC.zig");
const SC = @import("recordSC.zig");
const MC = @import("recordMC.zig");
const SG = @import("recordSG.zig");
const BC = @import("recordBC.zig");
const VL = @import("recordVL.zig");
const AI = @import("recordAI.zig");

const record_modules = .{ D, A, V, DC, SC, MC, SG, BC, VL, AI };

pub const Context = struct {
    dcollect_file: []const u8 = undefined,
    sqlite_db_file: []const u8 = undefined,
    in: std.process.Init,
    db: Database = undefined,
    count: std.StringHashMap(usize) = undefined,
    /// Overrides where `print` writes to. Left `null` in production, where
    /// `print` writes to the real process stdout. Tests can point this at a
    /// `std.Io.Writer.Discarding` (or similar) sink to avoid writing to the
    /// real stdout, which under `zig build test` is reserved for the build
    /// runner's test protocol.
    stdout_override: ?*std.Io.Writer = null,

    pub fn init(in: std.process.Init) Context {
        return Context{
            .in = in,
            .count = std.StringHashMap(usize).init(in.gpa),
        };
    }

    pub fn deinit(self: *Context) void {
        self.count.deinit();
    }

    pub fn print(self: *Context, comptime fmt: []const u8, args: anytype) !void {
        if (self.stdout_override) |w| {
            try w.print(fmt, args);
            return;
        }
        var stdout_writer = std.Io.File.stdout().writer(self.in.io, &.{});
        const stdout = &stdout_writer.interface;
        try stdout.print(fmt, args);
    }
};

pub const Stmt = *c.sqlite3_stmt;

/// Binds positional SQLite parameters in call order, tracking the column
/// index automatically so record `bind()` implementations never need to
/// hardcode (and keep in sync) a column number per field.
pub const Binder = struct {
    db: *Database,
    stmt: Stmt,
    index: c_int = 1,

    pub fn text(self: *Binder, value: []const u8) !void {
        try self.db.bindText(self.stmt, self.index, value);
        self.index += 1;
    }

    pub fn boolean(self: *Binder, value: bool) !void {
        try self.db.bindBool(self.stmt, self.index, value);
        self.index += 1;
    }

    pub fn int(self: *Binder, value: i32) !void {
        try self.db.bindInt(self.stmt, self.index, value);
        self.index += 1;
    }

    pub fn int64(self: *Binder, value: i64) !void {
        try self.db.bindInt64(self.stmt, self.index, value);
        self.index += 1;
    }
};

fn placeholderCount(comptime sql: []const u8) comptime_int {
    return std.mem.count(u8, sql, "?");
}

pub const Database = struct {
    db: *c.sqlite3 = undefined,
    stmts: [record_modules.len]Stmt = undefined,
    count: usize = 0,

    const COMMIT_THRESHOLD: usize = 5000;

    pub fn init(allocator: std.mem.Allocator, db_path: []const u8) !Database {
        const null_db = try allocator.dupeSentinel(u8, db_path, 0);
        defer allocator.free(null_db);

        const flags =
            c.SQLITE_OPEN_READWRITE |
            c.SQLITE_OPEN_CREATE;

        var db: ?*c.sqlite3 = undefined;
        if (c.SQLITE_OK != c.sqlite3_open_v2(null_db, &db, flags, null)) {
            std.log.err("Can't open database: {s}\n", .{c.sqlite3_errmsg(db.?)});
            return error.CantOpenDatabase;
        }

        var database = Database{ .db = db.? };
        _ = c.sqlite3_exec(database.db, "PRAGMA synchronous=OFF;", null, null, null);
        _ = c.sqlite3_exec(database.db, "PRAGMA journal_mode=MEMORY;", null, null, null);

        inline for (record_modules) |m| {
            try database.execute(m.Record.tableSQL);
        }
        inline for (record_modules, 0..) |m, i| {
            database.stmts[i] = try prepareStmt(db.?, m.Record.insertSQL);
        }

        return database;
    }

    pub fn deinit(self: *Database) void {
        for (self.stmts) |stmt| {
            _ = c.sqlite3_finalize(stmt);
        }
        _ = c.sqlite3_exec(self.db, "COMMIT;", null, null, null);
        _ = c.sqlite3_close(self.db);
    }

    fn prepareStmt(db: *c.sqlite3, sql: [:0]const u8) !Stmt {
        var stmt: ?Stmt = undefined;
        if (c.SQLITE_OK != c.sqlite3_prepare_v2(db, sql, @intCast(sql.len + 1), &stmt, null)) {
            std.log.err("Can't create prepare statement: {s}\n", .{c.sqlite3_errmsg(db)});
            return error.prepareStmt;
        }
        return stmt.?;
    }

    pub fn execute(self: *Database, query: [:0]const u8) !void {
        var errmsg: [*c]u8 = undefined;
        if (c.SQLITE_OK != c.sqlite3_exec(self.db, query, null, null, &errmsg)) {
            defer c.sqlite3_free(errmsg);
            std.log.err("Exec query failed: {s}\n", .{errmsg});
            return error.execError;
        }
        return;
    }

    pub fn begin(self: *Database) void {
        if (self.count == 0) {
            _ = c.sqlite3_exec(self.db, "BEGIN;", null, null, null);
        }
    }

    pub fn commit(self: *Database) void {
        if (self.count >= COMMIT_THRESHOLD) {
            _ = c.sqlite3_exec(self.db, "COMMIT;", null, null, null);
            self.count = 0;
        }
    }

    pub fn rollback(self: *Database) void {
        _ = c.sqlite3_exec(self.db, "ROLLBACK;", null, null, null);
        self.count = 0;
    }

    pub fn step(self: *Database, stmt: Stmt) !void {
        if (c.SQLITE_DONE != c.sqlite3_step(stmt)) {
            std.log.err("Can't step stmt: {s}\n", .{c.sqlite3_errmsg(self.db)});
            return error.Step;
        }
    }

    pub fn reset(self: *Database, stmt: Stmt) !void {
        if (c.SQLITE_OK != c.sqlite3_reset(stmt)) {
            std.log.err("Can't reset stmt: {s}\n", .{c.sqlite3_errmsg(self.db)});
            return error.Reset;
        }
    }

    pub fn bindText(self: *Database, stmt: Stmt, index: c_int, text: []const u8) !void {
        if (c.SQLITE_OK != c.sqlite3_bind_text(stmt, index, text.ptr, @intCast(text.len), c.SQLITE_TRANSIENT)) {
            std.log.err("Can't bind text at index {d}: {s}\n", .{ index, c.sqlite3_errmsg(self.db) });
            return error.bindText;
        }
    }

    pub fn bindBool(self: *Database, stmt: Stmt, index: c_int, value: bool) !void {
        if (c.SQLITE_OK != c.sqlite3_bind_int(stmt, index, if (value) 1 else 0)) {
            std.log.err("Can't bind bool at index {d}: {s}\n", .{ index, c.sqlite3_errmsg(self.db) });
            return error.bindBool;
        }
    }

    pub fn bindInt(self: *Database, stmt: Stmt, index: c_int, value: i32) !void {
        if (c.SQLITE_OK != c.sqlite3_bind_int(stmt, index, @as(c_int, value))) {
            std.log.err("Can't bind int at index {d}: {s}\n", .{ index, c.sqlite3_errmsg(self.db) });
            return error.bindInt;
        }
    }

    pub fn bindInt64(self: *Database, stmt: Stmt, index: c_int, value: i64) !void {
        if (c.SQLITE_OK != c.sqlite3_bind_int64(stmt, index, @intCast(value))) {
            std.log.err("Can't bind int64 at index {d}: {s}\n", .{ index, c.sqlite3_errmsg(self.db) });
            return error.bindInt64;
        }
    }
};

pub const Header = extern struct {
    dculeng: u16,
    _res1: [2]u8,
    dcurctyp: [2]u8,
    dcuvers: u16,
    dcusysid: [4]u8,
    dcutime: [4]u8,
    dcudate: [4]u8,
    _res2: [4]u8,
};

const procFn = *const fn (*Context, []u8) anyerror!void;

const routeFn = blk: {
    var kvs: [record_modules.len]struct { []const u8, procFn } = undefined;
    for (record_modules, 0..) |m, i| {
        kvs[i] = .{ m.record_key, m.process };
    }
    break :blk std.StaticStringMap(procFn).initComptime(kvs);
};

fn dummyProcess(_: *Context, _: []u8) anyerror!void {}

pub fn processRecord(ctx: *Context, record: []u8) !void {
    util.bcd2asc(record[4..6]);
    const rec_type = record[4..6];
    const proc_fn = routeFn.get(rec_type) orelse dummyProcess;
    ctx.db.begin();
    try proc_fn(ctx, record);
    ctx.db.count += 1;
    ctx.db.commit();
}

fn indexOf(comptime m: type) usize {
    for (record_modules, 0..) |rm, i| {
        if (rm == m) return i;
    }
    @compileError("record module not registered in record_modules");
}

pub fn genericProcess(comptime m: type) procFn {
    const idx = comptime indexOf(m);
    const expected_columns = comptime placeholderCount(m.Record.insertSQL);
    return struct {
        fn process(ctx: *Context, record: []u8) anyerror!void {
            var rec: *m.Record = @ptrCast(@alignCast(record[0..@sizeOf(m.Record)]));
            std.mem.byteSwapAllFields(m.Record, rec);
            const stmt = ctx.db.stmts[idx];
            var binder = Binder{ .db = &ctx.db, .stmt = stmt };
            try rec.bind(&binder);
            std.debug.assert(binder.index - 1 == expected_columns);
            try ctx.db.step(stmt);
            try ctx.db.reset(stmt);

            const result = try ctx.count.getOrPut(m.record_key);
            if (result.found_existing) {
                result.value_ptr.* += 1;
            } else {
                result.value_ptr.* = 1;
            }
        }
    }.process;
}
