const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Legacy per-system status entry (DVLNSTAT), 2 bytes.
pub const NStat = extern struct {
    dvlsmss: u8,
    dvlmvss: u8,
};

/// Per-system status entry (DVLSSTAT), 8 bytes.
pub const SStat = extern struct {
    dvlstsms: u8,
    dvlstmvs: u8,
    _res1: u8,
    dvlsrsms: u8,
    dvlogsms: u8,
    _res2: [3]u8,
};

/// SMS Volume Information (record type 'VL').
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 20.
/// The manual shows two endings (440 and 508 bytes); real z/OS 3.1 records are 440.
/// Repeating groups are positional JSON arrays: index N is the same system as index N
/// of BC's dbcsysnm (32 entries) / dbcfsysn (8 entries).
pub const RecordVL = extern struct {
    header: Header,
    dvlnmlen: u16,
    dvlvser: [6]u8,
    _res1: [24]u8,
    dvluser: [8]u8,
    dvldate: [10]u8,
    _res2: [2]u8,
    dvltime: [8]u8,
    dvlflags: [1]u8,
    dvlflgdc: [1]u8,
    _res3: [2]u8,
    dvlsglen: u16,
    dvlstgrp: [30]u8,
    dvlnstat: [8]NStat,
    dvlcsmss: [8]u8,
    dvlnucba: u32,
    dvlntcpy: u32,
    dvlnfree: u32,
    dvlnlext: u32,
    dvln0cnt: i16,
    dvltrksz: u16,
    dvlnlevl: i32,
    dvlsstat: [32]SStat,
    dvltrkcp: u32,
    dvltrkfr: u32,
    dvltrkex: u32,
    _res4: [4]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_vl;
        \\ CREATE TABLE record_vl (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dvlvser TEXT NOT NULL DEFAULT '',
        \\     dvluser TEXT NOT NULL DEFAULT '',
        \\     dvldate TEXT NOT NULL DEFAULT '',
        \\     dvltime TEXT NOT NULL DEFAULT '',
        \\     dvlconv BOOLEAN NOT NULL DEFAULT 0,
        \\     dvlstovr BOOLEAN NOT NULL DEFAULT 0,
        \\     dvlcpaon BOOLEAN NOT NULL DEFAULT 0,
        \\     dvl32nam BOOLEAN NOT NULL DEFAULT 0,
        \\     dvlstgrp TEXT NOT NULL DEFAULT '',
        \\     dvlsmss TEXT NOT NULL DEFAULT '[]',
        \\     dvlmvss TEXT NOT NULL DEFAULT '[]',
        \\     dvlcsmss TEXT NOT NULL DEFAULT '[]',
        \\     dvlnucba BIGINT NOT NULL DEFAULT 0,
        \\     dvlntcpy BIGINT NOT NULL DEFAULT 0,
        \\     dvlnfree BIGINT NOT NULL DEFAULT 0,
        \\     dvlnlext BIGINT NOT NULL DEFAULT 0,
        \\     dvln0cnt SMALLINT NOT NULL DEFAULT 0,
        \\     dvltrksz INTEGER NOT NULL DEFAULT 0,
        \\     dvlnlevl INTEGER NOT NULL DEFAULT 0,
        \\     dvlstsms TEXT NOT NULL DEFAULT '[]',
        \\     dvlstmvs TEXT NOT NULL DEFAULT '[]',
        \\     dvlsrsms TEXT NOT NULL DEFAULT '[]',
        \\     dvlogsms TEXT NOT NULL DEFAULT '[]',
        \\     dvltrkcp BIGINT NOT NULL DEFAULT 0,
        \\     dvltrkfr BIGINT NOT NULL DEFAULT 0,
        \\     dvltrkex BIGINT NOT NULL DEFAULT 0
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_vl (
        \\     dvlvser,
        \\     dvluser,
        \\     dvldate,
        \\     dvltime,
        \\     dvlconv,
        \\     dvlstovr,
        \\     dvlcpaon,
        \\     dvl32nam,
        \\     dvlstgrp,
        \\     dvlsmss,
        \\     dvlmvss,
        \\     dvlcsmss,
        \\     dvlnucba,
        \\     dvlntcpy,
        \\     dvlnfree,
        \\     dvlnlext,
        \\     dvln0cnt,
        \\     dvltrksz,
        \\     dvlnlevl,
        \\     dvlstsms,
        \\     dvlstmvs,
        \\     dvlsrsms,
        \\     dvlogsms,
        \\     dvltrkcp,
        \\     dvltrkfr,
        \\     dvltrkex) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flags_dvlconv = util.bitFlag(RecordVL, "dvlflags", 0x80);
    pub const flags_dvlstovr = util.bitFlag(RecordVL, "dvlflags", 0x08);
    pub const flags_dvlcpaon = util.bitFlag(RecordVL, "dvlflags", 0x02);

    pub const flgdc_dvl32nam = util.bitFlag(RecordVL, "dvlflgdc", 0x80);

    pub inline fn bind(self: *RecordVL, b: *common.Binder) !void {
        var json_buf: [256]u8 = undefined;

        // Lengths come from the input file; clamp so a corrupt record can't slice out of bounds.
        const vser = self.dvlvser[0..@min(self.dvlnmlen, self.dvlvser.len)];
        util.bcd2asc(vser);
        try b.text(vser);
        util.bcd2asc(&self.dvluser);
        try b.text(&self.dvluser);
        util.bcd2asc(&self.dvldate);
        try b.text(&self.dvldate);
        util.bcd2asc(&self.dvltime);
        try b.text(&self.dvltime);
        try b.boolean(self.flags_dvlconv());
        try b.boolean(self.flags_dvlstovr());
        try b.boolean(self.flags_dvlcpaon());
        try b.boolean(self.flgdc_dvl32nam());
        const stgrp = self.dvlstgrp[0..@min(self.dvlsglen, self.dvlstgrp.len)];
        util.bcd2asc(stgrp);
        try b.text(stgrp);

        var nums8: [8]u16 = undefined;
        for (&nums8, self.dvlnstat) |*out, s| out.* = s.dvlsmss;
        try b.text(try util.jsonArray(&json_buf, nums8));
        for (&nums8, self.dvlnstat) |*out, s| out.* = s.dvlmvss;
        try b.text(try util.jsonArray(&json_buf, nums8));
        for (&nums8, self.dvlcsmss) |*out, v| out.* = v;
        try b.text(try util.jsonArray(&json_buf, nums8));

        try b.int64(self.dvlnucba);
        try b.int64(self.dvlntcpy);
        try b.int64(self.dvlnfree);
        try b.int64(self.dvlnlext);
        try b.int(self.dvln0cnt);
        try b.int(self.dvltrksz);
        try b.int(self.dvlnlevl);

        var nums32: [32]u16 = undefined;
        for (&nums32, self.dvlsstat) |*out, s| out.* = s.dvlstsms;
        try b.text(try util.jsonArray(&json_buf, nums32));
        for (&nums32, self.dvlsstat) |*out, s| out.* = s.dvlstmvs;
        try b.text(try util.jsonArray(&json_buf, nums32));
        for (&nums32, self.dvlsstat) |*out, s| out.* = s.dvlsrsms;
        try b.text(try util.jsonArray(&json_buf, nums32));
        for (&nums32, self.dvlsstat) |*out, s| out.* = s.dvlogsms;
        try b.text(try util.jsonArray(&json_buf, nums32));

        try b.int64(self.dvltrkcp);
        try b.int64(self.dvltrkfr);
        try b.int64(self.dvltrkex);
    }
};

pub const Record = RecordVL;
pub const record_key = "VL";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordVL size: {d}\n", .{@sizeOf(RecordVL)});
    try std.testing.expect(@sizeOf(RecordVL) == 440);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(26, @offsetOf(RecordVL, "dvlvser"));
    try std.testing.expectEqual(56, @offsetOf(RecordVL, "dvluser"));
    try std.testing.expectEqual(84, @offsetOf(RecordVL, "dvlflags"));
    try std.testing.expectEqual(88, @offsetOf(RecordVL, "dvlsglen"));
    try std.testing.expectEqual(120, @offsetOf(RecordVL, "dvlnstat"));
    try std.testing.expectEqual(136, @offsetOf(RecordVL, "dvlcsmss"));
    try std.testing.expectEqual(144, @offsetOf(RecordVL, "dvlnucba"));
    try std.testing.expectEqual(160, @offsetOf(RecordVL, "dvln0cnt"));
    try std.testing.expectEqual(164, @offsetOf(RecordVL, "dvlnlevl"));
    try std.testing.expectEqual(168, @offsetOf(RecordVL, "dvlsstat"));
    try std.testing.expectEqual(424, @offsetOf(RecordVL, "dvltrkcp"));
    try std.testing.expectEqual(2, @sizeOf(NStat));
    try std.testing.expectEqual(8, @sizeOf(SStat));
}
