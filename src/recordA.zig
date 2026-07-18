const Header = @import("records.zig").Header;

pub const RecordA = extern struct {
    header: Header,
    dcadsnam: [44]u8,
    dcaassoc: [44]u8,
    dcaflag1: [1]u8,
    dcaflag2: [1]u8,
    _res1: [2]u8,
    dcahurba: u32,
    dcaharba: u32,
    dcanlr: i32,
    dcadlr: i32,
    dcainr: i32,
    dcaupr: i32,
    dcartr: i32,
    dcaasp: i32,
    dcacis: i32,
    dcacas: i32,
    dcaexc: i32,
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

    pub fn flag1_dcaksds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x80 != 0;
    }

    pub fn flag1_dcaesds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x40 != 0;
    }

    pub fn flag1_dcarrds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x20 != 0;
    }

    pub fn flag1_dcalds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x10 != 0;
    }

    pub fn flag1_dcakrds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x08 != 0;
    }

    pub fn flag1_dcaaix(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x04 != 0;
    }

    pub fn flag1_dcadata(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x02 != 0;
    }

    pub fn flag1_dcaindex(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x01 != 0;
    }

    pub fn flag2_dcakr1st(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x80 != 0;
    }

    pub fn flag2_dcaixupg(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x40 != 0;
    }

    pub fn flag2_dcavrrds(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x20 != 0;
    }

    pub fn flag2_dcanstat(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x10 != 0;
    }

    pub fn flag2_dcasrci(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x08 != 0;
    }

    pub fn flag2_dcag4g(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x04 != 0;
    }

    pub fn flag2_dcazfs(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x02 != 0;
    }
};
