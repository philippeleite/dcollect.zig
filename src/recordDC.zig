const Header = @import("records.zig").Header;

pub const RecordDC = extern struct {
    header: Header,
    ddcnmlen: u16,
    ddcname: [30]u8,
    ddcuser: [8]u8,
    ddcdate: [10]u8,
    _res1: [2]u8,
    ddctime: [8]u8,
    ddcdesc: [120]u8,
    ddcspec1: [1]u8,
    ddcspec2: [1]u8,
    ddcspec3: [1]u8,
    ddcspec4: [1]u8,
    ddcrcorg: u8,
    ddcrecfm: u8,
    ddcdsflg: [1]u8,
    ddccntl: u8,
    ddcexpyr: i16,
    ddcexpdy: i16,
    ddcvolct: i16,
    ddcdsnty: u16,
    ddcsppri: i32 align(1),
    ddcspsec: i32 align(1),
    ddcdiblk: i32 align(1),
    ddcavrec: u8,
    ddcreduc: u8,
    ddcrbias: u8,
    ddcdvc: u8,
    ddcaunit: i32 align(1),
    _resx: [4]u8,
    ddclrecl: i32 align(1),
    ddccisz: i32 align(1),
    ddccipct: i16,
    ddccapct: i16,
    ddcxreg: u8,
    ddcxsys: u8,
    ddcvindx: u8,
    ddcklen: u8,
    ddckoff: i16,
    ddccamt: u8,
    _res2: [1]u8,
    ddccomp: u8,
    ddcmedia: u8,
    ddcrecte: u8,
    _res3: [1]u8,
    ddcbwotp: u8,
    ddclogrc: u8,
    ddcspand: u8,
    ddcfrlog: u8,
    ddclogln: u16,
    ddclogid: [26]u8,
    ddcspeca: u8,
    ddcspecb: u8,
    ddcspecc: u8,
    ddcspecd: u8,
    ddcsflg: u8,
    ddcvbyt1: u8,
    _res4: [3]u8,
    ddceattr: u8,
    ddcct: u8,
    ddcdscf: u8,
    ddcrbyte: u8,
    _res5: [4]u8,
    ddcbszlm: u32 align(1),
    ddcpsca: u8,
    ddcpseg: u8,
    _res6: [5]u8,
    ddcvsp: u8,
    ddcvspv: [3]u8, //TODO convert to u32
    ddcklbl1: u16,
    ddcklbn1: [64]u8,
    ddckycd1: u8,
    _res7: [1]u8,
    ddcklbl2: u16,
    ddcklbn2: [64]u8,
    ddckycd2: u8,
    _res8: [2]u8,
    ddcrmode: u8,
    ddcdklbl: u16,
    ddcdklbn: [64]u8,
    _res9: [28]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_dc;
        \\ CREATE TABLE record_dc (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     ddcname TEXT NOT NULL DEFAULT '',
        \\     ddcuser TEXT NOT NULL DEFAULT '',
        \\     ddcdate TEXT NOT NULL DEFAULT '',
        \\     ddctime TEXT NOT NULL DEFAULT '',
        \\     ddcdesc TEXT NOT NULL DEFAULT '',
        \\     ddcfrorg BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcflrec BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfrfm BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfklen BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfkoff BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfexp BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfret BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfpsp BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfssp BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfdir BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfaun BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfavr BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfvol BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfcis BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfcif BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfcaf BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfxreg BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfxsys BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfimbd BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfrplc BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfcomp BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfmedi BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfrect BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfvea BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcsprlf BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcredus BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcrabs BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfct BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcblmt BOOLEAN NOT NULL DEFAULT 0,
        \\     ddccfs BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcdvcs BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfscal BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcrcorg SMALLINT NOT NULL DEFAULT 0,
        \\     ddcrecfm SMALLINT NOT NULL DEFAULT 0,
        \\     ddcblk BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcstsp BOOLEAN NOT NULL DEFAULT 0,
        \\     ddccntl SMALLINT NOT NULL DEFAULT 0,
        \\     ddcexpyr INTEGER NOT NULL DEFAULT 0,
        \\     ddcexpdy INTEGER NOT NULL DEFAULT 0,
        \\     ddcvolct INTEGER NOT NULL DEFAULT 0,
        \\     ddcdsnty INTEGER NOT NULL DEFAULT 0,
        \\     ddcsppri INTEGER NOT NULL DEFAULT 0,
        \\     ddcspsec INTEGER NOT NULL DEFAULT 0,
        \\     ddcdiblk INTEGER NOT NULL DEFAULT 0,
        \\     ddcavrec SMALLINT NOT NULL DEFAULT 0,
        \\     ddcreduc SMALLINT NOT NULL DEFAULT 0,
        \\     ddcrbias SMALLINT NOT NULL DEFAULT 0,
        \\     ddcdvc SMALLINT NOT NULL DEFAULT 0,
        \\     ddcaunit INTEGER NOT NULL DEFAULT 0,
        \\     ddclrecl INTEGER NOT NULL DEFAULT 0,
        \\     ddccisz INTEGER NOT NULL DEFAULT 0,
        \\     ddccipct SMALLINT NOT NULL DEFAULT 0,
        \\     ddccapct SMALLINT NOT NULL DEFAULT 0,
        \\     ddcxreg SMALLINT NOT NULL DEFAULT 0,
        \\     ddcxsys SMALLINT NOT NULL DEFAULT 0,
        \\     ddcimbed BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcreplc BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcklen SMALLINT NOT NULL DEFAULT 0,
        \\     ddckoff INTEGER NOT NULL DEFAULT 0,
        \\     ddccamt SMALLINT NOT NULL DEFAULT 0,
        \\     ddccomp SMALLINT NOT NULL DEFAULT 0,
        \\     ddcmedia SMALLINT NOT NULL DEFAULT 0,
        \\     ddcrecte SMALLINT NOT NULL DEFAULT 0,
        \\     ddcbwotp SMALLINT NOT NULL DEFAULT 0,
        \\     ddclogrc SMALLINT NOT NULL DEFAULT 0,
        \\     ddcspand SMALLINT NOT NULL DEFAULT 0,
        \\     ddcfrlog SMALLINT NOT NULL DEFAULT 0,
        \\     ddclogid TEXT NOT NULL DEFAULT '',
        \\     ddcbwos BOOLEAN NOT NULL DEFAULT 0,
        \\     ddclogrs BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcspans BOOLEAN NOT NULL DEFAULT 0,
        \\     ddclsids BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfrlgs BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfextc BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfa2gb BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfpseg BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfkyl1 BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfkyc1 BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfkyl2 BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfkyc2 BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfvsp BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfsdb BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfovrd BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfcar BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfattr BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcflogr BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfrmod BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcgsrdu BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcfklbl BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcovrd BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcsdb BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcreuse BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcspeed BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcex255 BOOLEAN NOT NULL DEFAULT 0,
        \\     ddclogrp BOOLEAN NOT NULL DEFAULT 0,
        \\     ddceattr SMALLINT NOT NULL DEFAULT 0,
        \\     ddcct SMALLINT NOT NULL DEFAULT 0,
        \\     ddcdscf SMALLINT NOT NULL DEFAULT 0,
        \\     ddca2gb BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcreclm BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcbszlm INTEGER NOT NULL DEFAULT 0,
        \\     ddcpsca SMALLINT NOT NULL DEFAULT 0,
        \\     ddcpseg SMALLINT NOT NULL DEFAULT 0,
        \\     ddcvspuk BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcvspum BOOLEAN NOT NULL DEFAULT 0,
        \\     ddcvspv INTEGER NOT NULL DEFAULT 0,
        \\     ddcklbn1 TEXT NOT NULL DEFAULT '',
        \\     ddckycd1 SMALLINT NOT NULL DEFAULT 0,
        \\     ddcklbn2 TEXT NOT NULL DEFAULT '',
        \\     ddckycd2 SMALLINT NOT NULL DEFAULT 0,
        \\     ddcrmode SMALLINT NOT NULL DEFAULT 0,
        \\     ddcdklbn TEXT NOT NULL DEFAULT ''
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_dc (
        \\     ddcname,
        \\     ddcuser,
        \\     ddcdate,
        \\     ddctime,
        \\     ddcdesc,
        \\     ddcfrorg,
        \\     ddcflrec,
        \\     ddcfrfm,
        \\     ddcfklen,
        \\     ddcfkoff,
        \\     ddcfexp,
        \\     ddcfret,
        \\     ddcfpsp,
        \\     ddcfssp,
        \\     ddcfdir,
        \\     ddcfaun,
        \\     ddcfavr,
        \\     ddcfvol,
        \\     ddcfcis,
        \\     ddcfcif,
        \\     ddcfcaf,
        \\     ddcfxreg,
        \\     ddcfxsys,
        \\     ddcfimbd,
        \\     ddcfrplc,
        \\     ddcfcomp,
        \\     ddcfmedi,
        \\     ddcfrect,
        \\     ddcfvea,
        \\     ddcsprlf,
        \\     ddcredus,
        \\     ddcrabs,
        \\     ddcfct,
        \\     ddcblmt, 
        \\     ddccfs,
        \\     ddcdvcs, 
        \\     ddcfscal,
        \\     ddcrcorg,
        \\     ddcrecfm,
        \\     ddcblk,
        \\     ddcstsp, 
        \\     ddccntl,
        \\     ddcexpyr,
        \\     ddcexpdy,
        \\     ddcvolct,
        \\     ddcdsnty,
        \\     ddcsppri,
        \\     ddcspsec,
        \\     ddcdiblk,
        \\     ddcavrec,
        \\     ddcreduc,
        \\     ddcrbias,
        \\     ddcdvc,
        \\     ddcaunit,
        \\     ddclrecl,
        \\     ddccisz,
        \\     ddccipct,
        \\     ddccapct,
        \\     ddcxreg,
        \\     ddcxsys,
        \\     ddcimbed,
        \\     ddcreplc,
        \\     ddcklen,
        \\     ddckoff,
        \\     ddccamt,
        \\     ddccomp,
        \\     ddcmedia,
        \\     ddcrecte,
        \\     ddcbwotp,
        \\     ddclogrc,
        \\     ddcspand,
        \\     ddcfrlog,
        \\     ddclogid,
        \\     ddcbwos,
        \\     ddclogrs,
        \\     ddcspans,
        \\     ddclsids,
        \\     ddcfrlgs,
        \\     ddcfextc,
        \\     ddcfa2gb,
        \\     ddcfpseg,
        \\     ddcfkyl1,
        \\     ddcfkyc1,
        \\     ddcfkyl2,
        \\     ddcfkyc2,
        \\     ddcfvsp,
        \\     ddcfsdb,
        \\     ddcfovrd,
        \\     ddcfcar,
        \\     ddcfattr,
        \\     ddcflogr,
        \\     ddcfrmod,
        \\     ddcgsrdu,
        \\     ddcfklbl,
        \\     ddcovrd,
        \\     ddcsdb,
        \\     ddcreuse,
        \\     ddcspeed,
        \\     ddcex255,
        \\     ddclogrp,
        \\     ddceattr,
        \\     ddcct,
        \\     ddcdscf,
        \\     ddca2gb,
        \\     ddcreclm,
        \\     ddcbszlm,
        \\     ddcpsca,
        \\     ddcpseg,
        \\     ddcvspuk,
        \\     ddcvspum,
        \\     ddcvspv,
        \\     ddcklbn1,
        \\     ddckycd1,
        \\     ddcklbn2,
        \\     ddckycd2,
        \\     ddcrmode,
        \\     ddcdklbn
        \\ ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,
        \\           ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,
        \\           ?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub fn spec1_ddcfrorg(self: *RecordDC) bool {
        return self.ddcspec1[0] & 0x80 != 0;
    }

    pub fn spec1_ddcflrec(self: *RecordDC) bool {
        return self.ddcspec1[0] & 0x40 != 0;
    }

    pub fn spec1_ddcfrfm(self: *RecordDC) bool {
        return self.ddcspec1[0] & 0x20 != 0;
    }

    pub fn spec1_ddcfklen(self: *RecordDC) bool {
        return self.ddcspec1[0] & 0x10 != 0;
    }

    pub fn spec1_ddcfkoff(self: *RecordDC) bool {
        return self.ddcspec1[0] & 0x08 != 0;
    }

    pub fn spec1_ddcfexp(self: *RecordDC) bool {
        return self.ddcspec1[0] & 0x04 != 0;
    }

    pub fn spec1_ddcfret(self: *RecordDC) bool {
        return self.ddcspec1[0] & 0x02 != 0;
    }

    pub fn spec1_ddcfpsp(self: *RecordDC) bool {
        return self.ddcspec1[0] & 0x01 != 0;
    }

    pub fn spec2_ddcfssp(self: *RecordDC) bool {
        return self.ddcspec2[0] & 0x80 != 0;
    }

    pub fn spec2_ddcfdir(self: *RecordDC) bool {
        return self.ddcspec2[0] & 0x40 != 0;
    }

    pub fn spec2_ddcfaun(self: *RecordDC) bool {
        return self.ddcspec2[0] & 0x20 != 0;
    }

    pub fn spec2_ddcfavr(self: *RecordDC) bool {
        return self.ddcspec2[0] & 0x10 != 0;
    }

    pub fn spec2_ddcfvol(self: *RecordDC) bool {
        return self.ddcspec2[0] & 0x08 != 0;
    }

    pub fn spec2_ddcfcis(self: *RecordDC) bool {
        return self.ddcspec2[0] & 0x04 != 0;
    }

    pub fn spec2_ddcfcif(self: *RecordDC) bool {
        return self.ddcspec2[0] & 0x02 != 0;
    }

    pub fn spec2_ddcfcaf(self: *RecordDC) bool {
        return self.ddcspec2[0] & 0x01 != 0;
    }

    pub fn spec3_ddcfxreg(self: *RecordDC) bool {
        return self.ddcspec3[0] & 0x80 != 0;
    }

    pub fn spec3_ddcfxsys(self: *RecordDC) bool {
        return self.ddcspec3[0] & 0x40 != 0;
    }

    pub fn spec3_ddcfimbd(self: *RecordDC) bool {
        return self.ddcspec3[0] & 0x20 != 0;
    }

    pub fn spec3_ddcfrplc(self: *RecordDC) bool {
        return self.ddcspec3[0] & 0x10 != 0;
    }

    pub fn spec3_ddcfcomp(self: *RecordDC) bool {
        return self.ddcspec3[0] & 0x08 != 0;
    }

    pub fn spec3_ddcfmedi(self: *RecordDC) bool {
        return self.ddcspec3[0] & 0x04 != 0;
    }

    pub fn spec3_ddcfrect(self: *RecordDC) bool {
        return self.ddcspec3[0] & 0x02 != 0;
    }

    pub fn spec3_ddcfvea(self: *RecordDC) bool {
        return self.ddcspec3[0] & 0x01 != 0;
    }

    pub fn spec4_ddcsprlf(self: *RecordDC) bool {
        return self.ddcspec4[0] & 0x80 != 0;
    }

    pub fn spec4_ddcredus(self: *RecordDC) bool {
        return self.ddcspec4[0] & 0x40 != 0;
    }

    pub fn spec4_ddcrabs(self: *RecordDC) bool {
        return self.ddcspec4[0] & 0x20 != 0;
    }

    pub fn spec4_ddcfct(self: *RecordDC) bool {
        return self.ddcspec4[0] & 0x10 != 0;
    }

    pub fn spec4_ddcblmt(self: *RecordDC) bool {
        return self.ddcspec4[0] & 0x08 != 0;
    }

    pub fn spec4_ddccfs(self: *RecordDC) bool {
        return self.ddcspec4[0] & 0x04 != 0;
    }

    pub fn spec4_ddcdvcs(self: *RecordDC) bool {
        return self.ddcspec4[0] & 0x02 != 0;
    }

    pub fn spec4_ddcfscal(self: *RecordDC) bool {
        return self.ddcspec4[0] & 0x01 != 0;
    }

    pub fn dsflg_ddcblk(self: *RecordDC) bool {
        return self.ddcdsflg[0] & 0x80 != 0;
    }

    pub fn dsflg_ddcstsp(self: *RecordDC) bool {
        return self.ddcdsflg[0] & 0x40 != 0;
    }

    pub fn vindx_ddcimbed(self: *RecordDC) bool {
        return self.ddcvindx & 0x80 != 0;
    }

    pub fn vindx_ddcreplc(self: *RecordDC) bool {
        return self.ddcvindx & 0x40 != 0;
    }

    pub fn speca_ddcbwos(self: *RecordDC) bool {
        return self.ddcspeca & 0x80 != 0;
    }

    pub fn speca_ddclogrs(self: *RecordDC) bool {
        return self.ddcspeca & 0x40 != 0;
    }

    pub fn speca_ddcspans(self: *RecordDC) bool {
        return self.ddcspeca & 0x20 != 0;
    }

    pub fn speca_ddclsids(self: *RecordDC) bool {
        return self.ddcspeca & 0x10 != 0;
    }

    pub fn speca_ddcfrlgs(self: *RecordDC) bool {
        return self.ddcspeca & 0x08 != 0;
    }

    pub fn speca_ddcfextc(self: *RecordDC) bool {
        return self.ddcspeca & 0x04 != 0;
    }

    pub fn speca_ddcfa2gb(self: *RecordDC) bool {
        return self.ddcspeca & 0x02 != 0;
    }

    pub fn speca_ddcfpseg(self: *RecordDC) bool {
        return self.ddcspeca & 0x01 != 0;
    }

    pub fn specb_ddcfkyl1(self: *RecordDC) bool {
        return self.ddcspecb & 0x80 != 0;
    }

    pub fn specb_ddcfkyc1(self: *RecordDC) bool {
        return self.ddcspecb & 0x40 != 0;
    }

    pub fn specb_ddcfkyl2(self: *RecordDC) bool {
        return self.ddcspecb & 0x20 != 0;
    }

    pub fn specb_ddcfkyc2(self: *RecordDC) bool {
        return self.ddcspecb & 0x10 != 0;
    }

    pub fn specb_ddcfvsp(self: *RecordDC) bool {
        return self.ddcspecb & 0x08 != 0;
    }

    pub fn specb_ddcfsdb(self: *RecordDC) bool {
        return self.ddcspecb & 0x04 != 0;
    }

    pub fn specb_ddcfovrd(self: *RecordDC) bool {
        return self.ddcspecb & 0x02 != 0;
    }

    pub fn specb_ddcfcar(self: *RecordDC) bool {
        return self.ddcspecb & 0x01 != 0;
    }

    pub fn specc_ddcfattr(self: *RecordDC) bool {
        return self.ddcspecc & 0x80 != 0;
    }

    pub fn specc_ddcflogr(self: *RecordDC) bool {
        return self.ddcspecc & 0x40 != 0;
    }

    pub fn specc_ddcfrmod(self: *RecordDC) bool {
        return self.ddcspecc & 0x20 != 0;
    }

    pub fn specc_ddcgsrdu(self: *RecordDC) bool {
        return self.ddcspecc & 0x10 != 0;
    }

    pub fn specc_ddcfklbl(self: *RecordDC) bool {
        return self.ddcspecc & 0x08 != 0;
    }

    pub fn sflg_ddcovrd(self: *RecordDC) bool {
        return self.ddcsflg & 0x80 != 0;
    }

    pub fn sflg_ddcsdb(self: *RecordDC) bool {
        return self.ddcsflg & 0x40 != 0;
    }

    pub fn vbyt1_ddcreuse(self: *RecordDC) bool {
        return self.ddcvbyt1 & 0x80 != 0;
    }

    pub fn vbyt1_ddcspeed(self: *RecordDC) bool {
        return self.ddcvbyt1 & 0x40 != 0;
    }

    pub fn vbyt1_ddcex255(self: *RecordDC) bool {
        return self.ddcvbyt1 & 0x20 != 0;
    }

    pub fn vbyt1_ddclogrp(self: *RecordDC) bool {
        return self.ddcvbyt1 & 0x10 != 0;
    }

    pub fn rbyte_ddca2gb(self: *RecordDC) bool {
        return self.ddcrbyte & 0x80 != 0;
    }

    pub fn rbyte_ddcreclm(self: *RecordDC) bool {
        return self.ddcrbyte & 0x40 != 0;
    }

    pub fn vsp_ddcvspuk(self: *RecordDC) bool {
        return self.ddcvsp & 0x80 != 0;
    }

    pub fn vsp_ddcvspum(self: *RecordDC) bool {
        return self.ddcvsp & 0x40 != 0;
    }
};
