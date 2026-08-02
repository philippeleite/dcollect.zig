const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Context = common.Context;
const Database = common.Database;
const Header = common.Header;

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
    ddcvindx: [1]u8,
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
    ddcspeca: [1]u8,
    ddcspecb: [1]u8,
    ddcspecc: [1]u8,
    ddcspecd: [1]u8,
    ddcsflg: [1]u8,
    ddcvbyt1: [1]u8,
    _res4: [3]u8,
    ddceattr: u8,
    ddcct: u8,
    ddcdscf: u8,
    ddcrbyte: [1]u8,
    _res5: [4]u8,
    ddcbszlm: u32 align(1),
    ddcpsca: u8,
    ddcpseg: u8,
    _res6: [5]u8,
    ddcvsp: [1]u8,
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

    pub const spec1_ddcfrorg = util.bitFlag(RecordDC, "ddcspec1", 0x80);
    pub const spec1_ddcflrec = util.bitFlag(RecordDC, "ddcspec1", 0x40);
    pub const spec1_ddcfrfm = util.bitFlag(RecordDC, "ddcspec1", 0x20);
    pub const spec1_ddcfklen = util.bitFlag(RecordDC, "ddcspec1", 0x10);
    pub const spec1_ddcfkoff = util.bitFlag(RecordDC, "ddcspec1", 0x08);
    pub const spec1_ddcfexp = util.bitFlag(RecordDC, "ddcspec1", 0x04);
    pub const spec1_ddcfret = util.bitFlag(RecordDC, "ddcspec1", 0x02);
    pub const spec1_ddcfpsp = util.bitFlag(RecordDC, "ddcspec1", 0x01);

    pub const spec2_ddcfssp = util.bitFlag(RecordDC, "ddcspec2", 0x80);
    pub const spec2_ddcfdir = util.bitFlag(RecordDC, "ddcspec2", 0x40);
    pub const spec2_ddcfaun = util.bitFlag(RecordDC, "ddcspec2", 0x20);
    pub const spec2_ddcfavr = util.bitFlag(RecordDC, "ddcspec2", 0x10);
    pub const spec2_ddcfvol = util.bitFlag(RecordDC, "ddcspec2", 0x08);
    pub const spec2_ddcfcis = util.bitFlag(RecordDC, "ddcspec2", 0x04);
    pub const spec2_ddcfcif = util.bitFlag(RecordDC, "ddcspec2", 0x02);
    pub const spec2_ddcfcaf = util.bitFlag(RecordDC, "ddcspec2", 0x01);

    pub const spec3_ddcfxreg = util.bitFlag(RecordDC, "ddcspec3", 0x80);
    pub const spec3_ddcfxsys = util.bitFlag(RecordDC, "ddcspec3", 0x40);
    pub const spec3_ddcfimbd = util.bitFlag(RecordDC, "ddcspec3", 0x20);
    pub const spec3_ddcfrplc = util.bitFlag(RecordDC, "ddcspec3", 0x10);
    pub const spec3_ddcfcomp = util.bitFlag(RecordDC, "ddcspec3", 0x08);
    pub const spec3_ddcfmedi = util.bitFlag(RecordDC, "ddcspec3", 0x04);
    pub const spec3_ddcfrect = util.bitFlag(RecordDC, "ddcspec3", 0x02);
    pub const spec3_ddcfvea = util.bitFlag(RecordDC, "ddcspec3", 0x01);

    pub const spec4_ddcsprlf = util.bitFlag(RecordDC, "ddcspec4", 0x80);
    pub const spec4_ddcredus = util.bitFlag(RecordDC, "ddcspec4", 0x40);
    pub const spec4_ddcrabs = util.bitFlag(RecordDC, "ddcspec4", 0x20);
    pub const spec4_ddcfct = util.bitFlag(RecordDC, "ddcspec4", 0x10);
    pub const spec4_ddcblmt = util.bitFlag(RecordDC, "ddcspec4", 0x08);
    pub const spec4_ddccfs = util.bitFlag(RecordDC, "ddcspec4", 0x04);
    pub const spec4_ddcdvcs = util.bitFlag(RecordDC, "ddcspec4", 0x02);
    pub const spec4_ddcfscal = util.bitFlag(RecordDC, "ddcspec4", 0x01);

    pub const dsflg_ddcblk = util.bitFlag(RecordDC, "ddcdsflg", 0x80);
    pub const dsflg_ddcstsp = util.bitFlag(RecordDC, "ddcdsflg", 0x40);

    pub const vindx_ddcimbed = util.bitFlag(RecordDC, "ddcvindx", 0x80);
    pub const vindx_ddcreplc = util.bitFlag(RecordDC, "ddcvindx", 0x40);

    pub const speca_ddcbwos = util.bitFlag(RecordDC, "ddcspeca", 0x80);
    pub const speca_ddclogrs = util.bitFlag(RecordDC, "ddcspeca", 0x40);
    pub const speca_ddcspans = util.bitFlag(RecordDC, "ddcspeca", 0x20);
    pub const speca_ddclsids = util.bitFlag(RecordDC, "ddcspeca", 0x10);
    pub const speca_ddcfrlgs = util.bitFlag(RecordDC, "ddcspeca", 0x08);
    pub const speca_ddcfextc = util.bitFlag(RecordDC, "ddcspeca", 0x04);
    pub const speca_ddcfa2gb = util.bitFlag(RecordDC, "ddcspeca", 0x02);
    pub const speca_ddcfpseg = util.bitFlag(RecordDC, "ddcspeca", 0x01);

    pub const specb_ddcfkyl1 = util.bitFlag(RecordDC, "ddcspecb", 0x80);
    pub const specb_ddcfkyc1 = util.bitFlag(RecordDC, "ddcspecb", 0x40);
    pub const specb_ddcfkyl2 = util.bitFlag(RecordDC, "ddcspecb", 0x20);
    pub const specb_ddcfkyc2 = util.bitFlag(RecordDC, "ddcspecb", 0x10);
    pub const specb_ddcfvsp = util.bitFlag(RecordDC, "ddcspecb", 0x08);
    pub const specb_ddcfsdb = util.bitFlag(RecordDC, "ddcspecb", 0x04);
    pub const specb_ddcfovrd = util.bitFlag(RecordDC, "ddcspecb", 0x02);
    pub const specb_ddcfcar = util.bitFlag(RecordDC, "ddcspecb", 0x01);

    pub const specc_ddcfattr = util.bitFlag(RecordDC, "ddcspecc", 0x80);
    pub const specc_ddcflogr = util.bitFlag(RecordDC, "ddcspecc", 0x40);
    pub const specc_ddcfrmod = util.bitFlag(RecordDC, "ddcspecc", 0x20);
    pub const specc_ddcgsrdu = util.bitFlag(RecordDC, "ddcspecc", 0x10);
    pub const specc_ddcfklbl = util.bitFlag(RecordDC, "ddcspecc", 0x08);

    pub const sflg_ddcovrd = util.bitFlag(RecordDC, "ddcsflg", 0x80);
    pub const sflg_ddcsdb = util.bitFlag(RecordDC, "ddcsflg", 0x40);

    pub const vbyt1_ddcreuse = util.bitFlag(RecordDC, "ddcvbyt1", 0x80);
    pub const vbyt1_ddcspeed = util.bitFlag(RecordDC, "ddcvbyt1", 0x40);
    pub const vbyt1_ddcex255 = util.bitFlag(RecordDC, "ddcvbyt1", 0x20);
    pub const vbyt1_ddclogrp = util.bitFlag(RecordDC, "ddcvbyt1", 0x10);

    pub const rbyte_ddca2gb = util.bitFlag(RecordDC, "ddcrbyte", 0x80);
    pub const rbyte_ddcreclm = util.bitFlag(RecordDC, "ddcrbyte", 0x40);

    pub const vsp_ddcvspuk = util.bitFlag(RecordDC, "ddcvsp", 0x80);
    pub const vsp_ddcvspum = util.bitFlag(RecordDC, "ddcvsp", 0x40);

    pub inline fn bind(self: *RecordDC, db: *Database, stmt: common.Stmt) !void {
        util.bcd2asc(self.ddcname[0..self.ddcnmlen]);
        try db.bindText(stmt, 1, self.ddcname[0..self.ddcnmlen]);
        util.bcd2asc(&self.ddcuser);
        try db.bindText(stmt, 2, &self.ddcuser);
        util.bcd2asc(&self.ddcdate);
        try db.bindText(stmt, 3, &self.ddcdate);
        util.bcd2asc(&self.ddctime);
        try db.bindText(stmt, 4, &self.ddctime);
        util.bcd2asc(&self.ddcdesc);
        try db.bindText(stmt, 5, &self.ddcdesc);
        try db.bindBool(stmt, 6, self.spec1_ddcfrorg());
        try db.bindBool(stmt, 7, self.spec1_ddcflrec());
        try db.bindBool(stmt, 8, self.spec1_ddcfrfm());
        try db.bindBool(stmt, 9, self.spec1_ddcfklen());
        try db.bindBool(stmt, 10, self.spec1_ddcfkoff());
        try db.bindBool(stmt, 11, self.spec1_ddcfexp());
        try db.bindBool(stmt, 12, self.spec1_ddcfret());
        try db.bindBool(stmt, 13, self.spec1_ddcfpsp());
        try db.bindBool(stmt, 14, self.spec2_ddcfssp());
        try db.bindBool(stmt, 15, self.spec2_ddcfdir());
        try db.bindBool(stmt, 16, self.spec2_ddcfaun());
        try db.bindBool(stmt, 17, self.spec2_ddcfavr());
        try db.bindBool(stmt, 18, self.spec2_ddcfvol());
        try db.bindBool(stmt, 19, self.spec2_ddcfcis());
        try db.bindBool(stmt, 20, self.spec2_ddcfcif());
        try db.bindBool(stmt, 21, self.spec2_ddcfcaf());
        try db.bindBool(stmt, 22, self.spec3_ddcfxreg());
        try db.bindBool(stmt, 23, self.spec3_ddcfxsys());
        try db.bindBool(stmt, 24, self.spec3_ddcfimbd());
        try db.bindBool(stmt, 25, self.spec3_ddcfrplc());
        try db.bindBool(stmt, 26, self.spec3_ddcfcomp());
        try db.bindBool(stmt, 27, self.spec3_ddcfmedi());
        try db.bindBool(stmt, 28, self.spec3_ddcfrect());
        try db.bindBool(stmt, 29, self.spec3_ddcfvea());
        try db.bindBool(stmt, 30, self.spec4_ddcsprlf());
        try db.bindBool(stmt, 31, self.spec4_ddcredus());
        try db.bindBool(stmt, 32, self.spec4_ddcrabs());
        try db.bindBool(stmt, 33, self.spec4_ddcfct());
        try db.bindBool(stmt, 34, self.spec4_ddcblmt());
        try db.bindBool(stmt, 35, self.spec4_ddccfs());
        try db.bindBool(stmt, 36, self.spec4_ddcdvcs());
        try db.bindBool(stmt, 37, self.spec4_ddcfscal());
        try db.bindInt(stmt, 38, self.ddcrcorg);
        try db.bindInt(stmt, 39, self.ddcrecfm);
        try db.bindBool(stmt, 40, self.dsflg_ddcblk());
        try db.bindBool(stmt, 41, self.dsflg_ddcstsp());
        try db.bindInt(stmt, 42, self.ddccntl);
        try db.bindInt(stmt, 43, self.ddcexpyr);
        try db.bindInt(stmt, 44, self.ddcexpdy);
        try db.bindInt(stmt, 45, self.ddcvolct);
        try db.bindInt(stmt, 46, self.ddcdsnty);
        try db.bindInt(stmt, 47, self.ddcsppri);
        try db.bindInt(stmt, 48, self.ddcspsec);
        try db.bindInt(stmt, 49, self.ddcdiblk);
        try db.bindInt(stmt, 50, self.ddcavrec);
        try db.bindInt(stmt, 51, self.ddcreduc);
        try db.bindInt(stmt, 52, self.ddcrbias);
        try db.bindInt(stmt, 53, self.ddcdvc);
        try db.bindInt(stmt, 54, self.ddcaunit);
        try db.bindInt(stmt, 55, self.ddclrecl);
        try db.bindInt(stmt, 56, self.ddccisz);
        try db.bindInt(stmt, 57, self.ddccipct);
        try db.bindInt(stmt, 58, self.ddccapct);
        try db.bindInt(stmt, 59, self.ddcxreg);
        try db.bindInt(stmt, 60, self.ddcxsys);
        try db.bindBool(stmt, 61, self.vindx_ddcimbed());
        try db.bindBool(stmt, 62, self.vindx_ddcreplc());
        try db.bindInt(stmt, 63, self.ddcklen);
        try db.bindInt(stmt, 64, self.ddckoff);
        try db.bindInt(stmt, 65, self.ddccamt);
        try db.bindInt(stmt, 66, self.ddccomp);
        try db.bindInt(stmt, 67, self.ddcmedia);
        try db.bindInt(stmt, 68, self.ddcrecte);
        try db.bindInt(stmt, 69, self.ddcbwotp);
        try db.bindInt(stmt, 70, self.ddclogrc);
        try db.bindInt(stmt, 71, self.ddcspand);
        try db.bindInt(stmt, 72, self.ddcfrlog);
        util.bcd2asc(self.ddclogid[0..self.ddclogln]);
        try db.bindText(stmt, 73, self.ddclogid[0..self.ddclogln]);
        try db.bindBool(stmt, 74, self.speca_ddcbwos());
        try db.bindBool(stmt, 75, self.speca_ddclogrs());
        try db.bindBool(stmt, 76, self.speca_ddcspans());
        try db.bindBool(stmt, 77, self.speca_ddclsids());
        try db.bindBool(stmt, 78, self.speca_ddcfrlgs());
        try db.bindBool(stmt, 79, self.speca_ddcfextc());
        try db.bindBool(stmt, 80, self.speca_ddcfa2gb());
        try db.bindBool(stmt, 81, self.speca_ddcfpseg());
        try db.bindBool(stmt, 82, self.specb_ddcfkyl1());
        try db.bindBool(stmt, 83, self.specb_ddcfkyc1());
        try db.bindBool(stmt, 84, self.specb_ddcfkyl2());
        try db.bindBool(stmt, 85, self.specb_ddcfkyc2());
        try db.bindBool(stmt, 86, self.specb_ddcfvsp());
        try db.bindBool(stmt, 87, self.specb_ddcfsdb());
        try db.bindBool(stmt, 88, self.specb_ddcfovrd());
        try db.bindBool(stmt, 89, self.specb_ddcfcar());
        try db.bindBool(stmt, 90, self.specc_ddcfattr());
        try db.bindBool(stmt, 91, self.specc_ddcflogr());
        try db.bindBool(stmt, 92, self.specc_ddcfrmod());
        try db.bindBool(stmt, 93, self.specc_ddcgsrdu());
        try db.bindBool(stmt, 94, self.specc_ddcfklbl());
        try db.bindBool(stmt, 95, self.sflg_ddcovrd());
        try db.bindBool(stmt, 96, self.sflg_ddcsdb());
        try db.bindBool(stmt, 97, self.vbyt1_ddcreuse());
        try db.bindBool(stmt, 98, self.vbyt1_ddcspeed());
        try db.bindBool(stmt, 99, self.vbyt1_ddcex255());
        try db.bindBool(stmt, 100, self.vbyt1_ddclogrp());
        try db.bindInt(stmt, 101, self.ddceattr);
        try db.bindInt(stmt, 102, self.ddcct);
        try db.bindInt(stmt, 103, self.ddcdscf);
        try db.bindBool(stmt, 104, self.rbyte_ddca2gb());
        try db.bindBool(stmt, 105, self.rbyte_ddcreclm());
        try db.bindInt64(stmt, 106, self.ddcbszlm);
        try db.bindInt(stmt, 107, self.ddcpsca);
        try db.bindInt(stmt, 108, self.ddcpseg);
        try db.bindBool(stmt, 109, self.vsp_ddcvspuk());
        try db.bindBool(stmt, 110, self.vsp_ddcvspum());
        try db.bindInt64(stmt, 111, util.b3toInt(self.ddcvspv));
        util.bcd2asc(&self.ddcklbn1);
        try db.bindText(stmt, 112, &self.ddcklbn1);
        try db.bindInt(stmt, 113, self.ddckycd1);
        util.bcd2asc(&self.ddcklbn2);
        try db.bindText(stmt, 114, &self.ddcklbn2);
        try db.bindInt(stmt, 115, self.ddckycd2);
        try db.bindInt(stmt, 116, self.ddcrmode);
        util.bcd2asc(&self.ddcdklbn);
        try db.bindText(stmt, 117, &self.ddcdklbn);
    }
};

pub const Record = RecordDC;
pub const record_key = "DC";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordDC size: {d}\n", .{@sizeOf(RecordDC)});
    try std.testing.expect(@sizeOf(RecordDC) == 564);
}
