const Header = @import("records.zig").Header;

pub const RecordV = extern struct {
    header: Header,
    dcvvolsr: [6]u8,
    dcvflag1: [1]u8,
    dcverror: [1]u8,
    _res1: [3]u8,
    dcvperct: u8,
    dcvfresp: i32,
    dcvalloc: i32,
    dcvvlcap: i32,
    dcvfragi: i32,
    dcvlgext: i32,
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
    dcvtrfsp: i32,
    dcvtralc: i32,
    dcvtrvlc: i32,
    dcvtrfrg: i32,
    dcvtrlge: i32,
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

    pub fn flag1_dcvinxex(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x80 != 0;
    }

    pub fn flag1_dcvinxen(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x40 != 0;
    }

    pub fn flag1_dcvuspvt(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x20 != 0;
    }

    pub fn flag1_dcvuspub(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x10 != 0;
    }

    pub fn flag1_dcvussto(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x08 != 0;
    }

    pub fn flag1_dcvshrds(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x04 != 0;
    }

    pub fn flag1_dcvmangd(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x02 != 0;
    }

    pub fn flag1_dcvinitl(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x01 != 0;
    }

    pub fn error_dcvevlcp(self: *RecordV) bool {
        return self.dcverror[0] & 0x80 != 0;
    }

    pub fn error_dcvebytk(self: *RecordV) bool {
        return self.dcverror[0] & 0x40 != 0;
    }

    pub fn error_dcvelspc(self: *RecordV) bool {
        return self.dcverror[0] & 0x20 != 0;
    }
};
