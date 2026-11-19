const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Tape Capacity Planning Information (record type 'T', written by DFSMShsm with CAPPLANDATA).
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 15.
/// Not validated against real data: the sample file has no T records.
pub const RecordT = extern struct {
    header: Header,
    utstype: [1]u8, // 'B' = backup, 'D' = dump, 'M' = migration tapes
    _res1: [3]u8,
    utfull: i32,
    utpart: i32,
    utempty: i32,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_t;
        \\ CREATE TABLE record_t (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     utstype TEXT NOT NULL DEFAULT '',
        \\     utfull INTEGER NOT NULL DEFAULT 0,
        \\     utpart INTEGER NOT NULL DEFAULT 0,
        \\     utempty INTEGER NOT NULL DEFAULT 0
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_t (utstype, utfull, utpart, utempty) VALUES (?,?,?,?);
        \\
    ;

    pub inline fn bind(self: *RecordT, b: *common.Binder) !void {
        try b.text(util.ascii(&self.utstype));
        try b.int(self.utfull);
        try b.int(self.utpart);
        try b.int(self.utempty);
    }
};

pub const Record = RecordT;
pub const record_key = "T ";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordT size: {d}\n", .{@sizeOf(RecordT)});
    try std.testing.expect(@sizeOf(RecordT) == 40);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(24, @offsetOf(RecordT, "utstype"));
    try std.testing.expectEqual(28, @offsetOf(RecordT, "utfull"));
    try std.testing.expectEqual(32, @offsetOf(RecordT, "utpart"));
    try std.testing.expectEqual(36, @offsetOf(RecordT, "utempty"));
}

test "synthetic T records are decoded into record_t" {
    const put = common.TestHarness.putEbcdic;
    var t: common.TestHarness = undefined;
    try t.init();
    defer t.deinit();

    // DFSMShsm writes one T record per tape type.
    for ([_]struct { []const u8, i32, i32, i32 }{
        .{ "B", 120, 7, 30 },
        .{ "M", 450, 12, 0 },
    }) |row| {
        var rec: [40]u8 = @splat(0);
        std.mem.writeInt(u16, rec[0..2], rec.len, .big);
        put(rec[4..6], "T ");
        put(rec[24..25], row[0]);
        std.mem.writeInt(i32, rec[28..32], row[1], .big);
        std.mem.writeInt(i32, rec[32..36], row[2], .big);
        std.mem.writeInt(i32, rec[36..40], row[3], .big);
        try common.processRecord(&t.ctx, &rec);
    }
    try std.testing.expectEqual(2, t.ctx.count.get("T ").?);

    try std.testing.expectEqualStrings("B|120|7|30", try t.queryText(
        "SELECT utstype || '|' || utfull || '|' || utpart || '|' || utempty FROM record_t WHERE utstype = 'B'",
    ));
    try std.testing.expectEqualStrings("M|450|12|0", try t.queryText(
        "SELECT utstype || '|' || utfull || '|' || utpart || '|' || utempty FROM record_t WHERE utstype = 'M'",
    ));
}
