const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Optical library entry (DSGOLIBS), 32 bytes.
pub const OptLib = extern struct {
    dsgolbnl: u16,
    dsgolbnm: [8]u8,
    _res: [22]u8,
};

/// Per-system status entry (DSGSSTAT), 8 bytes.
pub const SysStat = extern struct {
    dsgsysst: u8,
    dsgcnsms: u8,
    _res: [6]u8,
};

/// Storage Group Construct Information (record type 'SG').
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 19.
/// Repeating groups are stored as JSON arrays (query them with json_each()).
pub const RecordSG = extern struct {
    header: Header,
    dsgnmlen: u16,
    dsgname: [30]u8,
    dsguser: [8]u8,
    dsgdate: [10]u8,
    _res1: [2]u8,
    dsgtime: [8]u8,
    dsgdesc: [120]u8,
    _res2: [4]u8,
    dsgftype: u8,
    dsgfhthr: u8,
    dsgflthr: u8,
    _res3: [1]u8,
    // align(1) on 4-byte fields keeps the struct at 922 bytes instead of padding to 924.
    dsgfvmax: i32 align(1),
    dsgfvunt: [4]u8,
    dsgdmpcl: [5][8]u8,
    dsgfprst: [8]u8, // DSGSTAT for up to 8 systems (legacy)
    dsgabsys: [8]u8,
    dsgadsys: [8]u8,
    dsgamsys: [8]u8,
    dsgcnfrm: [8]u8, // DSGCSMSS for up to 8 systems (legacy)
    dsggbkuf: i32 align(1),
    dsgtblgr: [8]u8,
    dsgoamfl: [1]u8,
    _res4: [1]u8,
    dsgcylst: u8,
    dsgcyled: u8,
    dsgvolft: i16,
    dsgdrvst: i16,
    dsgolibs: [8]OptLib,
    dsgsstat: [32]SysStat,
    _res5: [16]u8,
    dsgoflow: u8,
    dsgexnln: u16 align(1),
    dsgexnm: [30]u8,
    _res6: [2]u8,
    dsgdflag2: [1]u8,
    dsgsbkpt: u32 align(1),
    dsgshthr: u16,
    dsgslthr: u16,
    _res7: [24]u8,
    dsgtotap: u8,
    dsgtmsap: u8,
    dsgoamid: [4]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_sg;
        \\ CREATE TABLE record_sg (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dsgname TEXT NOT NULL DEFAULT '',
        \\     dsguser TEXT NOT NULL DEFAULT '',
        \\     dsgdate TEXT NOT NULL DEFAULT '',
        \\     dsgtime TEXT NOT NULL DEFAULT '',
        \\     dsgdesc TEXT NOT NULL DEFAULT '',
        \\     dsgftype SMALLINT NOT NULL DEFAULT 0,
        \\     dsgfhthr SMALLINT NOT NULL DEFAULT 0,
        \\     dsgflthr SMALLINT NOT NULL DEFAULT 0,
        \\     dsgfvmax INTEGER NOT NULL DEFAULT 0,
        \\     dsgfvunt TEXT NOT NULL DEFAULT '',
        \\     dsgdmpcl TEXT NOT NULL DEFAULT '[]',
        \\     dsgstat TEXT NOT NULL DEFAULT '[]',
        \\     dsgabsys TEXT NOT NULL DEFAULT '',
        \\     dsgadsys TEXT NOT NULL DEFAULT '',
        \\     dsgamsys TEXT NOT NULL DEFAULT '',
        \\     dsgcsmss TEXT NOT NULL DEFAULT '[]',
        \\     dsggbkuf INTEGER NOT NULL DEFAULT 0,
        \\     dsgtblgr TEXT NOT NULL DEFAULT '',
        \\     dsgfcys BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgfvlft BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgfdrst BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgvffer BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgvferr BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgfretp BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgfdelp BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgcylst SMALLINT NOT NULL DEFAULT 0,
        \\     dsgcyled SMALLINT NOT NULL DEFAULT 0,
        \\     dsgvolft SMALLINT NOT NULL DEFAULT 0,
        \\     dsgdrvst SMALLINT NOT NULL DEFAULT 0,
        \\     dsgolbnm TEXT NOT NULL DEFAULT '[]',
        \\     dsgsysst TEXT NOT NULL DEFAULT '[]',
        \\     dsgcnsms TEXT NOT NULL DEFAULT '[]',
        \\     dsgoflow SMALLINT NOT NULL DEFAULT 0,
        \\     dsgexnm TEXT NOT NULL DEFAULT '',
        \\     dsgflowf BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgexnmf BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgeavbp BOOLEAN NOT NULL DEFAULT 0,
        \\     dsgsbkpt BIGINT NOT NULL DEFAULT 0,
        \\     dsgshthr SMALLINT NOT NULL DEFAULT 0,
        \\     dsgslthr SMALLINT NOT NULL DEFAULT 0,
        \\     dsgtotap SMALLINT NOT NULL DEFAULT 0,
        \\     dsgtmsap SMALLINT NOT NULL DEFAULT 0,
        \\     dsgoamid TEXT NOT NULL DEFAULT ''
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_sg (
        \\     dsgname,
        \\     dsguser,
        \\     dsgdate,
        \\     dsgtime,
        \\     dsgdesc,
        \\     dsgftype,
        \\     dsgfhthr,
        \\     dsgflthr,
        \\     dsgfvmax,
        \\     dsgfvunt,
        \\     dsgdmpcl,
        \\     dsgstat,
        \\     dsgabsys,
        \\     dsgadsys,
        \\     dsgamsys,
        \\     dsgcsmss,
        \\     dsggbkuf,
        \\     dsgtblgr,
        \\     dsgfcys,
        \\     dsgfvlft,
        \\     dsgfdrst,
        \\     dsgvffer,
        \\     dsgvferr,
        \\     dsgfretp,
        \\     dsgfdelp,
        \\     dsgcylst,
        \\     dsgcyled,
        \\     dsgvolft,
        \\     dsgdrvst,
        \\     dsgolbnm,
        \\     dsgsysst,
        \\     dsgcnsms,
        \\     dsgoflow,
        \\     dsgexnm,
        \\     dsgflowf,
        \\     dsgexnmf,
        \\     dsgeavbp,
        \\     dsgsbkpt,
        \\     dsgshthr,
        \\     dsgslthr,
        \\     dsgtotap,
        \\     dsgtmsap,
        \\     dsgoamid) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const oamfl_dsgfcys = util.bitFlag(RecordSG, "dsgoamfl", 0x80);
    pub const oamfl_dsgfvlft = util.bitFlag(RecordSG, "dsgoamfl", 0x40);
    pub const oamfl_dsgfdrst = util.bitFlag(RecordSG, "dsgoamfl", 0x20);
    pub const oamfl_dsgvffer = util.bitFlag(RecordSG, "dsgoamfl", 0x10);
    pub const oamfl_dsgvferr = util.bitFlag(RecordSG, "dsgoamfl", 0x08);
    pub const oamfl_dsgfretp = util.bitFlag(RecordSG, "dsgoamfl", 0x04);
    pub const oamfl_dsgfdelp = util.bitFlag(RecordSG, "dsgoamfl", 0x02);

    pub const dflag2_dsgflowf = util.bitFlag(RecordSG, "dsgdflag2", 0x80);
    pub const dflag2_dsgexnmf = util.bitFlag(RecordSG, "dsgdflag2", 0x40);
    pub const dflag2_dsgeavbp = util.bitFlag(RecordSG, "dsgdflag2", 0x10);

    pub inline fn bind(self: *RecordSG, b: *common.Binder) !void {
        var json_buf: [512]u8 = undefined;

        // Lengths come from the input file; clamp so a corrupt record can't slice out of bounds.
        const name = self.dsgname[0..@min(self.dsgnmlen, self.dsgname.len)];
        util.bcd2asc(name);
        try b.text(name);
        util.bcd2asc(&self.dsguser);
        try b.text(&self.dsguser);
        util.bcd2asc(&self.dsgdate);
        try b.text(&self.dsgdate);
        util.bcd2asc(&self.dsgtime);
        try b.text(&self.dsgtime);
        util.bcd2asc(&self.dsgdesc);
        try b.text(&self.dsgdesc);
        try b.int(self.dsgftype);
        try b.int(self.dsgfhthr);
        try b.int(self.dsgflthr);
        try b.int(self.dsgfvmax);
        try b.text(util.ascii(&self.dsgfvunt));

        var dmpcl: [5][]const u8 = undefined;
        for (&dmpcl, &self.dsgdmpcl) |*out, *cls| out.* = util.ascii(cls);
        try b.text(try util.jsonArray(&json_buf, dmpcl));

        var stat: [8]u16 = undefined;
        for (&stat, self.dsgfprst) |*out, v| out.* = v;
        try b.text(try util.jsonArray(&json_buf, stat));

        try b.text(util.ascii(&self.dsgabsys));
        try b.text(util.ascii(&self.dsgadsys));
        try b.text(util.ascii(&self.dsgamsys));

        for (&stat, self.dsgcnfrm) |*out, v| out.* = v;
        try b.text(try util.jsonArray(&json_buf, stat));

        try b.int(self.dsggbkuf);
        try b.text(util.ascii(&self.dsgtblgr));
        try b.boolean(self.oamfl_dsgfcys());
        try b.boolean(self.oamfl_dsgfvlft());
        try b.boolean(self.oamfl_dsgfdrst());
        try b.boolean(self.oamfl_dsgvffer());
        try b.boolean(self.oamfl_dsgvferr());
        try b.boolean(self.oamfl_dsgfretp());
        try b.boolean(self.oamfl_dsgfdelp());
        try b.int(self.dsgcylst);
        try b.int(self.dsgcyled);
        try b.int(self.dsgvolft);
        try b.int(self.dsgdrvst);

        // Only defined optical libraries (non-zero name length).
        var libs: [8][]const u8 = undefined;
        var nlibs: usize = 0;
        for (&self.dsgolibs) |*lib| {
            const len = @min(lib.dsgolbnl, lib.dsgolbnm.len);
            if (len == 0) continue;
            libs[nlibs] = util.ascii(lib.dsgolbnm[0..len]);
            nlibs += 1;
        }
        try b.text(try util.jsonArray(&json_buf, libs[0..nlibs]));

        var sysst: [32]u16 = undefined;
        for (&sysst, self.dsgsstat) |*out, s| out.* = s.dsgsysst;
        try b.text(try util.jsonArray(&json_buf, sysst));
        for (&sysst, self.dsgsstat) |*out, s| out.* = s.dsgcnsms;
        try b.text(try util.jsonArray(&json_buf, sysst));

        try b.int(self.dsgoflow);
        try b.text(util.ascii(self.dsgexnm[0..@min(self.dsgexnln, self.dsgexnm.len)]));
        try b.boolean(self.dflag2_dsgflowf());
        try b.boolean(self.dflag2_dsgexnmf());
        try b.boolean(self.dflag2_dsgeavbp());
        try b.int64(self.dsgsbkpt);
        try b.int(self.dsgshthr);
        try b.int(self.dsgslthr);
        try b.int(self.dsgtotap);
        try b.int(self.dsgtmsap);
        try b.text(util.ascii(&self.dsgoamid));
    }
};

pub const Record = RecordSG;
pub const record_key = "SG";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordSG size: {d}\n", .{@sizeOf(RecordSG)});
    try std.testing.expect(@sizeOf(RecordSG) == 922);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(208, @offsetOf(RecordSG, "dsgftype"));
    try std.testing.expectEqual(212, @offsetOf(RecordSG, "dsgfvmax"));
    try std.testing.expectEqual(220, @offsetOf(RecordSG, "dsgdmpcl"));
    try std.testing.expectEqual(260, @offsetOf(RecordSG, "dsgfprst"));
    try std.testing.expectEqual(292, @offsetOf(RecordSG, "dsgcnfrm"));
    try std.testing.expectEqual(300, @offsetOf(RecordSG, "dsggbkuf"));
    try std.testing.expectEqual(312, @offsetOf(RecordSG, "dsgoamfl"));
    try std.testing.expectEqual(320, @offsetOf(RecordSG, "dsgolibs"));
    try std.testing.expectEqual(576, @offsetOf(RecordSG, "dsgsstat"));
    try std.testing.expectEqual(848, @offsetOf(RecordSG, "dsgoflow"));
    try std.testing.expectEqual(849, @offsetOf(RecordSG, "dsgexnln"));
    try std.testing.expectEqual(883, @offsetOf(RecordSG, "dsgdflag2"));
    try std.testing.expectEqual(884, @offsetOf(RecordSG, "dsgsbkpt"));
    try std.testing.expectEqual(916, @offsetOf(RecordSG, "dsgtotap"));
    try std.testing.expectEqual(918, @offsetOf(RecordSG, "dsgoamid"));
    try std.testing.expectEqual(32, @sizeOf(OptLib));
    try std.testing.expectEqual(8, @sizeOf(SysStat));
}
