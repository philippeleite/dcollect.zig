const std = @import("std");
const c = @import("sqlite");
const util = @import("util.zig");
const records = @import("records.zig");
const RecordD = records.RecordD;
const RecordA = records.RecordA;
const RecordV = records.RecordV;

const tab_record_d =
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

const sqlD =
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

const tab_record_a =
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

const sqlA =
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

const tab_record_v =
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

const sqlV =
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

pub const Database = struct {
    db: *c.sqlite3 = undefined,
    stmtD: *c.sqlite3_stmt = undefined,
    stmtA: *c.sqlite3_stmt = undefined,
    stmtV: *c.sqlite3_stmt = undefined,

    pub fn init(allocator: std.mem.Allocator, db_path: []const u8) !Database {
        const null_db = try allocator.dupeZ(u8, db_path);
        defer allocator.free(null_db);

        const flags =
            c.SQLITE_OPEN_READWRITE |
            c.SQLITE_OPEN_CREATE |
            c.SQLITE_OPEN_URI;

        var db: ?*c.sqlite3 = undefined;
        if (c.SQLITE_OK != c.sqlite3_open_v2(null_db, &db, flags, null)) {
            std.log.err("Can't open database: {s}\n", .{c.sqlite3_errmsg(db.?)});
            return error.CantOpenDatabase;
        }

        var database = Database{ .db = db.? };

        _ = &database.execute(tab_record_d);
        _ = &database.execute(tab_record_a);
        _ = &database.execute(tab_record_v);

        const stmtD = blk: {
            var stmt: ?*c.sqlite3_stmt = undefined;
            if (c.SQLITE_OK != c.sqlite3_prepare_v2(db.?, sqlD, sqlD.len + 1, &stmt, null)) {
                std.log.err("Can't create prepare statement: {s}\n", .{c.sqlite3_errmsg(db.?)});
                return error.prepareStmt;
            }
            break :blk stmt.?;
        };

        const stmtA = blk: {
            var stmt: ?*c.sqlite3_stmt = undefined;
            if (c.SQLITE_OK != c.sqlite3_prepare_v2(db.?, sqlA, sqlA.len + 1, &stmt, null)) {
                std.log.err("Can't create prepare statement: {s}\n", .{c.sqlite3_errmsg(db.?)});
                return error.prepareStmt;
            }
            break :blk stmt.?;
        };

        const stmtV = blk: {
            var stmt: ?*c.sqlite3_stmt = undefined;
            if (c.SQLITE_OK != c.sqlite3_prepare_v2(db.?, sqlV, sqlV.len + 1, &stmt, null)) {
                std.log.err("Can't create prepare statement: {s}\n", .{c.sqlite3_errmsg(db.?)});
                return error.prepareStmt;
            }
            break :blk stmt.?;
        };

        database.stmtD = stmtD;
        database.stmtA = stmtA;
        database.stmtV = stmtV;

        return database;
    }

    pub fn deinit(self: *Database) void {
        _ = c.sqlite3_finalize(self.stmtD);
        _ = c.sqlite3_finalize(self.stmtA);
        _ = c.sqlite3_finalize(self.stmtV);
        _ = c.sqlite3_close(self.db);
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

    pub fn processRecordD(self: *Database, record: *RecordD) !void {
        try self.bindRecordD(record);
        if (c.SQLITE_DONE != c.sqlite3_step(self.stmtD)) {
            std.log.err("Can't step cat stmt: {s}\n", .{c.sqlite3_errmsg(self.db)});
            return error.Step;
        }
        _ = c.sqlite3_reset(self.stmtD);
    }

    pub fn processRecordA(self: *Database, record: *RecordA) !void {
        try self.bindRecordA(record);
        if (c.SQLITE_DONE != c.sqlite3_step(self.stmtA)) {
            std.log.err("Can't step cat stmt: {s}\n", .{c.sqlite3_errmsg(self.db)});
            return error.Step;
        }
        _ = c.sqlite3_reset(self.stmtA);
    }

    pub fn processRecordV(self: *Database, record: *RecordV) !void {
        try self.bindRecordV(record);
        if (c.SQLITE_DONE != c.sqlite3_step(self.stmtV)) {
            std.log.err("Can't step cat stmt: {s}\n", .{c.sqlite3_errmsg(self.db)});
            return error.Step;
        }
        _ = c.sqlite3_reset(self.stmtV);
    }

    inline fn bindRecordD(self: *Database, record: *RecordD) !void {
        util.bcd2asc(&record.dcddsnam);
        try self.bindText(self.stmtD, 1, &record.dcddsnam);

        try self.bindBool(self.stmtD, 2, record.error_dcdemngd());
        try self.bindBool(self.stmtD, 3, record.error_dcdedvvr());
        try self.bindBool(self.stmtD, 4, record.error_dcdnospc());
        try self.bindBool(self.stmtD, 5, record.error_dcdvsami());
        try self.bindBool(self.stmtD, 6, record.error_dcdnofm1());
        try self.bindBool(self.stmtD, 7, record.flag1_dcdracfd());
        try self.bindBool(self.stmtD, 8, record.flag1_dcdsmsm());
        try self.bindBool(self.stmtD, 9, record.flag1_dcdtemp());
        try self.bindBool(self.stmtD, 10, record.flag1_dcdpdse());
        try self.bindBool(self.stmtD, 11, record.flag1_dcdgds());
        try self.bindBool(self.stmtD, 12, record.flag1_dcdreblk());
        try self.bindBool(self.stmtD, 13, record.flag1_dcdchind());
        try self.bindBool(self.stmtD, 14, record.flag1_dcdckdsi());
        try self.bindBool(self.stmtD, 15, record.flag2_dcdnovvr());
        try self.bindBool(self.stmtD, 16, record.flag2_dcdintcg());
        try self.bindBool(self.stmtD, 17, record.flag2_dcdinicf());
        try self.bindBool(self.stmtD, 18, record.flag2_dcdallfg());
        try self.bindBool(self.stmtD, 19, record.flag2_dcdusefg());
        try self.bindBool(self.stmtD, 20, record.flag2_dcdsecfg());
        try self.bindBool(self.stmtD, 21, record.flag2_dcdnmbfg());
        try self.bindBool(self.stmtD, 22, record.flag3_dcdpdsex());
        try self.bindBool(self.stmtD, 23, record.flag3_dcdstrp());
        try self.bindBool(self.stmtD, 24, record.flag3_dcdddmex());
        try self.bindBool(self.stmtD, 25, record.flag3_dcdcpoit());
        try self.bindBool(self.stmtD, 26, record.flag3_dcdgt64k());
        try self.bindBool(self.stmtD, 27, record.flag3_dcdcmptv());
        try self.bindBool(self.stmtD, 28, record.dsorg_dcddsgis());
        try self.bindBool(self.stmtD, 29, record.dsorg_dcddsgps());
        try self.bindBool(self.stmtD, 30, record.dsorg_dcddsgda());
        try self.bindBool(self.stmtD, 31, record.dsorg_dcddsgpo());
        try self.bindBool(self.stmtD, 32, record.dsorg_dcddsgu());
        try self.bindBool(self.stmtD, 33, record.dsorg_dcddsggs());
        try self.bindBool(self.stmtD, 34, record.dsorg_dcddsgvs());

        const dcdrecfm = blk: {
            if (record.recrd_dcdrecff() and record.recrd_dcdrecfv()) {
                break :blk "U";
            } else if (record.recrd_dcdrecff()) {
                break :blk "F";
            } else if (record.recrd_dcdrecfv()) {
                break :blk "V";
            } else {
                break :blk "";
            }
        };
        try self.bindText(self.stmtD, 35, dcdrecfm);

        try self.bindBool(self.stmtD, 36, record.recrd_dcdrecft());
        try self.bindBool(self.stmtD, 37, record.recrd_dcdrecfb());
        try self.bindBool(self.stmtD, 38, record.recrd_dcdrecfs());
        try self.bindBool(self.stmtD, 39, record.recrd_dcdrecfa());
        try self.bindBool(self.stmtD, 40, record.recrd_dcdrecfc());
        try self.bindInt(self.stmtD, 41, record.dcdnmext);

        util.bcd2asc(&record.dcdvolsr);
        try self.bindText(self.stmtD, 42, &record.dcdvolsr);

        try self.bindInt(self.stmtD, 43, record.dcdbklng);
        try self.bindInt(self.stmtD, 44, record.dcdlrecl);
        try self.bindInt(self.stmtD, 45, record.dcdallsp);
        try self.bindInt(self.stmtD, 46, record.dcdusesp);
        try self.bindInt(self.stmtD, 47, record.dcdscall);
        try self.bindInt(self.stmtD, 48, record.dcdnmblk);

        var dcdcredt_str: [10]u8 = .{0} ** 10;
        try util.dcdate(&dcdcredt_str, record.dcdcredt[0..]);
        try self.bindText(self.stmtD, 49, &dcdcredt_str);

        var dcdexpdt_str: [10]u8 = .{0} ** 10;
        try util.dcdate(&dcdexpdt_str, record.dcdexpdt[0..]);
        try self.bindText(self.stmtD, 50, &dcdexpdt_str);

        var dcdlstrf_str: [10]u8 = .{0} ** 10;
        try util.dcdate(&dcdlstrf_str, record.dcdlstrf[0..]);
        try self.bindText(self.stmtD, 51, &dcdlstrf_str);

        util.bcd2asc(&record.dcddsser);
        try self.bindText(self.stmtD, 52, &record.dcddsser);
        try self.bindInt(self.stmtD, 53, record.dcdvolsq);

        var dcdlbkdt1: [10]u8 = .{0} ** 10;
        var dcdlbkdt2: [12]u8 = .{0} ** 12;
        try util.dcdate(&dcdlbkdt1, record.dcdlbkdt[0..4]);
        try util.smftime(&dcdlbkdt2, record.dcdlbkdt[4..8]);
        try self.bindText(self.stmtD, 54, &dcdlbkdt1 ++ " " ++ &dcdlbkdt2);

        util.bcd2asc(&record.dcdatcl);
        try self.bindText(self.stmtD, 55, &record.dcdatcl);
        util.bcd2asc(&record.dcdstgcl);
        try self.bindText(self.stmtD, 56, &record.dcdstgcl);
        util.bcd2asc(&record.dcdmgtcl);
        try self.bindText(self.stmtD, 57, &record.dcdmgtcl);
        util.bcd2asc(&record.dcdstgrp);
        try self.bindText(self.stmtD, 58, &record.dcdstgrp);

        try self.bindText(self.stmtD, 59, &std.fmt.bytesToHex(&record.dcdccsid, .upper));

        try self.bindInt64(self.stmtD, 60, record.dcdudsiz);
        try self.bindInt64(self.stmtD, 61, record.dcdcudsz);
        try self.bindInt(self.stmtD, 62, record.dcdscnt);
        try self.bindInt(self.stmtD, 63, record.dcdovera);

        util.bcd2asc(&record.dcdacct);
        try self.bindText(self.stmtD, 64, &record.dcdacct);

        try self.bindBool(self.stmtD, 65, record.flag5_dcdallfx());
        try self.bindBool(self.stmtD, 66, record.flag5_dcdusefx());
        try self.bindBool(self.stmtD, 67, record.flag5_dcdscafx());
        try self.bindBool(self.stmtD, 68, record.flag5_dcdnmbfx());

        util.bcd2asc(&record.dcdjbnmc);
        try self.bindText(self.stmtD, 69, &record.dcdjbnmc);
        util.bcd2asc(&record.dcdstnmc);
        try self.bindText(self.stmtD, 70, &record.dcdstnmc);

        try self.bindInt64(self.stmtD, 71, record.dcdallsx);
        try self.bindInt64(self.stmtD, 72, record.dcdusesx);
        try self.bindInt64(self.stmtD, 73, record.dcdscalx);
        try self.bindInt64(self.stmtD, 74, record.dcdnmblx);
        try self.bindInt(self.stmtD, 75, record.dcdxpsev);
        try self.bindInt(self.stmtD, 76, record.dcdctype);
        try self.bindInt(self.stmtD, 77, record.dcdtype);

        const dcdklbl = blk: {
            if (record.dcdtype == 0xFFFF) {
                break :blk " " ** 64;
            } else {
                util.bcd2asc(&record.dcdklbl);
                break :blk &record.dcdklbl;
            }
        };

        try self.bindText(self.stmtD, 78, dcdklbl);
    }

    inline fn bindRecordA(self: *Database, record: *RecordA) !void {
        util.bcd2asc(&record.dcadsnam);
        try self.bindText(self.stmtA, 1, &record.dcadsnam);

        util.bcd2asc(&record.dcaassoc);
        try self.bindText(self.stmtA, 2, &record.dcaassoc);

        try self.bindBool(self.stmtA, 3, record.flag1_dcaksds());
        try self.bindBool(self.stmtA, 4, record.flag1_dcaesds());
        try self.bindBool(self.stmtA, 5, record.flag1_dcarrds());
        try self.bindBool(self.stmtA, 6, record.flag1_dcalds());
        try self.bindBool(self.stmtA, 7, record.flag1_dcakrds());
        try self.bindBool(self.stmtA, 8, record.flag1_dcaaix());
        try self.bindBool(self.stmtA, 9, record.flag1_dcadata());
        try self.bindBool(self.stmtA, 10, record.flag1_dcaindex());
        try self.bindBool(self.stmtA, 11, record.flag2_dcakr1st());
        try self.bindBool(self.stmtA, 12, record.flag2_dcaixupg());
        try self.bindBool(self.stmtA, 13, record.flag2_dcavrrds());
        try self.bindBool(self.stmtA, 14, record.flag2_dcanstat());
        try self.bindBool(self.stmtA, 15, record.flag2_dcasrci());
        try self.bindBool(self.stmtA, 16, record.flag2_dcag4g());
        try self.bindBool(self.stmtA, 17, record.flag2_dcazfs());
        try self.bindInt64(self.stmtA, 18, record.dcahurba);
        try self.bindInt64(self.stmtA, 19, record.dcaharba);
        try self.bindInt(self.stmtA, 20, record.dcanlr);
        try self.bindInt(self.stmtA, 21, record.dcadlr);
        try self.bindInt(self.stmtA, 22, record.dcainr);
        try self.bindInt(self.stmtA, 23, record.dcaupr);
        try self.bindInt(self.stmtA, 24, record.dcartr);
        try self.bindInt(self.stmtA, 25, record.dcaasp);
        try self.bindInt(self.stmtA, 26, record.dcacis);
        try self.bindInt(self.stmtA, 27, record.dcacas);
        try self.bindInt(self.stmtA, 28, record.dcaexc);
        try self.bindInt(self.stmtA, 29, record.dcarkp);
        try self.bindInt(self.stmtA, 30, record.dcakln);
        try self.bindInt64(self.stmtA, 31, record.dcahurbc);
        try self.bindInt64(self.stmtA, 32, record.dcaharbc);
        try self.bindInt(self.stmtA, 33, record.dcacisz);
        try self.bindInt(self.stmtA, 34, record.dcacaci);
        var dcatrdt_str: [10]u8 = .{0} ** 10;
        try util.dcdate(&dcatrdt_str, &record.dcatrdt);
        try self.bindText(self.stmtA, 35, &dcatrdt_str);
    }

    inline fn bindRecordV(self: *Database, record: *RecordV) !void {
        util.bcd2asc(&record.dcvvolsr);
        try self.bindText(self.stmtV, 1, &record.dcvvolsr);
        try self.bindBool(self.stmtV, 2, record.flag1_dcvinxex());
        try self.bindBool(self.stmtV, 3, record.flag1_dcvinxen());
        try self.bindBool(self.stmtV, 4, record.flag1_dcvuspvt());
        try self.bindBool(self.stmtV, 5, record.flag1_dcvuspub());
        try self.bindBool(self.stmtV, 6, record.flag1_dcvussto());
        try self.bindBool(self.stmtV, 7, record.flag1_dcvshrds());
        try self.bindBool(self.stmtV, 8, record.flag1_dcvmangd());
        try self.bindBool(self.stmtV, 9, record.flag1_dcvinitl());
        try self.bindBool(self.stmtV, 10, record.error_dcvevlcp());
        try self.bindBool(self.stmtV, 11, record.error_dcvebytk());
        try self.bindBool(self.stmtV, 12, record.error_dcvelspc());
        try self.bindInt(self.stmtV, 13, record.dcvperct);
        try self.bindInt(self.stmtV, 14, record.dcvfresp);
        try self.bindInt(self.stmtV, 15, record.dcvalloc);
        try self.bindInt(self.stmtV, 16, record.dcvvlcap);
        try self.bindInt(self.stmtV, 17, record.dcvfragi);
        try self.bindInt(self.stmtV, 18, record.dcvlgext);
        try self.bindInt(self.stmtV, 19, record.dcvfrext);
        try self.bindInt(self.stmtV, 20, record.dcvfdscb);
        try self.bindInt(self.stmtV, 21, record.dcvfvirs);

        util.bcd2asc(&record.dcvdvtyp);
        try self.bindText(self.stmtV, 22, &record.dcvdvtyp);

        try self.bindText(self.stmtV, 23, &std.fmt.bytesToHex(record.dcvdvnum, .upper));

        util.bcd2asc(&record.dcvsgtcl);
        try self.bindText(self.stmtV, 24, &record.dcvsgtcl);

        util.bcd2asc(&record.dcvdptyp);
        try self.bindText(self.stmtV, 25, &record.dcvdptyp);

        try self.bindInt(self.stmtV, 26, record.dcvtrpct);
        try self.bindInt(self.stmtV, 27, record.dcveavol);
        try self.bindInt(self.stmtV, 28, record.dcvtrfsp);
        try self.bindInt(self.stmtV, 29, record.dcvtralc);
        try self.bindInt(self.stmtV, 30, record.dcvtrvlc);
        try self.bindInt(self.stmtV, 31, record.dcvtrfrg);
        try self.bindInt(self.stmtV, 32, record.dcvtrlge);
        try self.bindInt(self.stmtV, 33, record.dcvtrfrx);
        try self.bindInt(self.stmtV, 34, record.dcvfcyls);
        try self.bindInt(self.stmtV, 35, record.dcvftrks);
    }

    fn bindText(self: *Database, stmt: *c.sqlite3_stmt, index: c_int, text: []const u8) !void {
        if (c.SQLITE_OK != c.sqlite3_bind_text(stmt, index, text.ptr, @intCast(text.len), c.SQLITE_STATIC)) {
            std.log.err("Can't bind text at index {d}: {s}\n", .{ index, c.sqlite3_errmsg(self.db) });
            return error.bindText;
        }
    }

    fn bindBool(self: *Database, stmt: *c.sqlite3_stmt, index: c_int, value: bool) !void {
        if (c.SQLITE_OK != c.sqlite3_bind_int(stmt, index, if (value) 1 else 0)) {
            std.log.err("Can't bind bool at index {d}: {s}\n", .{ index, c.sqlite3_errmsg(self.db) });
            return error.bindBool;
        }
    }

    fn bindInt(self: *Database, stmt: *c.sqlite3_stmt, index: c_int, value: i32) !void {
        if (c.SQLITE_OK != c.sqlite3_bind_int(stmt, index, @as(c_int, value))) {
            std.log.err("Can't bind int at index {d}: {s}\n", .{ index, c.sqlite3_errmsg(self.db) });
            return error.bindInt;
        }
    }

    fn bindInt64(self: *Database, stmt: *c.sqlite3_stmt, index: c_int, value: i64) !void {
        if (c.SQLITE_OK != c.sqlite3_bind_int64(stmt, index, @intCast(value))) {
            std.log.err("Can't bind int64 at index {d}: {s}\n", .{ index, c.sqlite3_errmsg(self.db) });
            return error.bindInt64;
        }
    }
};
