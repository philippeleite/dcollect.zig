const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Context = common.Context;
const Database = common.Database;
const Header = common.Header;

pub const RecordV = extern struct {
    header: Header,
    dcvvolsr: [6]u8,
    dcvflag1: [1]u8,
    dcverror: [1]u8,
    _res1: [3]u8,
    dcvperct: u8,
    dcvfresp: u32,
    dcvalloc: u32,
    dcvvlcap: u32,
    dcvfragi: i32,
    dcvlgext: u32,
    dcvfrext: i32,
    dcvfdscb: i32,
    dcvfvirs: i32,
    dcvdvtyp: [8]u8,
    dcvdvnum: [2]u8,
    _res2: [2]u8,
    dcvsglng: u16,
    dcvsgtcl: [30]u8,
    dcvdptyp: [8]u8,
    dcvtrpct: u8,
    dcveavol: u8,
    _res3: [2]u8,
    dcvtrfsp: u32,
    dcvtralc: u32,
    dcvtrvlc: u32,
    dcvtrfrg: i32,
    dcvtrlge: u32,
    dcvtrfrx: i32,
    dcvfcyls: i32,
    dcvftrks: i32,
    _res4: [4]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_v;
        \\ CREATE TABLE record_v (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dcvvolsr TEXT NOT NULL DEFAULT '',
        \\     dcvinxex BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvinxen BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvuspvt BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvuspub BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvussto BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvshrds BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvmangd BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvinitl BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvevlcp BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvebytk BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvelspc BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvperct SMALLINT NOT NULL DEFAULT 0,
        \\     dcvfresp INTEGER NOT NULL DEFAULT 0,
        \\     dcvalloc INTEGER NOT NULL DEFAULT 0,
        \\     dcvvlcap INTEGER NOT NULL DEFAULT 0,
        \\     dcvfragi INTEGER NOT NULL DEFAULT 0,
        \\     dcvlgext INTEGER NOT NULL DEFAULT 0,
        \\     dcvfrext INTEGER NOT NULL DEFAULT 0,
        \\     dcvfdscb INTEGER NOT NULL DEFAULT 0,
        \\     dcvfvirs INTEGER NOT NULL DEFAULT 0,
        \\     dcvdvtyp TEXT NOT NULL DEFAULT '',
        \\     dcvdvnum TEXT NOT NULL DEFAULT '',
        \\     dcvsgtcl TEXT NOT NULL DEFAULT '',
        \\     dcvdptyp TEXT NOT NULL DEFAULT '',
        \\     dcvtrpct SMALLINT NOT NULL DEFAULT 0,
        \\     dcvcylmg BOOLEAN NOT NULL DEFAULT 0,
        \\     dcvtrfsp INTEGER NOT NULL DEFAULT 0,
        \\     dcvtralc INTEGER NOT NULL DEFAULT 0,
        \\     dcvtrvlc INTEGER NOT NULL DEFAULT 0,
        \\     dcvtrfrg INTEGER NOT NULL DEFAULT 0,
        \\     dcvtrlge INTEGER NOT NULL DEFAULT 0,
        \\     dcvtrfrx INTEGER NOT NULL DEFAULT 0,
        \\     dcvfcyls INTEGER NOT NULL DEFAULT 0,
        \\     dcvftrks INTEGER NOT NULL DEFAULT 0
        \\ );
    ;

    pub const insertSQL =
        \\ INSERT INTO record_v (
        \\     dcvvolsr,
        \\     dcvinxex,
        \\     dcvinxen,
        \\     dcvuspvt,
        \\     dcvuspub,
        \\     dcvussto,
        \\     dcvshrds,
        \\     dcvmangd,
        \\     dcvinitl,
        \\     dcvevlcp,
        \\     dcvebytk,
        \\     dcvelspc,
        \\     dcvperct,
        \\     dcvfresp,
        \\     dcvalloc,
        \\     dcvvlcap,
        \\     dcvfragi,
        \\     dcvlgext,
        \\     dcvfrext,
        \\     dcvfdscb,
        \\     dcvfvirs,
        \\     dcvdvtyp,
        \\     dcvdvnum,
        \\     dcvsgtcl,
        \\     dcvdptyp,
        \\     dcvtrpct,
        \\     dcvcylmg,
        \\     dcvtrfsp,
        \\     dcvtralc,
        \\     dcvtrvlc,
        \\     dcvtrfrg,
        \\     dcvtrlge,
        \\     dcvtrfrx,
        \\     dcvfcyls,
        \\     dcvftrks) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flag1_dcvinxex = util.bitFlag(RecordV, "dcvflag1", 0x80);
    pub const flag1_dcvinxen = util.bitFlag(RecordV, "dcvflag1", 0x40);
    pub const flag1_dcvuspvt = util.bitFlag(RecordV, "dcvflag1", 0x20);
    pub const flag1_dcvuspub = util.bitFlag(RecordV, "dcvflag1", 0x10);
    pub const flag1_dcvussto = util.bitFlag(RecordV, "dcvflag1", 0x08);
    pub const flag1_dcvshrds = util.bitFlag(RecordV, "dcvflag1", 0x04);
    pub const flag1_dcvmangd = util.bitFlag(RecordV, "dcvflag1", 0x02);
    pub const flag1_dcvinitl = util.bitFlag(RecordV, "dcvflag1", 0x01);

    pub const error_dcvevlcp = util.bitFlag(RecordV, "dcverror", 0x80);
    pub const error_dcvebytk = util.bitFlag(RecordV, "dcverror", 0x40);
    pub const error_dcvelspc = util.bitFlag(RecordV, "dcverror", 0x20);

    pub inline fn bind(self: *RecordV, db: *Database, stmt: common.Stmt) !void {
        util.bcd2asc(&self.dcvvolsr);
        try db.bindText(stmt, 1, &self.dcvvolsr);
        try db.bindBool(stmt, 2, self.flag1_dcvinxex());
        try db.bindBool(stmt, 3, self.flag1_dcvinxen());
        try db.bindBool(stmt, 4, self.flag1_dcvuspvt());
        try db.bindBool(stmt, 5, self.flag1_dcvuspub());
        try db.bindBool(stmt, 6, self.flag1_dcvussto());
        try db.bindBool(stmt, 7, self.flag1_dcvshrds());
        try db.bindBool(stmt, 8, self.flag1_dcvmangd());
        try db.bindBool(stmt, 9, self.flag1_dcvinitl());
        try db.bindBool(stmt, 10, self.error_dcvevlcp());
        try db.bindBool(stmt, 11, self.error_dcvebytk());
        try db.bindBool(stmt, 12, self.error_dcvelspc());
        try db.bindInt(stmt, 13, self.dcvperct);
        try db.bindInt64(stmt, 14, self.dcvfresp);
        try db.bindInt64(stmt, 15, self.dcvalloc);
        try db.bindInt64(stmt, 16, self.dcvvlcap);
        try db.bindInt(stmt, 17, self.dcvfragi);
        try db.bindInt64(stmt, 18, self.dcvlgext);
        try db.bindInt(stmt, 19, self.dcvfrext);
        try db.bindInt(stmt, 20, self.dcvfdscb);
        try db.bindInt(stmt, 21, self.dcvfvirs);

        util.bcd2asc(&self.dcvdvtyp);
        try db.bindText(stmt, 22, &self.dcvdvtyp);

        try db.bindText(stmt, 23, &std.fmt.bytesToHex(self.dcvdvnum, .upper));

        util.bcd2asc(&self.dcvsgtcl);
        try db.bindText(stmt, 24, &self.dcvsgtcl);

        util.bcd2asc(&self.dcvdptyp);
        try db.bindText(stmt, 25, &self.dcvdptyp);

        try db.bindInt(stmt, 26, self.dcvtrpct);
        try db.bindInt(stmt, 27, self.dcveavol);
        try db.bindInt64(stmt, 28, self.dcvtrfsp);
        try db.bindInt64(stmt, 29, self.dcvtralc);
        try db.bindInt64(stmt, 30, self.dcvtrvlc);
        try db.bindInt(stmt, 31, self.dcvtrfrg);
        try db.bindInt64(stmt, 32, self.dcvtrlge);
        try db.bindInt(stmt, 33, self.dcvtrfrx);
        try db.bindInt(stmt, 34, self.dcvfcyls);
        try db.bindInt(stmt, 35, self.dcvftrks);
    }
};

pub const Record = RecordV;
pub const record_key = "V ";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordV size: {d}\n", .{@sizeOf(RecordV)});
    try std.testing.expect(@sizeOf(RecordV) == 160);
}
