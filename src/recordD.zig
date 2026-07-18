const Header = @import("records.zig").Header;

pub const RecordD = extern struct {
    header: Header,
    dcddsnam: [44]u8,
    dcderror: [1]u8,
    dcdflag1: [1]u8,
    dcdflag2: [1]u8,
    dcdflag3: [1]u8,
    _res1: [2]u8,
    dcddsorg: [2]u8,
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

    pub fn error_dcdemngd(self: *RecordD) bool {
        return self.dcderror[0] & 0x80 != 0;
    }

    pub fn error_dcdedvvr(self: *RecordD) bool {
        return self.dcderror[0] & 0x40 != 0;
    }

    pub fn error_dcdnospc(self: *RecordD) bool {
        return self.dcderror[0] & 0x20 != 0;
    }

    pub fn error_dcdvsami(self: *RecordD) bool {
        return self.dcderror[0] & 0x10 != 0;
    }

    pub fn error_dcdnofm1(self: *RecordD) bool {
        return self.dcderror[0] & 0x08 != 0;
    }

    pub fn flag1_dcdracfd(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x80 != 0;
    }

    pub fn flag1_dcdsmsm(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x40 != 0;
    }

    pub fn flag1_dcdtemp(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x20 != 0;
    }

    pub fn flag1_dcdpdse(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x10 != 0;
    }

    pub fn flag1_dcdgds(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x08 != 0;
    }

    pub fn flag1_dcdreblk(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x04 != 0;
    }

    pub fn flag1_dcdchind(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x02 != 0;
    }

    pub fn flag1_dcdckdsi(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x01 != 0;
    }

    pub fn flag2_dcdnovvr(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x80 != 0;
    }

    pub fn flag2_dcdintcg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x40 != 0;
    }

    pub fn flag2_dcdinicf(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x20 != 0;
    }

    pub fn flag2_dcdallfg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x08 != 0;
    }

    pub fn flag2_dcdusefg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x04 != 0;
    }

    pub fn flag2_dcdsecfg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x02 != 0;
    }

    pub fn flag2_dcdnmbfg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x01 != 0;
    }

    pub fn flag3_dcdpdsex(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x80 != 0;
    }

    pub fn flag3_dcdstrp(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x40 != 0;
    }

    pub fn flag3_dcdddmex(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x20 != 0;
    }

    pub fn flag3_dcdcpoit(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x10 != 0;
    }

    pub fn flag3_dcdgt64k(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x08 != 0;
    }

    pub fn flag3_dcdcmptv(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x04 != 0;
    }

    pub fn dsorg_dcddsgis(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x80 != 0;
    }

    pub fn dsorg_dcddsgps(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x40 != 0;
    }

    pub fn dsorg_dcddsgda(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x20 != 0;
    }

    pub fn dsorg_dcddsgpo(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x02 != 0;
    }

    pub fn dsorg_dcddsgu(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x01 != 0;
    }

    pub fn dsorg_dcddsggs(self: *RecordD) bool {
        return self.dcddsorg[1] & 0x80 != 0;
    }

    pub fn dsorg_dcddsgvs(self: *RecordD) bool {
        return self.dcddsorg[1] & 0x08 != 0;
    }

    pub fn recrd_dcdrecff(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x80 != 0;
    }

    pub fn recrd_dcdrecfv(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x40 != 0;
    }

    pub fn recrd_dcdrecft(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x20 != 0;
    }

    pub fn recrd_dcdrecfb(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x10 != 0;
    }

    pub fn recrd_dcdrecfs(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x08 != 0;
    }

    pub fn recrd_dcdrecfa(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x04 != 0;
    }

    pub fn recrd_dcdrecfc(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x02 != 0;
    }

    pub fn flag5_dcdallfx(self: *RecordD) bool {
        return self.dcdflag5[0] & 0x80 != 0;
    }

    pub fn flag5_dcdusefx(self: *RecordD) bool {
        return self.dcdflag5[0] & 0x40 != 0;
    }

    pub fn flag5_dcdscafx(self: *RecordD) bool {
        return self.dcdflag5[0] & 0x20 != 0;
    }

    pub fn flag5_dcdnmbfx(self: *RecordD) bool {
        return self.dcdflag5[0] & 0x10 != 0;
    }
};
