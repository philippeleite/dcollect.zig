const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Legacy per-system OAM status entry (DLBNSTAT), 4 bytes.
pub const NStat = extern struct {
    dlbsout: u8,
    dlbcfcs: u8,
    _res: [2]u8,
};

/// Per-system status entry (DLBSTAT), 8 bytes.
pub const SysStat = extern struct {
    dlbreqst: u8,
    dlbcurst: u8,
    _res: [6]u8,
};

/// SMS Optical Library Definition (record type 'LB'); also describes tape libraries.
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 24.
/// Not validated against real data: the sample file has no LB records.
/// Status arrays are positional JSON: index N is the system in BC's dbcfsysn (8) / dbcsysnm (32).
pub const RecordLB = extern struct {
    header: Header,
    dlbnmlen: u16,
    dlblname: [30]u8, // DLBNAME (8) + reserved
    dlbduser: [8]u8,
    dlbddate: [10]u8,
    dlbflags: [1]u8,
    _res1: [5]u8,
    dlbdtime: [8]u8,
    dlbnstat: [8]NStat,
    dlbtype: u8,
    _res2: [2]u8,
    dlbdtype: u8,
    dlbdcons: u32,
    dlbedvt: u8,
    dlbejd: u8,
    dlblcbid: [5]u8,
    _res3: [1]u8,
    dlbedunm: [8]u8,
    dlbdclen: u16,
    dlbdclnm: [30]u8, // DLBDCNAM (8) + reserved
    dlbstat: [32]SysStat,
    _res4: [16]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_lb;
        \\ CREATE TABLE record_lb (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dlbname TEXT NOT NULL DEFAULT '',
        \\     dlbduser TEXT NOT NULL DEFAULT '',
        \\     dlbddate TEXT NOT NULL DEFAULT '',
        \\     dlbdtime TEXT NOT NULL DEFAULT '',
        \\     dlb32nam BOOLEAN NOT NULL DEFAULT 0,
        \\     dlbsout TEXT NOT NULL DEFAULT '[]',
        \\     dlbcfcs TEXT NOT NULL DEFAULT '[]',
        \\     dlbtype SMALLINT NOT NULL DEFAULT 0,
        \\     dlbdtype SMALLINT NOT NULL DEFAULT 0,
        \\     dlbdcons BIGINT NOT NULL DEFAULT 0,
        \\     dlbedvt SMALLINT NOT NULL DEFAULT 0,
        \\     dlbejd SMALLINT NOT NULL DEFAULT 0,
        \\     dlblcbid TEXT NOT NULL DEFAULT '',
        \\     dlbedunm TEXT NOT NULL DEFAULT '',
        \\     dlbdcnam TEXT NOT NULL DEFAULT '',
        \\     dlbreqst TEXT NOT NULL DEFAULT '[]',
        \\     dlbcurst TEXT NOT NULL DEFAULT '[]'
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_lb (
        \\     dlbname, dlbduser, dlbddate, dlbdtime, dlb32nam, dlbsout, dlbcfcs,
        \\     dlbtype, dlbdtype, dlbdcons, dlbedvt, dlbejd, dlblcbid, dlbedunm, dlbdcnam,
        \\     dlbreqst, dlbcurst
        \\ ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flags_dlb32nam = util.bitFlag(RecordLB, "dlbflags", 0x80);

    pub inline fn bind(self: *RecordLB, b: *common.Binder) !void {
        var json_buf: [256]u8 = undefined;

        // Lengths come from the input file; clamp so a corrupt record can't slice out of bounds.
        try b.text(util.ascii(self.dlblname[0..@min(self.dlbnmlen, self.dlblname.len)]));
        util.bcd2asc(&self.dlbduser);
        try b.text(&self.dlbduser);
        util.bcd2asc(&self.dlbddate);
        try b.text(&self.dlbddate);
        util.bcd2asc(&self.dlbdtime);
        try b.text(&self.dlbdtime);
        try b.boolean(self.flags_dlb32nam());

        var nums8: [8]u16 = undefined;
        for (&nums8, self.dlbnstat) |*out, s| out.* = s.dlbsout;
        try b.text(try util.jsonArray(&json_buf, nums8));
        for (&nums8, self.dlbnstat) |*out, s| out.* = s.dlbcfcs;
        try b.text(try util.jsonArray(&json_buf, nums8));

        try b.int(self.dlbtype); // 0 = not optical, 1 = real, 2 = pseudo
        try b.int(self.dlbdtype); // 0 = IBM 9246, 1 = IBM 3995, 2 = tape library
        try b.int64(self.dlbdcons);
        try b.int(self.dlbedvt); // tape only: 1 = private, 2 = scratch
        try b.int(self.dlbejd); // tape only: 1 = purge, 2 = keep TCDB volume record
        try b.text(util.ascii(&self.dlblcbid));
        try b.text(util.ascii(&self.dlbedunm));
        try b.text(util.ascii(self.dlbdclnm[0..@min(self.dlbdclen, self.dlbdclnm.len)]));

        var nums32: [32]u16 = undefined;
        for (&nums32, self.dlbstat) |*out, s| out.* = s.dlbreqst;
        try b.text(try util.jsonArray(&json_buf, nums32));
        for (&nums32, self.dlbstat) |*out, s| out.* = s.dlbcurst;
        try b.text(try util.jsonArray(&json_buf, nums32));
    }
};

pub const Record = RecordLB;
pub const record_key = "LB";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordLB size: {d}\n", .{@sizeOf(RecordLB)});
    try std.testing.expect(@sizeOf(RecordLB) == 448);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(4, @sizeOf(NStat));
    try std.testing.expectEqual(8, @sizeOf(SysStat));
    try std.testing.expectEqual(26, @offsetOf(RecordLB, "dlblname"));
    try std.testing.expectEqual(74, @offsetOf(RecordLB, "dlbflags"));
    try std.testing.expectEqual(80, @offsetOf(RecordLB, "dlbdtime"));
    try std.testing.expectEqual(88, @offsetOf(RecordLB, "dlbnstat"));
    try std.testing.expectEqual(120, @offsetOf(RecordLB, "dlbtype"));
    try std.testing.expectEqual(123, @offsetOf(RecordLB, "dlbdtype"));
    try std.testing.expectEqual(124, @offsetOf(RecordLB, "dlbdcons"));
    try std.testing.expectEqual(130, @offsetOf(RecordLB, "dlblcbid"));
    try std.testing.expectEqual(136, @offsetOf(RecordLB, "dlbedunm"));
    try std.testing.expectEqual(144, @offsetOf(RecordLB, "dlbdclen"));
    try std.testing.expectEqual(176, @offsetOf(RecordLB, "dlbstat"));
}

test "synthetic LB record (tape library) is decoded into record_lb" {
    const put = common.TestHarness.putEbcdic;
    var t: common.TestHarness = undefined;
    try t.init();
    defer t.deinit();

    var rec: [448]u8 = @splat(0);
    std.mem.writeInt(u16, rec[0..2], rec.len, .big);
    put(rec[4..6], "LB");
    std.mem.writeInt(u16, rec[24..26], 8, .big);
    put(rec[26..34], "ATLLIB01");
    put(rec[56..64], "IBMUSER ");
    put(rec[64..74], "2025/06/30");
    rec[74] = 0x80; // DLB32NAM
    put(rec[80..88], "17:45   ");
    rec[88] = 1; // legacy system 0: requested online
    rec[89] = 1; // ... currently online
    rec[120] = 1; // real library
    rec[123] = 2; // tape library
    std.mem.writeInt(u32, rec[124..128], 7, .big); // console id
    rec[128] = 2; // entry default: scratch
    rec[129] = 2; // eject default: keep
    put(rec[130..135], "1A2B3");
    put(rec[136..144], "3490    ");
    std.mem.writeInt(u16, rec[144..146], 6, .big);
    put(rec[146..152], "DCTAPE");
    rec[176] = 1; // system 0: requested online
    rec[177] = 1; // ... currently online
    rec[184] = 3; // system 1: no outstanding request
    rec[185] = 2; // ... currently offline

    try common.processRecord(&t.ctx, &rec);
    try std.testing.expectEqual(1, t.ctx.count.get("LB").?);

    const expect = struct {
        fn col(h: *common.TestHarness, comptime name: []const u8, want: []const u8) !void {
            try std.testing.expectEqualStrings(want, try h.queryText("SELECT " ++ name ++ " FROM record_lb"));
        }
    }.col;
    try expect(&t, "dlbname", "ATLLIB01");
    try expect(&t, "dlbddate", "2025/06/30");
    try expect(&t, "dlb32nam", "1");
    try expect(&t, "dlbsout", "[1,0,0,0,0,0,0,0]");
    try expect(&t, "dlbtype", "1");
    try expect(&t, "dlbdtype", "2");
    try expect(&t, "dlbdcons", "7");
    try expect(&t, "dlbedvt", "2");
    try expect(&t, "dlbejd", "2");
    try expect(&t, "dlblcbid", "1A2B3");
    try expect(&t, "dlbedunm", "3490");
    try expect(&t, "dlbdcnam", "DCTAPE");
    try expect(&t, "json_extract(dlbreqst, '$[1]')", "3");
    try expect(&t, "json_extract(dlbcurst, '$[1]')", "2");
}
