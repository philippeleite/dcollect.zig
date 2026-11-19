const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

pub const RecordD = extern struct {
    header: Header,
    dcddsnam: [44]u8,
    dcderror: [1]u8,
    dcdflag1: [1]u8,
    dcdflag2: [1]u8,
    dcdflag3: [1]u8,
    _res1: [2]u8,
    dcddsorg1: [1]u8,
    dcddsorg2: [1]u8,
    dcdrecrd: [1]u8,
    dcdnmext: u8,
    dcdvolsr: [6]u8,
    dcdbklng: u16,
    dcdlrecl: u16,
    dcdallsp: i32,
    dcdusesp: i32,
    dcdscall: i32,
    dcdnmblk: i32,
    dcdcredt: [4]u8,
    dcdexpdt: [4]u8,
    dcdlstrf: [4]u8,
    dcddsser: [6]u8,
    dcdvolsq: u16,
    dcdlbkdt: [8]u8,
    dcddclng: u16,
    dcdatcl: [30]u8,
    dcdsclng: u16,
    dcdstgcl: [30]u8,
    dcdmclng: u16,
    dcdmgtcl: [30]u8,
    dcdsglng: u16,
    dcdstgrp: [30]u8,
    dcdccsid: [2]u8,
    dcdcatf: [1]u8,
    dcddscbf: [1]u8,
    dcdudsiz: i64 align(1),
    dcdcudsz: i64 align(1),
    dcdexflg: [2]u8,
    dcdscnt: u16,
    dcdovera: i32,
    dcdacct: [32]u8,
    dcdflag5: [1]u8,
    _res2: [6]u8,
    dcdds9f1: u8,
    dcdjbnmc: [8]u8,
    dcdstnmc: [8]u8,
    dcdtimec: [6]u8,
    _res3: [2]u8,
    dcdallsx: i64 align(1),
    dcdusesx: i64 align(1),
    dcdscalx: i64 align(1),
    dcdnmblx: i64 align(1),
    dcdxpsev: u8,
    dcdctype: u8,
    dcdtype: u16,
    dcdklbl: [64]u8,
    _res4: [16]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_d;
        \\ CREATE TABLE record_d (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dcddsnam TEXT NOT NULL,
        \\     dcdemngd BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdedvvr BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdnospc BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdvsami BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdnofm1 BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdracfd BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdsmsm BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdtemp BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdpdse BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdgds BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdreblk BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdchind BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdckdsi BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdnovvr BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdintcg BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdinicf BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdallfg BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdusefg BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdsecfg BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdnmbfg BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdpdsex BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdstrp BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdddmex BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdcpoit BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdgt64k BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdcmptv BOOLEAN NOT NULL DEFAULT 0,
        \\     dcddsgis BOOLEAN NOT NULL DEFAULT 0,
        \\     dcddsgps BOOLEAN NOT NULL DEFAULT 0,
        \\     dcddsgda BOOLEAN NOT NULL DEFAULT 0,
        \\     dcddsgpo BOOLEAN NOT NULL DEFAULT 0,
        \\     dcddsgu BOOLEAN NOT NULL DEFAULT 0,
        \\     dcddsggs BOOLEAN NOT NULL DEFAULT 0,
        \\     dcddsgvs BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdrecfm TEXT NOT NULL DEFAULT '',
        \\     dcdrecft BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdrecfb BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdrecfs BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdrecfa BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdrecfc BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdnmext SMALLINT NOT NULL DEFAULT 0,
        \\     dcdvolsr TEXT NOT NULL DEFAULT '',
        \\     dcdbklng SMALLINT NOT NULL DEFAULT 0,
        \\     dcdlrecl SMALLINT NOT NULL DEFAULT 0,
        \\     dcdallsp INTEGER NOT NULL DEFAULT 0,
        \\     dcdusesp INTEGER NOT NULL DEFAULT 0,
        \\     dcdscall INTEGER NOT NULL DEFAULT 0,
        \\     dcdnmblk INTEGER NOT NULL DEFAULT 0,
        \\     dcdcredt DATE NOT NULL DEFAULT '0000-00-00',
        \\     dcdexpdt DATE NOT NULL DEFAULT '0000-00-00',
        \\     dcdlstrf DATE NOT NULL DEFAULT '0000-00-00',
        \\     dcddsser TEXT NOT NULL DEFAULT '',
        \\     dcdvolsq SMALLINT NOT NULL DEFAULT 0,
        \\     dcdlbkdt DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
        \\     dcdatcl  TEXT NOT NULL DEFAULT '',
        \\     dcdstgcl TEXT NOT NULL DEFAULT '',
        \\     dcdmgtcl TEXT NOT NULL DEFAULT '',
        \\     dcdstgrp TEXT NOT NULL DEFAULT '',
        \\     dcdccsid TEXT NOT NULL DEFAULT '',
        \\     dcdudsiz BIGINT NOT NULL DEFAULT 0,
        \\     dcdcudsz BIGINT NOT NULL DEFAULT 0,
        \\     dcddscnt SMALLINT NOT NULL DEFAULT 0,
        \\     dcdovera INTEGER NOT NULL DEFAULT 0,
        \\     dcdacct  TEXT NOT NULL DEFAULT '',
        \\     dcdallfx BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdusefx BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdscafx BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdnmbfx BOOLEAN NOT NULL DEFAULT 0,
        \\     dcdjbnmc TEXT NOT NULL DEFAULT '',
        \\     dcdstnmc TEXT NOT NULL DEFAULT '',
        \\     dcdallsx BIGINT NOT NULL DEFAULT 0,
        \\     dcdusesx BIGINT NOT NULL DEFAULT 0,
        \\     dcdscalx BIGINT NOT NULL DEFAULT 0,
        \\     dcdnmblx BIGINT NOT NULL DEFAULT 0,
        \\     dcdxpsev SMALLINT NOT NULL DEFAULT 0,
        \\     dcdctype SMALLINT NOT NULL DEFAULT 0,
        \\     dcdtype  SMALLINT NOT NULL DEFAULT 0,
        \\     dcdklbl  TEXT NOT NULL DEFAULT ''
        \\ );
    ;

    pub const insertSQL =
        \\ INSERT INTO record_d (
        \\     dcddsnam,
        \\     dcdemngd,
        \\     dcdedvvr,
        \\     dcdnospc,
        \\     dcdvsami,
        \\     dcdnofm1,
        \\     dcdracfd,
        \\     dcdsmsm,
        \\     dcdtemp,
        \\     dcdpdse,
        \\     dcdgds,
        \\     dcdreblk,
        \\     dcdchind,
        \\     dcdckdsi,
        \\     dcdnovvr,
        \\     dcdintcg,
        \\     dcdinicf,
        \\     dcdallfg,
        \\     dcdusefg,
        \\     dcdsecfg,
        \\     dcdnmbfg,
        \\     dcdpdsex,
        \\     dcdstrp,
        \\     dcdddmex,
        \\     dcdcpoit,
        \\     dcdgt64k,
        \\     dcdcmptv,
        \\     dcddsgis,
        \\     dcddsgps,
        \\     dcddsgda,
        \\     dcddsgpo,
        \\     dcddsgu,
        \\     dcddsggs,
        \\     dcddsgvs,
        \\     dcdrecfm,
        \\     dcdrecft,
        \\     dcdrecfb,
        \\     dcdrecfs,
        \\     dcdrecfa,
        \\     dcdrecfc,
        \\     dcdnmext,
        \\     dcdvolsr,
        \\     dcdbklng,
        \\     dcdlrecl,
        \\     dcdallsp,
        \\     dcdusesp,
        \\     dcdscall,
        \\     dcdnmblk,
        \\     dcdcredt,
        \\     dcdexpdt,
        \\     dcdlstrf,
        \\     dcddsser,
        \\     dcdvolsq,
        \\     dcdlbkdt,
        \\     dcdatcl,
        \\     dcdstgcl,
        \\     dcdmgtcl,
        \\     dcdstgrp,
        \\     dcdccsid,
        \\     dcdudsiz,
        \\     dcdcudsz,
        \\     dcddscnt,
        \\     dcdovera,
        \\     dcdacct,
        \\     dcdallfx,
        \\     dcdusefx,
        \\     dcdscafx,
        \\     dcdnmbfx,
        \\     dcdjbnmc,
        \\     dcdstnmc,
        \\     dcdallsx,
        \\     dcdusesx,
        \\     dcdscalx,
        \\     dcdnmblx,
        \\     dcdxpsev,
        \\     dcdctype,
        \\     dcdtype,
        \\     dcdklbl) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const error_dcdemngd = util.bitFlag(RecordD, "dcderror", 0x80);
    pub const error_dcdedvvr = util.bitFlag(RecordD, "dcderror", 0x40);
    pub const error_dcdnospc = util.bitFlag(RecordD, "dcderror", 0x20);
    pub const error_dcdvsami = util.bitFlag(RecordD, "dcderror", 0x10);
    pub const error_dcdnofm1 = util.bitFlag(RecordD, "dcderror", 0x08);

    pub const flag1_dcdracfd = util.bitFlag(RecordD, "dcdflag1", 0x80);
    pub const flag1_dcdsmsm = util.bitFlag(RecordD, "dcdflag1", 0x40);
    pub const flag1_dcdtemp = util.bitFlag(RecordD, "dcdflag1", 0x20);
    pub const flag1_dcdpdse = util.bitFlag(RecordD, "dcdflag1", 0x10);
    pub const flag1_dcdgds = util.bitFlag(RecordD, "dcdflag1", 0x08);
    pub const flag1_dcdreblk = util.bitFlag(RecordD, "dcdflag1", 0x04);
    pub const flag1_dcdchind = util.bitFlag(RecordD, "dcdflag1", 0x02);
    pub const flag1_dcdckdsi = util.bitFlag(RecordD, "dcdflag1", 0x01);

    pub const flag2_dcdnovvr = util.bitFlag(RecordD, "dcdflag2", 0x80);
    pub const flag2_dcdintcg = util.bitFlag(RecordD, "dcdflag2", 0x40);
    pub const flag2_dcdinicf = util.bitFlag(RecordD, "dcdflag2", 0x20);
    pub const flag2_dcdallfg = util.bitFlag(RecordD, "dcdflag2", 0x08);
    pub const flag2_dcdusefg = util.bitFlag(RecordD, "dcdflag2", 0x04);
    pub const flag2_dcdsecfg = util.bitFlag(RecordD, "dcdflag2", 0x02);
    pub const flag2_dcdnmbfg = util.bitFlag(RecordD, "dcdflag2", 0x01);

    pub const flag3_dcdpdsex = util.bitFlag(RecordD, "dcdflag3", 0x80);
    pub const flag3_dcdstrp = util.bitFlag(RecordD, "dcdflag3", 0x40);
    pub const flag3_dcdddmex = util.bitFlag(RecordD, "dcdflag3", 0x20);
    pub const flag3_dcdcpoit = util.bitFlag(RecordD, "dcdflag3", 0x10);
    pub const flag3_dcdgt64k = util.bitFlag(RecordD, "dcdflag3", 0x08);
    pub const flag3_dcdcmptv = util.bitFlag(RecordD, "dcdflag3", 0x04);

    pub const dsorg_dcddsgis = util.bitFlag(RecordD, "dcddsorg1", 0x80);
    pub const dsorg_dcddsgps = util.bitFlag(RecordD, "dcddsorg1", 0x40);
    pub const dsorg_dcddsgda = util.bitFlag(RecordD, "dcddsorg1", 0x20);
    pub const dsorg_dcddsgpo = util.bitFlag(RecordD, "dcddsorg1", 0x02);
    pub const dsorg_dcddsgu = util.bitFlag(RecordD, "dcddsorg1", 0x01);
    pub const dsorg_dcddsggs = util.bitFlag(RecordD, "dcddsorg2", 0x80);
    pub const dsorg_dcddsgvs = util.bitFlag(RecordD, "dcddsorg2", 0x08);

    pub const recrd_dcdrecff = util.bitFlag(RecordD, "dcdrecrd", 0x80);
    pub const recrd_dcdrecfv = util.bitFlag(RecordD, "dcdrecrd", 0x40);
    pub const recrd_dcdrecft = util.bitFlag(RecordD, "dcdrecrd", 0x20);
    pub const recrd_dcdrecfb = util.bitFlag(RecordD, "dcdrecrd", 0x10);
    pub const recrd_dcdrecfs = util.bitFlag(RecordD, "dcdrecrd", 0x08);
    pub const recrd_dcdrecfa = util.bitFlag(RecordD, "dcdrecrd", 0x04);
    pub const recrd_dcdrecfc = util.bitFlag(RecordD, "dcdrecrd", 0x02);

    pub const flag5_dcdallfx = util.bitFlag(RecordD, "dcdflag5", 0x80);
    pub const flag5_dcdusefx = util.bitFlag(RecordD, "dcdflag5", 0x40);
    pub const flag5_dcdscafx = util.bitFlag(RecordD, "dcdflag5", 0x20);
    pub const flag5_dcdnmbfx = util.bitFlag(RecordD, "dcdflag5", 0x10);

    pub inline fn bind(self: *RecordD, b: *common.Binder) !void {
        util.bcd2asc(&self.dcddsnam);
        try b.text(&self.dcddsnam);

        try b.boolean(self.error_dcdemngd());
        try b.boolean(self.error_dcdedvvr());
        try b.boolean(self.error_dcdnospc());
        try b.boolean(self.error_dcdvsami());
        try b.boolean(self.error_dcdnofm1());
        try b.boolean(self.flag1_dcdracfd());
        try b.boolean(self.flag1_dcdsmsm());
        try b.boolean(self.flag1_dcdtemp());
        try b.boolean(self.flag1_dcdpdse());
        try b.boolean(self.flag1_dcdgds());
        try b.boolean(self.flag1_dcdreblk());
        try b.boolean(self.flag1_dcdchind());
        try b.boolean(self.flag1_dcdckdsi());
        try b.boolean(self.flag2_dcdnovvr());
        try b.boolean(self.flag2_dcdintcg());
        try b.boolean(self.flag2_dcdinicf());
        try b.boolean(self.flag2_dcdallfg());
        try b.boolean(self.flag2_dcdusefg());
        try b.boolean(self.flag2_dcdsecfg());
        try b.boolean(self.flag2_dcdnmbfg());
        try b.boolean(self.flag3_dcdpdsex());
        try b.boolean(self.flag3_dcdstrp());
        try b.boolean(self.flag3_dcdddmex());
        try b.boolean(self.flag3_dcdcpoit());
        try b.boolean(self.flag3_dcdgt64k());
        try b.boolean(self.flag3_dcdcmptv());
        try b.boolean(self.dsorg_dcddsgis());
        try b.boolean(self.dsorg_dcddsgps());
        try b.boolean(self.dsorg_dcddsgda());
        try b.boolean(self.dsorg_dcddsgpo());
        try b.boolean(self.dsorg_dcddsgu());
        try b.boolean(self.dsorg_dcddsggs());
        try b.boolean(self.dsorg_dcddsgvs());

        const dcdrecfm = blk: {
            if (self.recrd_dcdrecff() and self.recrd_dcdrecfv()) {
                break :blk "U";
            } else if (self.recrd_dcdrecff()) {
                break :blk "F";
            } else if (self.recrd_dcdrecfv()) {
                break :blk "V";
            } else {
                break :blk "";
            }
        };
        try b.text(dcdrecfm);

        try b.boolean(self.recrd_dcdrecft());
        try b.boolean(self.recrd_dcdrecfb());
        try b.boolean(self.recrd_dcdrecfs());
        try b.boolean(self.recrd_dcdrecfa());
        try b.boolean(self.recrd_dcdrecfc());
        try b.int(self.dcdnmext);

        util.bcd2asc(&self.dcdvolsr);
        try b.text(&self.dcdvolsr);

        try b.int(self.dcdbklng);
        try b.int(self.dcdlrecl);
        try b.int(self.dcdallsp);
        try b.int(self.dcdusesp);
        try b.int(self.dcdscall);
        try b.int(self.dcdnmblk);

        var dcdcredt_str: [10]u8 = @splat(0);
        try util.dcdate(&dcdcredt_str, self.dcdcredt[0..]);
        try b.text(&dcdcredt_str);

        var dcdexpdt_str: [10]u8 = @splat(0);
        try util.dcdate(&dcdexpdt_str, self.dcdexpdt[0..]);
        try b.text(&dcdexpdt_str);

        var dcdlstrf_str: [10]u8 = @splat(0);
        try util.dcdate(&dcdlstrf_str, self.dcdlstrf[0..]);
        try b.text(&dcdlstrf_str);

        util.bcd2asc(&self.dcddsser);
        try b.text(&self.dcddsser);
        try b.int(self.dcdvolsq);

        // DCDLBKDT is an 8-byte STCK (TOD clock), not packed date + binary time.
        var dcdlbkdt_str: [23]u8 = undefined;
        try b.text(try util.stckTimestamp(&dcdlbkdt_str, &self.dcdlbkdt));

        util.bcd2asc(&self.dcdatcl);
        try b.text(&self.dcdatcl);
        util.bcd2asc(&self.dcdstgcl);
        try b.text(&self.dcdstgcl);
        util.bcd2asc(&self.dcdmgtcl);
        try b.text(&self.dcdmgtcl);
        util.bcd2asc(&self.dcdstgrp);
        try b.text(&self.dcdstgrp);

        try b.text(&std.fmt.bytesToHex(&self.dcdccsid, .upper));

        try b.int64(self.dcdudsiz);
        try b.int64(self.dcdcudsz);
        try b.int(self.dcdscnt);
        try b.int(self.dcdovera);

        util.bcd2asc(&self.dcdacct);
        try b.text(&self.dcdacct);

        try b.boolean(self.flag5_dcdallfx());
        try b.boolean(self.flag5_dcdusefx());
        try b.boolean(self.flag5_dcdscafx());
        try b.boolean(self.flag5_dcdnmbfx());

        util.bcd2asc(&self.dcdjbnmc);
        try b.text(&self.dcdjbnmc);
        util.bcd2asc(&self.dcdstnmc);
        try b.text(&self.dcdstnmc);

        try b.int64(self.dcdallsx);
        try b.int64(self.dcdusesx);
        try b.int64(self.dcdscalx);
        try b.int64(self.dcdnmblx);
        try b.int(self.dcdxpsev);
        try b.int(self.dcdctype);
        try b.int(self.dcdtype);

        const blank_klbl: [64]u8 = @splat(' ');
        const dcdklbl = blk: {
            if (self.dcdtype == 0xFFFF) {
                break :blk &blank_klbl;
            } else {
                util.bcd2asc(&self.dcdklbl);
                break :blk &self.dcdklbl;
            }
        };

        try b.text(dcdklbl);
    }
};

pub const Record = RecordD;
pub const record_key = "D ";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordD size: {d}\n", .{@sizeOf(RecordD)});
    try std.testing.expect(@sizeOf(RecordD) == 468);
}

test "DCDLBKDT is decoded as an STCK timestamp" {
    var t: common.TestHarness = undefined;
    try t.init();
    defer t.deinit();

    var rec: [468]u8 = @splat(0);
    std.mem.writeInt(u16, rec[0..2], rec.len, .big);
    common.TestHarness.putEbcdic(rec[4..6], "D ");
    const off = @offsetOf(RecordD, "dcdlbkdt");
    @memcpy(rec[off .. off + 8], &[_]u8{ 0xDE, 0xB9, 0x4C, 0x56, 0x70, 0x60, 0x80, 0x00 }); // 2024-02-29 12:34:56.789
    try common.processRecord(&t.ctx, &rec);
    try std.testing.expectEqualStrings("2024-02-29 12:34:56.789", try t.queryText("SELECT dcdlbkdt FROM record_d"));
}
