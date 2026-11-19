const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// DASD Capacity Planning Information (record type 'C', written by DFSMShsm with CAPPLANDATA).
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 15.
/// Not validated against real data: the sample file has no C records.
/// The record is 47 bytes; @sizeOf is 48 because of the 4-byte UCTOTAL. genericProcess copies
/// min(record length, struct size) bytes, so the padding byte simply stays zero.
pub const RecordC = extern struct {
    header: Header,
    ucvolsr: [6]u8,
    uccoldt: [4]u8, // packed yyyydddF
    ucflag1: [1]u8,
    _res1: [1]u8,
    uctotal: i32,
    uctgocc: u8,
    uctrocc: u8,
    ucbfocc: u8,
    ucafocc: u8,
    ucnomig: u8,
    ucnintv: u8,
    ucintvm: u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_c;
        \\ CREATE TABLE record_c (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     ucvolsr TEXT NOT NULL DEFAULT '',
        \\     uccoldt DATE NOT NULL DEFAULT '0000-00-00',
        \\     uclevel SMALLINT NOT NULL DEFAULT 0,
        \\     uctotal BIGINT NOT NULL DEFAULT 0,
        \\     uctgocc SMALLINT NOT NULL DEFAULT 0,
        \\     uctrocc SMALLINT NOT NULL DEFAULT 0,
        \\     ucbfocc SMALLINT NOT NULL DEFAULT 0,
        \\     ucafocc SMALLINT NOT NULL DEFAULT 0,
        \\     ucnomig SMALLINT NOT NULL DEFAULT 0,
        \\     ucnintv SMALLINT NOT NULL DEFAULT 0,
        \\     ucintvm SMALLINT NOT NULL DEFAULT 0
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_c (
        \\     ucvolsr, uccoldt, uclevel, uctotal,
        \\     uctgocc, uctrocc, ucbfocc, ucafocc, ucnomig, ucnintv, ucintvm
        \\ ) VALUES (?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub inline fn bind(self: *RecordC, b: *common.Binder) !void {
        try b.text(util.ascii(&self.ucvolsr));
        var date_buf: [10]u8 = undefined;
        try util.dcdate(&date_buf, &self.uccoldt);
        try b.text(&date_buf);
        try b.int(self.ucflag1[0] >> 6); // UCLEVEL: 0 = L0, 1 = ML1
        try b.int64(self.uctotal); // KB
        try b.int(self.uctgocc);
        try b.int(self.uctrocc);
        try b.int(self.ucbfocc);
        try b.int(self.ucafocc);
        try b.int(self.ucnomig);
        try b.int(self.ucnintv);
        try b.int(self.ucintvm);
    }
};

pub const Record = RecordC;
pub const record_key = "C ";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordC size: {d}\n", .{@sizeOf(RecordC)});
    // Documented length is 47 (UCCAPDE); the struct pads to 48.
    try std.testing.expectEqual(47, @offsetOf(RecordC, "ucintvm") + 1);
    try std.testing.expectEqual(48, @sizeOf(RecordC));
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(24, @offsetOf(RecordC, "ucvolsr"));
    try std.testing.expectEqual(30, @offsetOf(RecordC, "uccoldt"));
    try std.testing.expectEqual(34, @offsetOf(RecordC, "ucflag1"));
    try std.testing.expectEqual(36, @offsetOf(RecordC, "uctotal"));
    try std.testing.expectEqual(40, @offsetOf(RecordC, "uctgocc"));
    try std.testing.expectEqual(44, @offsetOf(RecordC, "ucnomig"));
}

test "synthetic 47-byte C record at an odd address is decoded into record_c" {
    const put = common.TestHarness.putEbcdic;
    var t: common.TestHarness = undefined;
    try t.init();
    defer t.deinit();

    var storage: [48]u8 align(4) = @splat(0);
    const rec = storage[1..48]; // exactly 47 bytes, misaligned
    std.mem.writeInt(u16, rec[0..2], rec.len, .big);
    put(rec[4..6], "C ");
    put(rec[24..30], "MIG101");
    @memcpy(rec[30..34], &[_]u8{ 0x20, 0x24, 0x32, 0x1F }); // 2024 day 321 = 2024-11-16
    rec[34] = 0x40; // UCLEVEL = 1 (ML1)
    std.mem.writeInt(i32, rec[36..40], 2_811_556, .big); // UCTOTAL (KB)
    rec[40] = 80; // target occupancy
    rec[41] = 90; // trigger occupancy
    rec[42] = 93; // before processing
    rec[43] = 78; // after processing
    rec[44] = 5; // excess eligible
    rec[45] = 4; // interval migration runs
    rec[46] = 3; // target met

    try common.processRecord(&t.ctx, rec);
    try std.testing.expectEqual(1, t.ctx.count.get("C ").?);

    const expect = struct {
        fn col(h: *common.TestHarness, comptime name: []const u8, want: []const u8) !void {
            try std.testing.expectEqualStrings(want, try h.queryText("SELECT " ++ name ++ " FROM record_c"));
        }
    }.col;
    try expect(&t, "ucvolsr", "MIG101");
    try expect(&t, "uccoldt", "2024-11-16");
    try expect(&t, "uclevel", "1");
    try expect(&t, "uctotal", "2811556");
    try expect(&t, "uctgocc", "80");
    try expect(&t, "uctrocc", "90");
    try expect(&t, "ucbfocc", "93");
    try expect(&t, "ucafocc", "78");
    try expect(&t, "ucnomig", "5");
    try expect(&t, "ucnintv", "4");
    try expect(&t, "ucintvm", "3");
}
