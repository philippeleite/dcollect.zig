const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Context = common.Context;
const Database = common.Database;
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

    pub inline fn bind(self: *RecordD, db: *Database, stmt: common.Stmt) !void {
        util.bcd2asc(&self.dcddsnam);
        try db.bindText(stmt, 1, &self.dcddsnam);

        try db.bindBool(stmt, 2, self.error_dcdemngd());
        try db.bindBool(stmt, 3, self.error_dcdedvvr());
        try db.bindBool(stmt, 4, self.error_dcdnospc());
        try db.bindBool(stmt, 5, self.error_dcdvsami());
        try db.bindBool(stmt, 6, self.error_dcdnofm1());
        try db.bindBool(stmt, 7, self.flag1_dcdracfd());
        try db.bindBool(stmt, 8, self.flag1_dcdsmsm());
        try db.bindBool(stmt, 9, self.flag1_dcdtemp());
        try db.bindBool(stmt, 10, self.flag1_dcdpdse());
        try db.bindBool(stmt, 11, self.flag1_dcdgds());
        try db.bindBool(stmt, 12, self.flag1_dcdreblk());
        try db.bindBool(stmt, 13, self.flag1_dcdchind());
        try db.bindBool(stmt, 14, self.flag1_dcdckdsi());
        try db.bindBool(stmt, 15, self.flag2_dcdnovvr());
        try db.bindBool(stmt, 16, self.flag2_dcdintcg());
        try db.bindBool(stmt, 17, self.flag2_dcdinicf());
        try db.bindBool(stmt, 18, self.flag2_dcdallfg());
        try db.bindBool(stmt, 19, self.flag2_dcdusefg());
        try db.bindBool(stmt, 20, self.flag2_dcdsecfg());
        try db.bindBool(stmt, 21, self.flag2_dcdnmbfg());
        try db.bindBool(stmt, 22, self.flag3_dcdpdsex());
        try db.bindBool(stmt, 23, self.flag3_dcdstrp());
        try db.bindBool(stmt, 24, self.flag3_dcdddmex());
        try db.bindBool(stmt, 25, self.flag3_dcdcpoit());
        try db.bindBool(stmt, 26, self.flag3_dcdgt64k());
        try db.bindBool(stmt, 27, self.flag3_dcdcmptv());
        try db.bindBool(stmt, 28, self.dsorg_dcddsgis());
        try db.bindBool(stmt, 29, self.dsorg_dcddsgps());
        try db.bindBool(stmt, 30, self.dsorg_dcddsgda());
        try db.bindBool(stmt, 31, self.dsorg_dcddsgpo());
        try db.bindBool(stmt, 32, self.dsorg_dcddsgu());
        try db.bindBool(stmt, 33, self.dsorg_dcddsggs());
        try db.bindBool(stmt, 34, self.dsorg_dcddsgvs());

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
        try db.bindText(stmt, 35, dcdrecfm);

        try db.bindBool(stmt, 36, self.recrd_dcdrecft());
        try db.bindBool(stmt, 37, self.recrd_dcdrecfb());
        try db.bindBool(stmt, 38, self.recrd_dcdrecfs());
        try db.bindBool(stmt, 39, self.recrd_dcdrecfa());
        try db.bindBool(stmt, 40, self.recrd_dcdrecfc());
        try db.bindInt(stmt, 41, self.dcdnmext);

        util.bcd2asc(&self.dcdvolsr);
        try db.bindText(stmt, 42, &self.dcdvolsr);

        try db.bindInt(stmt, 43, self.dcdbklng);
        try db.bindInt(stmt, 44, self.dcdlrecl);
        try db.bindInt(stmt, 45, self.dcdallsp);
        try db.bindInt(stmt, 46, self.dcdusesp);
        try db.bindInt(stmt, 47, self.dcdscall);
        try db.bindInt(stmt, 48, self.dcdnmblk);

        var dcdcredt_str: [10]u8 = .{0} ** 10;
        try util.dcdate(&dcdcredt_str, self.dcdcredt[0..]);
        try db.bindText(stmt, 49, &dcdcredt_str);

        var dcdexpdt_str: [10]u8 = .{0} ** 10;
        try util.dcdate(&dcdexpdt_str, self.dcdexpdt[0..]);
        try db.bindText(stmt, 50, &dcdexpdt_str);

        var dcdlstrf_str: [10]u8 = .{0} ** 10;
        try util.dcdate(&dcdlstrf_str, self.dcdlstrf[0..]);
        try db.bindText(stmt, 51, &dcdlstrf_str);

        util.bcd2asc(&self.dcddsser);
        try db.bindText(stmt, 52, &self.dcddsser);
        try db.bindInt(stmt, 53, self.dcdvolsq);

        var dcdlbkdt1: [10]u8 = .{0} ** 10;
        var dcdlbkdt2: [12]u8 = .{0} ** 12;
        try util.dcdate(&dcdlbkdt1, self.dcdlbkdt[0..4]);
        try util.smftime(&dcdlbkdt2, self.dcdlbkdt[4..8]);
        try db.bindText(stmt, 54, &dcdlbkdt1 ++ " " ++ &dcdlbkdt2);

        util.bcd2asc(&self.dcdatcl);
        try db.bindText(stmt, 55, &self.dcdatcl);
        util.bcd2asc(&self.dcdstgcl);
        try db.bindText(stmt, 56, &self.dcdstgcl);
        util.bcd2asc(&self.dcdmgtcl);
        try db.bindText(stmt, 57, &self.dcdmgtcl);
        util.bcd2asc(&self.dcdstgrp);
        try db.bindText(stmt, 58, &self.dcdstgrp);

        try db.bindText(stmt, 59, &std.fmt.bytesToHex(&self.dcdccsid, .upper));

        try db.bindInt64(stmt, 60, self.dcdudsiz);
        try db.bindInt64(stmt, 61, self.dcdcudsz);
        try db.bindInt(stmt, 62, self.dcdscnt);
        try db.bindInt(stmt, 63, self.dcdovera);

        util.bcd2asc(&self.dcdacct);
        try db.bindText(stmt, 64, &self.dcdacct);

        try db.bindBool(stmt, 65, self.flag5_dcdallfx());
        try db.bindBool(stmt, 66, self.flag5_dcdusefx());
        try db.bindBool(stmt, 67, self.flag5_dcdscafx());
        try db.bindBool(stmt, 68, self.flag5_dcdnmbfx());

        util.bcd2asc(&self.dcdjbnmc);
        try db.bindText(stmt, 69, &self.dcdjbnmc);
        util.bcd2asc(&self.dcdstnmc);
        try db.bindText(stmt, 70, &self.dcdstnmc);

        try db.bindInt64(stmt, 71, self.dcdallsx);
        try db.bindInt64(stmt, 72, self.dcdusesx);
        try db.bindInt64(stmt, 73, self.dcdscalx);
        try db.bindInt64(stmt, 74, self.dcdnmblx);
        try db.bindInt(stmt, 75, self.dcdxpsev);
        try db.bindInt(stmt, 76, self.dcdctype);
        try db.bindInt(stmt, 77, self.dcdtype);

        const dcdklbl = blk: {
            if (self.dcdtype == 0xFFFF) {
                break :blk " " ** 64;
            } else {
                util.bcd2asc(&self.dcdklbl);
                break :blk &self.dcdklbl;
            }
        };

        try db.bindText(stmt, 78, dcdklbl);
    }
};

pub const Record = RecordD;
pub const record_key = "D ";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordD size: {d}\n", .{@sizeOf(RecordD)});
    try std.testing.expect(@sizeOf(RecordD) == 468);
}
