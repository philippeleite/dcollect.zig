const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// SMS Cache Set and SES Cache Names (record type 'CN').
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 25.
/// Not validated against real data: the sample file has no CN records.
pub const RecordCN = extern struct {
    header: Header,
    dcncsnam: [8]u8,
    dcnsesnm: [8][16]u8,
    _res1: [16]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_cn;
        \\ CREATE TABLE record_cn (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dcncsnam TEXT NOT NULL DEFAULT '',
        \\     dcnsesnm TEXT NOT NULL DEFAULT '[]'
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_cn (dcncsnam, dcnsesnm) VALUES (?,?);
        \\
    ;

    pub inline fn bind(self: *RecordCN, b: *common.Binder) !void {
        // 8 names of up to 16 chars; sized for worst-case JSON escaping.
        var json_buf: [1024]u8 = undefined;

        try b.text(util.ascii(&self.dcncsnam));

        // Only defined SES cache names (not per-system, so no positional slots).
        var names: [8][]const u8 = undefined;
        var n: usize = 0;
        for (&self.dcnsesnm) |*name| {
            const s = util.ascii(name);
            if (s.len == 0) continue;
            names[n] = s;
            n += 1;
        }
        try b.text(try util.jsonArray(&json_buf, names[0..n]));
    }
};

pub const Record = RecordCN;
pub const record_key = "CN";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordCN size: {d}\n", .{@sizeOf(RecordCN)});
    try std.testing.expect(@sizeOf(RecordCN) == 176);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(24, @offsetOf(RecordCN, "dcncsnam"));
    try std.testing.expectEqual(32, @offsetOf(RecordCN, "dcnsesnm"));
    try std.testing.expectEqual(160, @offsetOf(RecordCN, "_res1"));
}

test "synthetic CN record is decoded into record_cn" {
    const put = common.TestHarness.putEbcdic;
    var t: common.TestHarness = undefined;
    try t.init();
    defer t.deinit();

    var rec: [176]u8 = @splat(0);
    std.mem.writeInt(u16, rec[0..2], rec.len, .big);
    put(rec[4..6], "CN");
    @memset(rec[24..160], 0x40); // EBCDIC blanks
    put(rec[24..32], "CACHESET");
    put(rec[32..41], "CACHE01");
    put(rec[48..58], "CACHE02_PR");
    // entries 3..8 left blank

    try common.processRecord(&t.ctx, &rec);
    try std.testing.expectEqual(1, t.ctx.count.get("CN").?);
    try std.testing.expectEqualStrings("CACHESET", try t.queryText("SELECT dcncsnam FROM record_cn"));
    try std.testing.expectEqualStrings(
        \\["CACHE01","CACHE02_PR"]
    , try t.queryText("SELECT dcnsesnm FROM record_cn"));
    try std.testing.expectEqualStrings("CACHE02_PR", try t.queryText(
        "SELECT j.value FROM record_cn, json_each(record_cn.dcnsesnm) AS j WHERE j.key = 1",
    ));
}
