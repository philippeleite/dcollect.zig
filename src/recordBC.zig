const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Per-system entry (DBCSYSDT), 16 bytes.
pub const SysDt = extern struct {
    dbcsysnm: [8]u8,
    dbcsysft: [2]u8,
    _res1: [2]u8,
    dbcsnmty: u8,
    _res2: [3]u8,
};

/// Base Configuration Information (record type 'BC').
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 21.
/// Repeating groups are stored as positional JSON arrays (query them with json_each());
/// index N of the 32-entry arrays is the same system as index N of SG's dsgsysst/dsgcnsms.
pub const RecordBC = extern struct {
    header: Header,
    _res1: [32]u8,
    dbcuser: [8]u8,
    dbcdate: [10]u8,
    _res2: [2]u8,
    dbctime: [8]u8,
    dbcdesc: [120]u8,
    dbcflags: [1]u8,
    dbcflgdc: [1]u8,
    _res3: [2]u8,
    dbcmclen: u16,
    dbcmcnam: [30]u8,
    dbctrksz: i32,
    dbccylcp: i32,
    dbcdunit: [8]u8,
    dbcsrst: [8]u8,
    dbcstat: u8,
    _res4: [3]u8,
    dbcfsysn: [8][8]u8,
    dbcscdsn: [44]u8,
    dbcsfeat: [8][2]u8,
    dbcsysnt: [8]u8,
    dbcsysdt: [32]SysDt,
    _res5: [16]u8,
    dbcsepnl: u16,
    dbcsepnm: [54]u8, // printed as "DBSEPNM" in the manual

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_bc;
        \\ CREATE TABLE record_bc (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dbcuser TEXT NOT NULL DEFAULT '',
        \\     dbcdate TEXT NOT NULL DEFAULT '',
        \\     dbctime TEXT NOT NULL DEFAULT '',
        \\     dbcdesc TEXT NOT NULL DEFAULT '',
        \\     dbc32nam BOOLEAN NOT NULL DEFAULT 0,
        \\     dbcmcnam TEXT NOT NULL DEFAULT '',
        \\     dbctrksz INTEGER NOT NULL DEFAULT 0,
        \\     dbccylcp INTEGER NOT NULL DEFAULT 0,
        \\     dbcdunit TEXT NOT NULL DEFAULT '',
        \\     dbcsrst TEXT NOT NULL DEFAULT '',
        \\     dbcstat SMALLINT NOT NULL DEFAULT 0,
        \\     dbcfsysn TEXT NOT NULL DEFAULT '[]',
        \\     dbcscdsn TEXT NOT NULL DEFAULT '',
        \\     dbcsfeat TEXT NOT NULL DEFAULT '[]',
        \\     dbcsysnt TEXT NOT NULL DEFAULT '[]',
        \\     dbcsysnm TEXT NOT NULL DEFAULT '[]',
        \\     dbcsysft TEXT NOT NULL DEFAULT '[]',
        \\     dbcsnmty TEXT NOT NULL DEFAULT '[]',
        \\     dbcsepnm TEXT NOT NULL DEFAULT ''
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_bc (
        \\     dbcuser,
        \\     dbcdate,
        \\     dbctime,
        \\     dbcdesc,
        \\     dbc32nam,
        \\     dbcmcnam,
        \\     dbctrksz,
        \\     dbccylcp,
        \\     dbcdunit,
        \\     dbcsrst,
        \\     dbcstat,
        \\     dbcfsysn,
        \\     dbcscdsn,
        \\     dbcsfeat,
        \\     dbcsysnt,
        \\     dbcsysnm,
        \\     dbcsysft,
        \\     dbcsnmty,
        \\     dbcsepnm) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flgdc_dbc32nam = util.bitFlag(RecordBC, "dbcflgdc", 0x80);

    /// EBCDIC field -> ASCII with trailing blank/X'00' padding removed.
    fn ascii(field: []u8) []const u8 {
        util.bcd2asc(field);
        return util.trimPad(field);
    }

    pub inline fn bind(self: *RecordBC, b: *common.Binder) !void {
        // 32 names of up to 8 chars; sized for worst-case JSON escaping (\u00XX per byte).
        var json_buf: [2048]u8 = undefined;

        util.bcd2asc(&self.dbcuser);
        try b.text(&self.dbcuser);
        util.bcd2asc(&self.dbcdate);
        try b.text(&self.dbcdate);
        util.bcd2asc(&self.dbctime);
        try b.text(&self.dbctime);
        util.bcd2asc(&self.dbcdesc);
        try b.text(&self.dbcdesc);
        try b.boolean(self.flgdc_dbc32nam());
        // Length comes from the input file; clamp so a corrupt record can't slice out of bounds.
        try b.text(ascii(self.dbcmcnam[0..@min(self.dbcmclen, self.dbcmcnam.len)]));
        try b.int(self.dbctrksz);
        try b.int(self.dbccylcp);
        try b.text(ascii(&self.dbcdunit));
        // SMS resource status token is binary.
        try b.text(&std.fmt.bytesToHex(self.dbcsrst, .upper));
        try b.int(self.dbcstat);

        var names8: [8][]const u8 = undefined;
        for (&names8, &self.dbcfsysn) |*out, *n| out.* = ascii(n);
        try b.text(try util.jsonArray(&json_buf, names8));

        try b.text(ascii(&self.dbcscdsn));

        var nums8: [8]u16 = undefined;
        for (&nums8, self.dbcsfeat) |*out, f| out.* = std.mem.readInt(u16, &f, .big);
        try b.text(try util.jsonArray(&json_buf, nums8));
        for (&nums8, self.dbcsysnt) |*out, t| out.* = t;
        try b.text(try util.jsonArray(&json_buf, nums8));

        var names32: [32][]const u8 = undefined;
        for (&names32, &self.dbcsysdt) |*out, *s| out.* = ascii(&s.dbcsysnm);
        try b.text(try util.jsonArray(&json_buf, names32));
        var nums32: [32]u16 = undefined;
        for (&nums32, self.dbcsysdt) |*out, s| out.* = std.mem.readInt(u16, &s.dbcsysft, .big);
        try b.text(try util.jsonArray(&json_buf, nums32));
        for (&nums32, self.dbcsysdt) |*out, s| out.* = s.dbcsnmty;
        try b.text(try util.jsonArray(&json_buf, nums32));

        try b.text(ascii(self.dbcsepnm[0..@min(self.dbcsepnl, self.dbcsepnm.len)]));
    }
};

pub const Record = RecordBC;
pub const record_key = "BC";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordBC size: {d}\n", .{@sizeOf(RecordBC)});
    try std.testing.expect(@sizeOf(RecordBC) == 984);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(56, @offsetOf(RecordBC, "dbcuser"));
    try std.testing.expectEqual(205, @offsetOf(RecordBC, "dbcflgdc"));
    try std.testing.expectEqual(208, @offsetOf(RecordBC, "dbcmclen"));
    try std.testing.expectEqual(240, @offsetOf(RecordBC, "dbctrksz"));
    try std.testing.expectEqual(256, @offsetOf(RecordBC, "dbcsrst"));
    try std.testing.expectEqual(268, @offsetOf(RecordBC, "dbcfsysn"));
    try std.testing.expectEqual(332, @offsetOf(RecordBC, "dbcscdsn"));
    try std.testing.expectEqual(376, @offsetOf(RecordBC, "dbcsfeat"));
    try std.testing.expectEqual(392, @offsetOf(RecordBC, "dbcsysnt"));
    try std.testing.expectEqual(400, @offsetOf(RecordBC, "dbcsysdt"));
    try std.testing.expectEqual(928, @offsetOf(RecordBC, "dbcsepnl"));
    try std.testing.expectEqual(16, @sizeOf(SysDt));
}
