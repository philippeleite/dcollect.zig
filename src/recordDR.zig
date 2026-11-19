const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Legacy per-system OAM status entry (DDRNSTAT), 4 bytes.
pub const NStat = extern struct {
    ddrsout: u8,
    ddrcfcs: u8,
    _res: [2]u8,
};

/// Per-system status entry (DDRSTAT), 8 bytes.
pub const SysStat = extern struct {
    ddrreqst: u8,
    ddrcurst: u8,
    _res: [6]u8,
};

/// SMS Optical Drive Definition (record type 'DR').
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 23.
/// Not validated against real data: the sample file has no DR records.
/// Status arrays are positional JSON: index N is the system in BC's dbcfsysn (8) / dbcsysnm (32).
pub const RecordDR = extern struct {
    header: Header,
    ddrdvlen: u16,
    ddrname: [30]u8, // DDRDNAME (8) + reserved
    ddrduser: [8]u8,
    ddrddate: [10]u8,
    ddrflags: [1]u8,
    _res1: [1]u8,
    ddrdtime: [8]u8,
    ddrlblen: u16,
    ddrlibry: [30]u8, // DDRLBNM (8) + reserved
    ddrnstat: [8]NStat,
    ddrdcons: u32,
    ddrstat: [32]SysStat,
    _res2: [16]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_dr;
        \\ CREATE TABLE record_dr (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     ddrdname TEXT NOT NULL DEFAULT '',
        \\     ddrduser TEXT NOT NULL DEFAULT '',
        \\     ddrddate TEXT NOT NULL DEFAULT '',
        \\     ddrdtime TEXT NOT NULL DEFAULT '',
        \\     ddr32nam BOOLEAN NOT NULL DEFAULT 0,
        \\     ddrlbnm TEXT NOT NULL DEFAULT '',
        \\     ddrsout TEXT NOT NULL DEFAULT '[]',
        \\     ddrcfcs TEXT NOT NULL DEFAULT '[]',
        \\     ddrdcons BIGINT NOT NULL DEFAULT 0,
        \\     ddrreqst TEXT NOT NULL DEFAULT '[]',
        \\     ddrcurst TEXT NOT NULL DEFAULT '[]'
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_dr (
        \\     ddrdname, ddrduser, ddrddate, ddrdtime, ddr32nam, ddrlbnm,
        \\     ddrsout, ddrcfcs, ddrdcons, ddrreqst, ddrcurst
        \\ ) VALUES (?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flags_ddr32nam = util.bitFlag(RecordDR, "ddrflags", 0x80);

    pub inline fn bind(self: *RecordDR, b: *common.Binder) !void {
        var json_buf: [256]u8 = undefined;

        // Lengths come from the input file; clamp so a corrupt record can't slice out of bounds.
        try b.text(util.ascii(self.ddrname[0..@min(self.ddrdvlen, self.ddrname.len)]));
        util.bcd2asc(&self.ddrduser);
        try b.text(&self.ddrduser);
        util.bcd2asc(&self.ddrddate);
        try b.text(&self.ddrddate);
        util.bcd2asc(&self.ddrdtime);
        try b.text(&self.ddrdtime);
        try b.boolean(self.flags_ddr32nam());
        try b.text(util.ascii(self.ddrlibry[0..@min(self.ddrlblen, self.ddrlibry.len)]));

        var nums8: [8]u16 = undefined;
        for (&nums8, self.ddrnstat) |*out, s| out.* = s.ddrsout;
        try b.text(try util.jsonArray(&json_buf, nums8));
        for (&nums8, self.ddrnstat) |*out, s| out.* = s.ddrcfcs;
        try b.text(try util.jsonArray(&json_buf, nums8));

        try b.int64(self.ddrdcons);

        var nums32: [32]u16 = undefined;
        for (&nums32, self.ddrstat) |*out, s| out.* = s.ddrreqst;
        try b.text(try util.jsonArray(&json_buf, nums32));
        for (&nums32, self.ddrstat) |*out, s| out.* = s.ddrcurst;
        try b.text(try util.jsonArray(&json_buf, nums32));
    }
};

pub const Record = RecordDR;
pub const record_key = "DR";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordDR size: {d}\n", .{@sizeOf(RecordDR)});
    try std.testing.expect(@sizeOf(RecordDR) == 424);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(4, @sizeOf(NStat));
    try std.testing.expectEqual(8, @sizeOf(SysStat));
    try std.testing.expectEqual(26, @offsetOf(RecordDR, "ddrname"));
    try std.testing.expectEqual(56, @offsetOf(RecordDR, "ddrduser"));
    try std.testing.expectEqual(74, @offsetOf(RecordDR, "ddrflags"));
    try std.testing.expectEqual(76, @offsetOf(RecordDR, "ddrdtime"));
    try std.testing.expectEqual(84, @offsetOf(RecordDR, "ddrlblen"));
    try std.testing.expectEqual(116, @offsetOf(RecordDR, "ddrnstat"));
    try std.testing.expectEqual(148, @offsetOf(RecordDR, "ddrdcons"));
    try std.testing.expectEqual(152, @offsetOf(RecordDR, "ddrstat"));
}

test "synthetic DR record is decoded into record_dr" {
    const put = common.TestHarness.putEbcdic;
    var t: common.TestHarness = undefined;
    try t.init();
    defer t.deinit();

    var rec: [424]u8 = @splat(0);
    std.mem.writeInt(u16, rec[0..2], rec.len, .big);
    put(rec[4..6], "DR");
    std.mem.writeInt(u16, rec[24..26], 8, .big);
    put(rec[26..34], "OPTDRV01");
    put(rec[56..64], "IBMUSER ");
    put(rec[64..74], "2025/01/20");
    rec[74] = 0x80; // DDR32NAM
    put(rec[76..84], "08:15   ");
    std.mem.writeInt(u16, rec[84..86], 7, .big);
    put(rec[86..93], "OPTLIB1");
    rec[116] = 1; // legacy system 0: requested online
    rec[117] = 2; // ... currently offline
    std.mem.writeInt(u32, rec[148..152], 42, .big); // console id
    rec[152] = 1; // system 0: requested online
    rec[153] = 1; // ... currently online
    rec[160] = 2; // system 1: requested offline
    rec[161] = 0; // ... no connectivity

    try common.processRecord(&t.ctx, &rec);
    try std.testing.expectEqual(1, t.ctx.count.get("DR").?);

    const expect = struct {
        fn col(h: *common.TestHarness, comptime name: []const u8, want: []const u8) !void {
            try std.testing.expectEqualStrings(want, try h.queryText("SELECT " ++ name ++ " FROM record_dr"));
        }
    }.col;
    try expect(&t, "ddrdname", "OPTDRV01");
    try expect(&t, "ddrduser", "IBMUSER ");
    try expect(&t, "ddrddate", "2025/01/20");
    try expect(&t, "ddr32nam", "1");
    try expect(&t, "ddrlbnm", "OPTLIB1");
    try expect(&t, "ddrsout", "[1,0,0,0,0,0,0,0]");
    try expect(&t, "ddrcfcs", "[2,0,0,0,0,0,0,0]");
    try expect(&t, "ddrdcons", "42");
    try expect(&t, "json_extract(ddrreqst, '$[1]')", "2");
    try expect(&t, "json_extract(ddrcurst, '$[0]')", "1");
    try expect(&t, "json_array_length(ddrcurst)", "32");
}
