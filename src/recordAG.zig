const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Selection data set entry (DAGDSNMS), 52 bytes.
pub const DsnMem = extern struct {
    dsn: [44]u8,
    mem: [8]u8,
};

/// Aggregate Group Definition (record type 'AG').
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 22.
/// Not validated against real data: the sample file has no AG records.
pub const RecordAG = extern struct {
    header: Header,
    dagnmlen: u16,
    dagname: [30]u8,
    daguser: [8]u8,
    dagdate: [10]u8,
    _res1: [2]u8,
    dagtime: [8]u8,
    dagdesc: [120]u8,
    dagflags: [1]u8,
    _res2: [3]u8,
    dagretpd: i32, // overlaid by DAGEXPYR (i16) + DAGEXPDY (i16)
    dagdest: [30]u8,
    dagprefx: [33]u8,
    _res3: [1]u8,
    dagidsnm: DsnMem, // instruction data set (DAGINDSN + DAGINMEM)
    dagdsnms: [5]DsnMem,
    dagmclen: u16,
    dagmcnam: [30]u8,
    dagncopy: i32,
    _res4: [16]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_ag;
        \\ CREATE TABLE record_ag (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dagname TEXT NOT NULL DEFAULT '',
        \\     daguser TEXT NOT NULL DEFAULT '',
        \\     dagdate TEXT NOT NULL DEFAULT '',
        \\     dagtime TEXT NOT NULL DEFAULT '',
        \\     dagdesc TEXT NOT NULL DEFAULT '',
        \\     dagtenq BOOLEAN NOT NULL DEFAULT 0,
        \\     dagfret BOOLEAN NOT NULL DEFAULT 0,
        \\     dagfncpy BOOLEAN NOT NULL DEFAULT 0,
        \\     dagretpd INTEGER NOT NULL DEFAULT 0,
        \\     dagexpyr SMALLINT NOT NULL DEFAULT 0,
        \\     dagexpdy SMALLINT NOT NULL DEFAULT 0,
        \\     dagdest TEXT NOT NULL DEFAULT '',
        \\     dagprefx TEXT NOT NULL DEFAULT '',
        \\     dagindsn TEXT NOT NULL DEFAULT '',
        \\     daginmem TEXT NOT NULL DEFAULT '',
        \\     dagdsnms TEXT NOT NULL DEFAULT '[]',
        \\     dagmcnam TEXT NOT NULL DEFAULT '',
        \\     dagncopy INTEGER NOT NULL DEFAULT 0
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_ag (
        \\     dagname, daguser, dagdate, dagtime, dagdesc,
        \\     dagtenq, dagfret, dagfncpy, dagretpd, dagexpyr, dagexpdy,
        \\     dagdest, dagprefx, dagindsn, daginmem, dagdsnms, dagmcnam, dagncopy
        \\ ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flags_dagtenq = util.bitFlag(RecordAG, "dagflags", 0x80);
    pub const flags_dagfret = util.bitFlag(RecordAG, "dagflags", 0x40);
    pub const flags_dagfncpy = util.bitFlag(RecordAG, "dagflags", 0x20);

    pub inline fn bind(self: *RecordAG, b: *common.Binder) !void {
        // 5 entries of up to 52 chars plus keys; sized for worst-case JSON escaping.
        var json_buf: [2048]u8 = undefined;

        // Length comes from the input file; clamp so a corrupt record can't slice out of bounds.
        const name = self.dagname[0..@min(self.dagnmlen, self.dagname.len)];
        util.bcd2asc(name);
        try b.text(name);
        util.bcd2asc(&self.daguser);
        try b.text(&self.daguser);
        util.bcd2asc(&self.dagdate);
        try b.text(&self.dagdate);
        util.bcd2asc(&self.dagtime);
        try b.text(&self.dagtime);
        util.bcd2asc(&self.dagdesc);
        try b.text(&self.dagdesc);
        try b.boolean(self.flags_dagtenq());
        try b.boolean(self.flags_dagfret());
        try b.boolean(self.flags_dagfncpy());
        try b.int(self.dagretpd);
        const retpd: u32 = @bitCast(self.dagretpd);
        try b.int(@as(i16, @bitCast(@as(u16, @truncate(retpd >> 16))))); // DAGEXPYR
        try b.int(@as(i16, @bitCast(@as(u16, @truncate(retpd))))); // DAGEXPDY
        try b.text(util.ascii(&self.dagdest));
        try b.text(util.ascii(&self.dagprefx));
        try b.text(util.ascii(&self.dagidsnm.dsn));
        try b.text(util.ascii(&self.dagidsnm.mem));

        // Only defined selection data sets, as objects: [{"dsn":"...","member":"..."}].
        const Entry = struct { dsn: []const u8, member: []const u8 };
        var entries: [5]Entry = undefined;
        var n: usize = 0;
        for (&self.dagdsnms) |*e| {
            const dsn = util.ascii(&e.dsn);
            if (dsn.len == 0) continue;
            entries[n] = .{ .dsn = dsn, .member = util.ascii(&e.mem) };
            n += 1;
        }
        try b.text(try util.jsonArray(&json_buf, entries[0..n]));

        try b.text(util.ascii(self.dagmcnam[0..@min(self.dagmclen, self.dagmcnam.len)]));
        try b.int(self.dagncopy);
    }
};

pub const Record = RecordAG;
pub const record_key = "AG";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordAG size: {d}\n", .{@sizeOf(RecordAG)});
    try std.testing.expect(@sizeOf(RecordAG) == 640);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(52, @sizeOf(DsnMem));
    try std.testing.expectEqual(204, @offsetOf(RecordAG, "dagflags"));
    try std.testing.expectEqual(208, @offsetOf(RecordAG, "dagretpd"));
    try std.testing.expectEqual(212, @offsetOf(RecordAG, "dagdest"));
    try std.testing.expectEqual(242, @offsetOf(RecordAG, "dagprefx"));
    try std.testing.expectEqual(276, @offsetOf(RecordAG, "dagidsnm"));
    try std.testing.expectEqual(328, @offsetOf(RecordAG, "dagdsnms"));
    try std.testing.expectEqual(588, @offsetOf(RecordAG, "dagmclen"));
    try std.testing.expectEqual(620, @offsetOf(RecordAG, "dagncopy"));
}

test "synthetic AG record is decoded into record_ag" {
    const put = common.TestHarness.putEbcdic;
    var t: common.TestHarness = undefined;
    try t.init();
    defer t.deinit();

    var rec: [640]u8 = @splat(0);
    std.mem.writeInt(u16, rec[0..2], rec.len, .big);
    put(rec[4..6], "AG");
    @memset(rec[24..640], 0x40); // construct records are blank-filled
    @memset(rec[204..212], 0); // flags, reserved, DAGRETPD
    @memset(rec[588..590], 0); // DAGMCLEN
    @memset(rec[620..640], 0); // DAGNCOPY, reserved
    std.mem.writeInt(u16, rec[24..26], 7, .big);
    put(rec[26..33], "PAYROLL");
    put(rec[56..64], "IBMUSER");
    put(rec[64..74], "2025/03/14");
    put(rec[76..84], "09:30");
    put(rec[84..105], "PAYROLL APPL BACKUP");
    rec[204] = 0x80 | 0x20; // DAGTENQ, DAGFNCPY
    std.mem.writeInt(i16, rec[208..210], 2026, .big); // DAGEXPYR
    std.mem.writeInt(i16, rec[210..212], 365, .big); // DAGEXPDY
    put(rec[212..220], "OFFSITE1");
    put(rec[242..256], "ABARS.PAYROLL");
    put(rec[276..293], "PAYROLL.ABARS.CTL");
    put(rec[320..328], "INSTR");
    put(rec[328..344], "PAYROLL.SEL.LIST");
    put(rec[372..377], "DAILY");
    put(rec[380..395], "PAYROLL.SEL.GDG"); // 2nd entry, no member
    std.mem.writeInt(u16, rec[588..590], 7, .big);
    put(rec[590..597], "STANDEF");
    std.mem.writeInt(i32, rec[620..624], 2, .big);

    try common.processRecord(&t.ctx, &rec);
    try std.testing.expectEqual(1, t.ctx.count.get("AG").?);

    const expect = struct {
        fn col(h: *common.TestHarness, comptime name: []const u8, want: []const u8) !void {
            try std.testing.expectEqualStrings(want, try h.queryText("SELECT " ++ name ++ " FROM record_ag"));
        }
    }.col;
    try expect(&t, "dagname", "PAYROLL");
    try expect(&t, "trim(daguser)", "IBMUSER");
    try expect(&t, "dagdate", "2025/03/14");
    try expect(&t, "trim(dagdesc)", "PAYROLL APPL BACKUP");
    try expect(&t, "dagtenq", "1");
    try expect(&t, "dagfret", "0");
    try expect(&t, "dagfncpy", "1");
    try expect(&t, "dagexpyr", "2026");
    try expect(&t, "dagexpdy", "365");
    try expect(&t, "dagdest", "OFFSITE1");
    try expect(&t, "dagprefx", "ABARS.PAYROLL");
    try expect(&t, "dagindsn", "PAYROLL.ABARS.CTL");
    try expect(&t, "daginmem", "INSTR");
    try expect(&t, "dagdsnms",
        \\[{"dsn":"PAYROLL.SEL.LIST","member":"DAILY"},{"dsn":"PAYROLL.SEL.GDG","member":""}]
    );
    try expect(&t, "(SELECT group_concat(json_extract(value, '$.dsn')) FROM json_each(dagdsnms))", "PAYROLL.SEL.LIST,PAYROLL.SEL.GDG");
    try expect(&t, "dagmcnam", "STANDEF");
    try expect(&t, "dagncopy", "2");
}
