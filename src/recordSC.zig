const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Storage Class Construct Information (record type 'SC').
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 17.
pub const RecordSC = extern struct {
    header: Header,
    dscnmlen: u16,
    dscname: [30]u8,
    dscuser: [8]u8,
    dscdate: [10]u8,
    _res1: [2]u8,
    dsctime: [8]u8,
    dscdesc: [120]u8,
    dscflags: [1]u8,
    dscflag2: [1]u8,
    dscversn: u8,
    dscbakup: u8,
    dscavail: u8,
    dscdirb: u8,
    dscseqb: u8,
    dscacces: u8,
    dsciacdl: i32,
    dscdirr: i32,
    dscseqr: i32,
    dscstsdr: i32,
    dsccslen: u16,
    dsccsnam: [30]u8,
    dscdircw: i16,
    dscseqcw: i16,
    dscflag3: [1]u8,
    dscpav: u8,
    dscstosl: u8,
    dscvflg2: [1]u8,
    dsccmmft: [1]u8,
    _res2: [11]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_sc;
        \\ CREATE TABLE record_sc (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dscname TEXT NOT NULL DEFAULT '',
        \\     dscuser TEXT NOT NULL DEFAULT '',
        \\     dscdate TEXT NOT NULL DEFAULT '',
        \\     dsctime TEXT NOT NULL DEFAULT '',
        \\     dscdesc TEXT NOT NULL DEFAULT '',
        \\     dscdfgsp BOOLEAN NOT NULL DEFAULT 0,
        \\     dscdfavl BOOLEAN NOT NULL DEFAULT 0,
        \\     dscfdirr BOOLEAN NOT NULL DEFAULT 0,
        \\     dscfdirb BOOLEAN NOT NULL DEFAULT 0,
        \\     dscfseqr BOOLEAN NOT NULL DEFAULT 0,
        \\     dscfseqb BOOLEAN NOT NULL DEFAULT 0,
        \\     dscsyncd BOOLEAN NOT NULL DEFAULT 0,
        \\     dscfiad BOOLEAN NOT NULL DEFAULT 0,
        \\     dscdfacc BOOLEAN NOT NULL DEFAULT 0,
        \\     dscdfsdr BOOLEAN NOT NULL DEFAULT 0,
        \\     dscfdcfw BOOLEAN NOT NULL DEFAULT 0,
        \\     dscfscfw BOOLEAN NOT NULL DEFAULT 0,
        \\     dscversp BOOLEAN NOT NULL DEFAULT 0,
        \\     dscbusp BOOLEAN NOT NULL DEFAULT 0,
        \\     dscdssep BOOLEAN NOT NULL DEFAULT 0,
        \\     dsctiers BOOLEAN NOT NULL DEFAULT 0,
        \\     dscversn SMALLINT NOT NULL DEFAULT 0,
        \\     dscbakup SMALLINT NOT NULL DEFAULT 0,
        \\     dscavail SMALLINT NOT NULL DEFAULT 0,
        \\     dscdirb SMALLINT NOT NULL DEFAULT 0,
        \\     dscseqb SMALLINT NOT NULL DEFAULT 0,
        \\     dscacces SMALLINT NOT NULL DEFAULT 0,
        \\     dsciacdl INTEGER NOT NULL DEFAULT 0,
        \\     dscdirr INTEGER NOT NULL DEFAULT 0,
        \\     dscseqr INTEGER NOT NULL DEFAULT 0,
        \\     dscstsdr INTEGER NOT NULL DEFAULT 0,
        \\     dsccsnam TEXT NOT NULL DEFAULT '',
        \\     dscdircw SMALLINT NOT NULL DEFAULT 0,
        \\     dscseqcw SMALLINT NOT NULL DEFAULT 0,
        \\     dsctier BOOLEAN NOT NULL DEFAULT 0,
        \\     dscpavs BOOLEAN NOT NULL DEFAULT 0,
        \\     dscfols BOOLEAN NOT NULL DEFAULT 0,
        \\     dscfdcls BOOLEAN NOT NULL DEFAULT 0,
        \\     dscpav SMALLINT NOT NULL DEFAULT 0,
        \\     dscstosl SMALLINT NOT NULL DEFAULT 0,
        \\     dscdcls BOOLEAN NOT NULL DEFAULT 0,
        \\     dscdssfi BOOLEAN NOT NULL DEFAULT 0,
        \\     dschlerd BOOLEAN NOT NULL DEFAULT 0,
        \\     dschlewr BOOLEAN NOT NULL DEFAULT 0
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_sc (
        \\     dscname,
        \\     dscuser,
        \\     dscdate,
        \\     dsctime,
        \\     dscdesc,
        \\     dscdfgsp,
        \\     dscdfavl,
        \\     dscfdirr,
        \\     dscfdirb,
        \\     dscfseqr,
        \\     dscfseqb,
        \\     dscsyncd,
        \\     dscfiad,
        \\     dscdfacc,
        \\     dscdfsdr,
        \\     dscfdcfw,
        \\     dscfscfw,
        \\     dscversp,
        \\     dscbusp,
        \\     dscdssep,
        \\     dsctiers,
        \\     dscversn,
        \\     dscbakup,
        \\     dscavail,
        \\     dscdirb,
        \\     dscseqb,
        \\     dscacces,
        \\     dsciacdl,
        \\     dscdirr,
        \\     dscseqr,
        \\     dscstsdr,
        \\     dsccsnam,
        \\     dscdircw,
        \\     dscseqcw,
        \\     dsctier,
        \\     dscpavs,
        \\     dscfols,
        \\     dscfdcls,
        \\     dscpav,
        \\     dscstosl,
        \\     dscdcls,
        \\     dscdssfi,
        \\     dschlerd,
        \\     dschlewr) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flags_dscdfgsp = util.bitFlag(RecordSC, "dscflags", 0x80);
    pub const flags_dscdfavl = util.bitFlag(RecordSC, "dscflags", 0x40);
    pub const flags_dscfdirr = util.bitFlag(RecordSC, "dscflags", 0x20);
    pub const flags_dscfdirb = util.bitFlag(RecordSC, "dscflags", 0x10);
    pub const flags_dscfseqr = util.bitFlag(RecordSC, "dscflags", 0x08);
    pub const flags_dscfseqb = util.bitFlag(RecordSC, "dscflags", 0x04);
    pub const flags_dscsyncd = util.bitFlag(RecordSC, "dscflags", 0x02);
    pub const flags_dscfiad = util.bitFlag(RecordSC, "dscflags", 0x01);

    pub const flag2_dscdfacc = util.bitFlag(RecordSC, "dscflag2", 0x80);
    pub const flag2_dscdfsdr = util.bitFlag(RecordSC, "dscflag2", 0x40);
    pub const flag2_dscfdcfw = util.bitFlag(RecordSC, "dscflag2", 0x20);
    pub const flag2_dscfscfw = util.bitFlag(RecordSC, "dscflag2", 0x10);
    pub const flag2_dscversp = util.bitFlag(RecordSC, "dscflag2", 0x08);
    pub const flag2_dscbusp = util.bitFlag(RecordSC, "dscflag2", 0x04);
    pub const flag2_dscdssep = util.bitFlag(RecordSC, "dscflag2", 0x02);
    pub const flag2_dsctiers = util.bitFlag(RecordSC, "dscflag2", 0x01);

    pub const flag3_dsctier = util.bitFlag(RecordSC, "dscflag3", 0x80);
    pub const flag3_dscpavs = util.bitFlag(RecordSC, "dscflag3", 0x40);
    pub const flag3_dscfols = util.bitFlag(RecordSC, "dscflag3", 0x20);
    pub const flag3_dscfdcls = util.bitFlag(RecordSC, "dscflag3", 0x08);

    pub const vflg2_dscdcls = util.bitFlag(RecordSC, "dscvflg2", 0x80);
    pub const vflg2_dscdssfi = util.bitFlag(RecordSC, "dscvflg2", 0x40);

    pub const cmmft_dschlerd = util.bitFlag(RecordSC, "dsccmmft", 0x80);
    pub const cmmft_dschlewr = util.bitFlag(RecordSC, "dsccmmft", 0x40);

    pub inline fn bind(self: *RecordSC, b: *common.Binder) !void {
        // Lengths come from the input file; clamp so a corrupt record can't slice out of bounds.
        const name = self.dscname[0..@min(self.dscnmlen, self.dscname.len)];
        util.bcd2asc(name);
        try b.text(name);
        util.bcd2asc(&self.dscuser);
        try b.text(&self.dscuser);
        util.bcd2asc(&self.dscdate);
        try b.text(&self.dscdate);
        util.bcd2asc(&self.dsctime);
        try b.text(&self.dsctime);
        util.bcd2asc(&self.dscdesc);
        try b.text(&self.dscdesc);
        try b.boolean(self.flags_dscdfgsp());
        try b.boolean(self.flags_dscdfavl());
        try b.boolean(self.flags_dscfdirr());
        try b.boolean(self.flags_dscfdirb());
        try b.boolean(self.flags_dscfseqr());
        try b.boolean(self.flags_dscfseqb());
        try b.boolean(self.flags_dscsyncd());
        try b.boolean(self.flags_dscfiad());
        try b.boolean(self.flag2_dscdfacc());
        try b.boolean(self.flag2_dscdfsdr());
        try b.boolean(self.flag2_dscfdcfw());
        try b.boolean(self.flag2_dscfscfw());
        try b.boolean(self.flag2_dscversp());
        try b.boolean(self.flag2_dscbusp());
        try b.boolean(self.flag2_dscdssep());
        try b.boolean(self.flag2_dsctiers());
        try b.int(self.dscversn);
        try b.int(self.dscbakup);
        try b.int(self.dscavail);
        try b.int(self.dscdirb);
        try b.int(self.dscseqb);
        try b.int(self.dscacces);
        try b.int(self.dsciacdl);
        try b.int(self.dscdirr);
        try b.int(self.dscseqr);
        try b.int(self.dscstsdr);
        const csnam = self.dsccsnam[0..@min(self.dsccslen, self.dsccsnam.len)];
        util.bcd2asc(csnam);
        try b.text(csnam);
        try b.int(self.dscdircw);
        try b.int(self.dscseqcw);
        try b.boolean(self.flag3_dsctier());
        try b.boolean(self.flag3_dscpavs());
        try b.boolean(self.flag3_dscfols());
        try b.boolean(self.flag3_dscfdcls());
        try b.int(self.dscpav);
        try b.int(self.dscstosl);
        try b.boolean(self.vflg2_dscdcls());
        try b.boolean(self.vflg2_dscdssfi());
        try b.boolean(self.cmmft_dschlerd());
        try b.boolean(self.cmmft_dschlewr());
    }
};

pub const Record = RecordSC;
pub const record_key = "SC";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordSC size: {d}\n", .{@sizeOf(RecordSC)});
    try std.testing.expect(@sizeOf(RecordSC) == 280);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(204, @offsetOf(RecordSC, "dscflags"));
    try std.testing.expectEqual(212, @offsetOf(RecordSC, "dsciacdl"));
    try std.testing.expectEqual(228, @offsetOf(RecordSC, "dsccslen"));
    try std.testing.expectEqual(260, @offsetOf(RecordSC, "dscdircw"));
    try std.testing.expectEqual(264, @offsetOf(RecordSC, "dscflag3"));
    try std.testing.expectEqual(268, @offsetOf(RecordSC, "dsccmmft"));
}
