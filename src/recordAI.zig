const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// ACS routine information (DAIxRTN), 78 bytes. All fields are X'00' when the routine is not defined.
pub const Routine = extern struct {
    date: [10]u8,
    dsnm: [44]u8,
    dsmr: [8]u8,
    srid: [8]u8,
    time: [8]u8,
};

/// Accounting Information from ACS Routines (record type 'AI').
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 26.
pub const RecordAI = extern struct {
    header: Header,
    daidrtn: Routine, // data class routine
    daimrtn: Routine, // management class routine
    daisrtn: Routine, // storage class routine
    daigrtn: Routine, // storage group routine
    _res1: [16]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_ai;
        \\ CREATE TABLE record_ai (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     daiddate TEXT NOT NULL DEFAULT '',
        \\     daiddsnm TEXT NOT NULL DEFAULT '',
        \\     daiddsmr TEXT NOT NULL DEFAULT '',
        \\     daidsrid TEXT NOT NULL DEFAULT '',
        \\     daidtime TEXT NOT NULL DEFAULT '',
        \\     daimdate TEXT NOT NULL DEFAULT '',
        \\     daimdsnm TEXT NOT NULL DEFAULT '',
        \\     daimdsmr TEXT NOT NULL DEFAULT '',
        \\     daimsrid TEXT NOT NULL DEFAULT '',
        \\     daimtime TEXT NOT NULL DEFAULT '',
        \\     daisdate TEXT NOT NULL DEFAULT '',
        \\     daisdsnm TEXT NOT NULL DEFAULT '',
        \\     daisdsmr TEXT NOT NULL DEFAULT '',
        \\     daissrid TEXT NOT NULL DEFAULT '',
        \\     daistime TEXT NOT NULL DEFAULT '',
        \\     daigdate TEXT NOT NULL DEFAULT '',
        \\     daigdsnm TEXT NOT NULL DEFAULT '',
        \\     daigdsmr TEXT NOT NULL DEFAULT '',
        \\     daigsrid TEXT NOT NULL DEFAULT '',
        \\     daigtime TEXT NOT NULL DEFAULT ''
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_ai (
        \\     daiddate, daiddsnm, daiddsmr, daidsrid, daidtime,
        \\     daimdate, daimdsnm, daimdsmr, daimsrid, daimtime,
        \\     daisdate, daisdsnm, daisdsmr, daissrid, daistime,
        \\     daigdate, daigdsnm, daigdsmr, daigsrid, daigtime
        \\ ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub inline fn bind(self: *RecordAI, b: *common.Binder) !void {
        // Column order: data, management, storage class, storage group routine.
        for ([_]*Routine{ &self.daidrtn, &self.daimrtn, &self.daisrtn, &self.daigrtn }) |r| {
            inline for (.{ &r.date, &r.dsnm, &r.dsmr, &r.srid, &r.time }) |field| {
                util.bcd2asc(field);
                try b.text(util.trimPad(field));
            }
        }
    }
};

pub const Record = RecordAI;
pub const record_key = "AI";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordAI size: {d}\n", .{@sizeOf(RecordAI)});
    try std.testing.expect(@sizeOf(RecordAI) == 352);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(78, @sizeOf(Routine));
    try std.testing.expectEqual(24, @offsetOf(RecordAI, "daidrtn"));
    try std.testing.expectEqual(102, @offsetOf(RecordAI, "daimrtn"));
    try std.testing.expectEqual(180, @offsetOf(RecordAI, "daisrtn"));
    try std.testing.expectEqual(258, @offsetOf(RecordAI, "daigrtn"));
    try std.testing.expectEqual(10, @offsetOf(Routine, "dsnm"));
    try std.testing.expectEqual(54, @offsetOf(Routine, "dsmr"));
    try std.testing.expectEqual(62, @offsetOf(Routine, "srid"));
    try std.testing.expectEqual(70, @offsetOf(Routine, "time"));
}
