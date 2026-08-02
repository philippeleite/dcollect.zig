const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Context = common.Context;
const Database = common.Database;
const Header = common.Header;

pub const RecordA = extern struct {
    header: Header,
    dcadsnam: [44]u8,
    dcaassoc: [44]u8,
    dcaflag1: [1]u8,
    dcaflag2: [1]u8,
    _res1: [2]u8,
    dcahurba: u32,
    dcaharba: u32,
    dcanlr: u32,
    dcadlr: u32,
    dcainr: u32,
    dcaupr: u32,
    dcartr: u32,
    dcaasp: u32,
    dcacis: u32,
    dcacas: u32,
    dcaexc: u32,
    dcarkp: u16,
    dcakln: u16,
    dcahurbc: i64 align(1),
    dcaharbc: i64 align(1),
    dcacisz: i32,
    dcacaci: i32,
    dcatrdt: [4]u8,
    _res2: [12]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_a;
        \\ CREATE TABLE record_a (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dcadsnam TEXT NOT NULL DEFAULT '',
        \\     dcaassoc TEXT NOT NULL DEFAULT '',
        \\     dcaksds BOOLEAN NOT NULL DEFAULT 0,
        \\     dcaesds BOOLEAN NOT NULL DEFAULT 0,
        \\     dcarrds BOOLEAN NOT NULL DEFAULT 0,
        \\     dcalds BOOLEAN NOT NULL DEFAULT 0,
        \\     dcakrds BOOLEAN NOT NULL DEFAULT 0,
        \\     dcaaix BOOLEAN NOT NULL DEFAULT 0,
        \\     dcadata BOOLEAN NOT NULL DEFAULT 0,
        \\     dcaindex BOOLEAN NOT NULL DEFAULT 0,
        \\     dcakr1st BOOLEAN NOT NULL DEFAULT 0,
        \\     dcaixupg BOOLEAN NOT NULL DEFAULT 0,
        \\     dcavrrds BOOLEAN NOT NULL DEFAULT 0,
        \\     dcanstat BOOLEAN NOT NULL DEFAULT 0,
        \\     dcasrci BOOLEAN NOT NULL DEFAULT 0,
        \\     dcag4g BOOLEAN NOT NULL DEFAULT 0,
        \\     dcazfs BOOLEAN NOT NULL DEFAULT 0,
        \\     dcahurba BIGINT NOT NULL DEFAULT 0,
        \\     dcaharba BIGINT NOT NULL DEFAULT 0,
        \\     dcanlr INTEGER NOT NULL DEFAULT 0,
        \\     dcadlr INTEGER NOT NULL DEFAULT 0,
        \\     dcainr INTEGER NOT NULL DEFAULT 0,
        \\     dcaupr INTEGER NOT NULL DEFAULT 0,
        \\     dcartr INTEGER NOT NULL DEFAULT 0,
        \\     dcaasp INTEGER NOT NULL DEFAULT 0,
        \\     dcacis INTEGER NOT NULL DEFAULT 0,
        \\     dcacas INTEGER NOT NULL DEFAULT 0,
        \\     dcaexc INTEGER NOT NULL DEFAULT 0,
        \\     dcarkp SMALLINT NOT NULL DEFAULT 0,
        \\     dcakln SMALLINT NOT NULL DEFAULT 0,
        \\     dcahurbc BIGINT NOT NULL DEFAULT 0,
        \\     dcaharbc BIGINT NOT NULL DEFAULT 0,
        \\     dcacisz INTEGER NOT NULL DEFAULT 0,
        \\     dcacaci INTEGER NOT NULL DEFAULT 0,
        \\     dcatrdt DATE NOT NULL DEFAULT '0000-00-00'
        \\ );
    ;

    pub const insertSQL =
        \\ INSERT INTO record_a (
        \\     dcadsnam,
        \\     dcaassoc,
        \\     dcaksds,
        \\     dcaesds,
        \\     dcarrds,
        \\     dcalds,
        \\     dcakrds,
        \\     dcaaix,
        \\     dcadata,
        \\     dcaindex,
        \\     dcakr1st,
        \\     dcaixupg,
        \\     dcavrrds,
        \\     dcanstat,
        \\     dcasrci,
        \\     dcag4g,
        \\     dcazfs,
        \\     dcahurba,
        \\     dcaharba,
        \\     dcanlr,
        \\     dcadlr,
        \\     dcainr,
        \\     dcaupr,
        \\     dcartr,
        \\     dcaasp,
        \\     dcacis,
        \\     dcacas,
        \\     dcaexc,
        \\     dcarkp,
        \\     dcakln,
        \\     dcahurbc,
        \\     dcaharbc,
        \\     dcacisz,
        \\     dcacaci,
        \\     dcatrdt) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flag1_dcaksds = util.bitFlag(RecordA, "dcaflag1", 0x80);
    pub const flag1_dcaesds = util.bitFlag(RecordA, "dcaflag1", 0x40);
    pub const flag1_dcarrds = util.bitFlag(RecordA, "dcaflag1", 0x20);
    pub const flag1_dcalds = util.bitFlag(RecordA, "dcaflag1", 0x10);
    pub const flag1_dcakrds = util.bitFlag(RecordA, "dcaflag1", 0x08);
    pub const flag1_dcaaix = util.bitFlag(RecordA, "dcaflag1", 0x04);
    pub const flag1_dcadata = util.bitFlag(RecordA, "dcaflag1", 0x02);
    pub const flag1_dcaindex = util.bitFlag(RecordA, "dcaflag1", 0x01);

    pub const flag2_dcakr1st = util.bitFlag(RecordA, "dcaflag2", 0x80);
    pub const flag2_dcaixupg = util.bitFlag(RecordA, "dcaflag2", 0x40);
    pub const flag2_dcavrrds = util.bitFlag(RecordA, "dcaflag2", 0x20);
    pub const flag2_dcanstat = util.bitFlag(RecordA, "dcaflag2", 0x10);
    pub const flag2_dcasrci = util.bitFlag(RecordA, "dcaflag2", 0x08);
    pub const flag2_dcag4g = util.bitFlag(RecordA, "dcaflag2", 0x04);
    pub const flag2_dcazfs = util.bitFlag(RecordA, "dcaflag2", 0x02);

    pub inline fn bind(self: *RecordA, db: *Database, stmt: common.Stmt) !void {
        util.bcd2asc(&self.dcadsnam);
        try db.bindText(stmt, 1, &self.dcadsnam);

        util.bcd2asc(&self.dcaassoc);
        try db.bindText(stmt, 2, &self.dcaassoc);

        try db.bindBool(stmt, 3, self.flag1_dcaksds());
        try db.bindBool(stmt, 4, self.flag1_dcaesds());
        try db.bindBool(stmt, 5, self.flag1_dcarrds());
        try db.bindBool(stmt, 6, self.flag1_dcalds());
        try db.bindBool(stmt, 7, self.flag1_dcakrds());
        try db.bindBool(stmt, 8, self.flag1_dcaaix());
        try db.bindBool(stmt, 9, self.flag1_dcadata());
        try db.bindBool(stmt, 10, self.flag1_dcaindex());
        try db.bindBool(stmt, 11, self.flag2_dcakr1st());
        try db.bindBool(stmt, 12, self.flag2_dcaixupg());
        try db.bindBool(stmt, 13, self.flag2_dcavrrds());
        try db.bindBool(stmt, 14, self.flag2_dcanstat());
        try db.bindBool(stmt, 15, self.flag2_dcasrci());
        try db.bindBool(stmt, 16, self.flag2_dcag4g());
        try db.bindBool(stmt, 17, self.flag2_dcazfs());
        try db.bindInt64(stmt, 18, self.dcahurba);
        try db.bindInt64(stmt, 19, self.dcaharba);
        try db.bindInt64(stmt, 20, self.dcanlr);
        try db.bindInt64(stmt, 21, self.dcadlr);
        try db.bindInt64(stmt, 22, self.dcainr);
        try db.bindInt64(stmt, 23, self.dcaupr);
        try db.bindInt64(stmt, 24, self.dcartr);
        try db.bindInt64(stmt, 25, self.dcaasp);
        try db.bindInt64(stmt, 26, self.dcacis);
        try db.bindInt64(stmt, 27, self.dcacas);
        try db.bindInt64(stmt, 28, self.dcaexc);
        try db.bindInt64(stmt, 29, self.dcarkp);
        try db.bindInt64(stmt, 30, self.dcakln);
        try db.bindInt64(stmt, 31, self.dcahurbc);
        try db.bindInt64(stmt, 32, self.dcaharbc);
        try db.bindInt(stmt, 33, self.dcacisz);
        try db.bindInt(stmt, 34, self.dcacaci);
        var dcatrdt_str: [10]u8 = .{0} ** 10;
        try util.dcdate(&dcatrdt_str, &self.dcatrdt);
        try db.bindText(stmt, 35, &dcatrdt_str);
    }
};

pub const Record = RecordA;
pub const record_key = "A ";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordA size: {d}\n", .{@sizeOf(RecordA)});
    try std.testing.expect(@sizeOf(RecordA) == 204);
}
