const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Backup Data Set Information (record type 'B', written by DFSMShsm with BACKUPDATA).
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 15.
/// Not validated against real data: the sample file has no B records.
pub const RecordB = extern struct {
    header: Header,
    ubdsnam: [44]u8,
    ubflag1: [1]u8,
    ubdevcl: [1]u8,
    ubdsorg1: [1]u8, // DS1DSORG byte 1
    ubdsorg2: [1]u8, // DS1DSORG byte 2
    ubdsize: i32,
    ubtime: [4]u8, // packed hhmmssth
    ubdate: [4]u8, // packed yyyydddF
    ubdclng: u16,
    ubdatcl: [30]u8,
    ubsclng: u16,
    ubstgcl: [30]u8,
    ubmclng: u16,
    ubmgtcl: [30]u8,
    ubrecrd: [1]u8,
    ubrecor: [1]u8,
    ubbklng: u16,
    ubflag2: [1]u8,
    ubflag3: [1]u8,
    ub_retaindays: u16,
    uballsp: i32,
    ubusesp: i32,
    ubrecsp: i32,
    ub_user_datasize: i32,
    ub_comp_datasize: i32,
    ubfrvol: [6]u8,
    ubflag4: [1]u8,
    _res1: [13]u8,
    ubencrpt: u16,
    ubencrpl: [64]u8,
    ubencrpr: [30]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_b;
        \\ CREATE TABLE record_b (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     ubdsnam TEXT NOT NULL DEFAULT '',
        \\     ubincat BOOLEAN NOT NULL DEFAULT 0,
        \\     ubnoenq BOOLEAN NOT NULL DEFAULT 0,
        \\     ubbwo BOOLEAN NOT NULL DEFAULT 0,
        \\     ubnqn1 BOOLEAN NOT NULL DEFAULT 0,
        \\     ubnqn2 BOOLEAN NOT NULL DEFAULT 0,
        \\     ubdevcl TEXT NOT NULL DEFAULT '',
        \\     ubdsgis BOOLEAN NOT NULL DEFAULT 0,
        \\     ubdsgps BOOLEAN NOT NULL DEFAULT 0,
        \\     ubdsgda BOOLEAN NOT NULL DEFAULT 0,
        \\     ubdsgpo BOOLEAN NOT NULL DEFAULT 0,
        \\     ubdsgu BOOLEAN NOT NULL DEFAULT 0,
        \\     ubdsggs BOOLEAN NOT NULL DEFAULT 0,
        \\     ubdsgvs BOOLEAN NOT NULL DEFAULT 0,
        \\     ubdsize BIGINT NOT NULL DEFAULT 0,
        \\     ubdate DATE NOT NULL DEFAULT '0000-00-00',
        \\     ubtime TEXT NOT NULL DEFAULT '',
        \\     ubdatcl TEXT NOT NULL DEFAULT '',
        \\     ubstgcl TEXT NOT NULL DEFAULT '',
        \\     ubmgtcl TEXT NOT NULL DEFAULT '',
        \\     ubrecfm TEXT NOT NULL DEFAULT '',
        \\     ubrecft BOOLEAN NOT NULL DEFAULT 0,
        \\     ubrecfb BOOLEAN NOT NULL DEFAULT 0,
        \\     ubrecfs BOOLEAN NOT NULL DEFAULT 0,
        \\     ubrecfa BOOLEAN NOT NULL DEFAULT 0,
        \\     ubrecfc BOOLEAN NOT NULL DEFAULT 0,
        \\     ubesds BOOLEAN NOT NULL DEFAULT 0,
        \\     ubksds BOOLEAN NOT NULL DEFAULT 0,
        \\     ublds BOOLEAN NOT NULL DEFAULT 0,
        \\     ubrrds BOOLEAN NOT NULL DEFAULT 0,
        \\     ubbklng INTEGER NOT NULL DEFAULT 0,
        \\     ubracfd BOOLEAN NOT NULL DEFAULT 0,
        \\     ubgds BOOLEAN NOT NULL DEFAULT 0,
        \\     ubreblk BOOLEAN NOT NULL DEFAULT 0,
        \\     ubpdse BOOLEAN NOT NULL DEFAULT 0,
        \\     ubsmsm BOOLEAN NOT NULL DEFAULT 0,
        \\     ubcompr BOOLEAN NOT NULL DEFAULT 0,
        \\     ublfs BOOLEAN NOT NULL DEFAULT 0,
        \\     ubnewname BOOLEAN NOT NULL DEFAULT 0,
        \\     ubnosphere BOOLEAN NOT NULL DEFAULT 0,
        \\     ubgvcn BOOLEAN NOT NULL DEFAULT 0,
        \\     ubf_retain_spcd BOOLEAN NOT NULL DEFAULT 0,
        \\     ubf_never_exp BOOLEAN NOT NULL DEFAULT 0,
        \\     ubencrp BOOLEAN NOT NULL DEFAULT 0,
        \\     ubzfs BOOLEAN NOT NULL DEFAULT 0,
        \\     ubencrdp BOOLEAN NOT NULL DEFAULT 0,
        \\     ub_retaindays INTEGER NOT NULL DEFAULT 0,
        \\     uballsp BIGINT NOT NULL DEFAULT 0,
        \\     ubusesp BIGINT NOT NULL DEFAULT 0,
        \\     ubrecsp BIGINT NOT NULL DEFAULT 0,
        \\     ub_user_datasize BIGINT NOT NULL DEFAULT 0,
        \\     ub_comp_datasize BIGINT NOT NULL DEFAULT 0,
        \\     ubfrvol TEXT NOT NULL DEFAULT '',
        \\     ubencrpt INTEGER NOT NULL DEFAULT 0,
        \\     ubencrpl TEXT NOT NULL DEFAULT ''
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_b (
        \\     ubdsnam, ubincat, ubnoenq, ubbwo, ubnqn1, ubnqn2, ubdevcl,
        \\     ubdsgis, ubdsgps, ubdsgda, ubdsgpo, ubdsgu, ubdsggs, ubdsgvs,
        \\     ubdsize, ubdate, ubtime, ubdatcl, ubstgcl, ubmgtcl,
        \\     ubrecfm, ubrecft, ubrecfb, ubrecfs, ubrecfa, ubrecfc,
        \\     ubesds, ubksds, ublds, ubrrds, ubbklng,
        \\     ubracfd, ubgds, ubreblk, ubpdse, ubsmsm, ubcompr, ublfs, ubnewname,
        \\     ubnosphere, ubgvcn, ubf_retain_spcd, ubf_never_exp, ubencrp, ubzfs, ubencrdp,
        \\     ub_retaindays, uballsp, ubusesp, ubrecsp, ub_user_datasize, ub_comp_datasize,
        \\     ubfrvol, ubencrpt, ubencrpl
        \\ ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flag1_ubincat = util.bitFlag(RecordB, "ubflag1", 0x80);
    pub const flag1_ubnoenq = util.bitFlag(RecordB, "ubflag1", 0x40);
    pub const flag1_ubbwo = util.bitFlag(RecordB, "ubflag1", 0x20);
    pub const flag1_ubnqn1 = util.bitFlag(RecordB, "ubflag1", 0x10);
    pub const flag1_ubnqn2 = util.bitFlag(RecordB, "ubflag1", 0x08);

    pub const dsorg_ubdsgis = util.bitFlag(RecordB, "ubdsorg1", 0x80);
    pub const dsorg_ubdsgps = util.bitFlag(RecordB, "ubdsorg1", 0x40);
    pub const dsorg_ubdsgda = util.bitFlag(RecordB, "ubdsorg1", 0x20);
    pub const dsorg_ubdsgpo = util.bitFlag(RecordB, "ubdsorg1", 0x02);
    pub const dsorg_ubdsgu = util.bitFlag(RecordB, "ubdsorg1", 0x01);
    pub const dsorg_ubdsggs = util.bitFlag(RecordB, "ubdsorg2", 0x80);
    pub const dsorg_ubdsgvs = util.bitFlag(RecordB, "ubdsorg2", 0x08);

    pub const recrd_ubrecff = util.bitFlag(RecordB, "ubrecrd", 0x80);
    pub const recrd_ubrecfv = util.bitFlag(RecordB, "ubrecrd", 0x40);
    pub const recrd_ubrecft = util.bitFlag(RecordB, "ubrecrd", 0x20);
    pub const recrd_ubrecfb = util.bitFlag(RecordB, "ubrecrd", 0x10);
    pub const recrd_ubrecfs = util.bitFlag(RecordB, "ubrecrd", 0x08);
    pub const recrd_ubrecfa = util.bitFlag(RecordB, "ubrecrd", 0x04);
    pub const recrd_ubrecfc = util.bitFlag(RecordB, "ubrecrd", 0x02);

    pub const recor_ubesds = util.bitFlag(RecordB, "ubrecor", 0x80);
    pub const recor_ubksds = util.bitFlag(RecordB, "ubrecor", 0x40);
    pub const recor_ublds = util.bitFlag(RecordB, "ubrecor", 0x20);
    pub const recor_ubrrds = util.bitFlag(RecordB, "ubrecor", 0x10);

    pub const flag2_ubracfd = util.bitFlag(RecordB, "ubflag2", 0x80);
    pub const flag2_ubgds = util.bitFlag(RecordB, "ubflag2", 0x40);
    pub const flag2_ubreblk = util.bitFlag(RecordB, "ubflag2", 0x20);
    pub const flag2_ubpdse = util.bitFlag(RecordB, "ubflag2", 0x10);
    pub const flag2_ubsmsm = util.bitFlag(RecordB, "ubflag2", 0x08);
    pub const flag2_ubcompr = util.bitFlag(RecordB, "ubflag2", 0x04);
    pub const flag2_ublfs = util.bitFlag(RecordB, "ubflag2", 0x02);
    pub const flag2_ubnewname = util.bitFlag(RecordB, "ubflag2", 0x01);

    pub const flag3_ubnosphere = util.bitFlag(RecordB, "ubflag3", 0x80);
    pub const flag3_ubgvcn = util.bitFlag(RecordB, "ubflag3", 0x40);
    pub const flag3_ubf_retain_spcd = util.bitFlag(RecordB, "ubflag3", 0x20);
    pub const flag3_ubf_never_exp = util.bitFlag(RecordB, "ubflag3", 0x10);
    pub const flag3_ubencrp = util.bitFlag(RecordB, "ubflag3", 0x08);
    pub const flag3_ubzfs = util.bitFlag(RecordB, "ubflag3", 0x04);
    pub const flag3_ubencrdp = util.bitFlag(RecordB, "ubflag3", 0x02);

    pub const flag4_uballsp_fmb = util.bitFlag(RecordB, "ubflag4", 0x80);
    pub const flag4_ubusesp_fmb = util.bitFlag(RecordB, "ubflag4", 0x40);
    pub const flag4_ubrecsp_fmb = util.bitFlag(RecordB, "ubflag4", 0x20);
    pub const flag4_ubdsize_fmb = util.bitFlag(RecordB, "ubflag4", 0x10);
    pub const flag4_ub_fmb = util.bitFlag(RecordB, "ubflag4", 0x08);

    /// Sizes are stored in KB; HSM reports some in MB when the matching UBFLAG4 bit is on.
    fn kb(value: i32, in_mb: bool) i64 {
        return if (in_mb) @as(i64, value) * 1024 else value;
    }

    pub inline fn bind(self: *RecordB, b: *common.Binder) !void {
        try b.text(util.ascii(&self.ubdsnam));
        try b.boolean(self.flag1_ubincat());
        try b.boolean(self.flag1_ubnoenq());
        try b.boolean(self.flag1_ubbwo());
        try b.boolean(self.flag1_ubnqn1());
        try b.boolean(self.flag1_ubnqn2());
        try b.text(util.ascii(&self.ubdevcl)); // 'D' = DASD, 'T' = tape
        try b.boolean(self.dsorg_ubdsgis());
        try b.boolean(self.dsorg_ubdsgps());
        try b.boolean(self.dsorg_ubdsgda());
        try b.boolean(self.dsorg_ubdsgpo());
        try b.boolean(self.dsorg_ubdsgu());
        try b.boolean(self.dsorg_ubdsggs());
        try b.boolean(self.dsorg_ubdsgvs());
        try b.int64(kb(self.ubdsize, self.flag4_ubdsize_fmb()));
        var date_buf: [10]u8 = undefined;
        try util.dcdate(&date_buf, &self.ubdate);
        try b.text(&date_buf);
        var time_buf: [11]u8 = undefined;
        try b.text(try util.pdtime(&time_buf, &self.ubtime));
        // Lengths come from the input file; clamp so a corrupt record can't slice out of bounds.
        try b.text(util.ascii(self.ubdatcl[0..@min(self.ubdclng, self.ubdatcl.len)]));
        try b.text(util.ascii(self.ubstgcl[0..@min(self.ubsclng, self.ubstgcl.len)]));
        try b.text(util.ascii(self.ubmgtcl[0..@min(self.ubmclng, self.ubmgtcl.len)]));

        const recfm: []const u8 = if (self.recrd_ubrecff() and self.recrd_ubrecfv())
            "U"
        else if (self.recrd_ubrecff())
            "F"
        else if (self.recrd_ubrecfv())
            "V"
        else
            "";
        try b.text(recfm);
        try b.boolean(self.recrd_ubrecft());
        try b.boolean(self.recrd_ubrecfb());
        try b.boolean(self.recrd_ubrecfs());
        try b.boolean(self.recrd_ubrecfa());
        try b.boolean(self.recrd_ubrecfc());
        try b.boolean(self.recor_ubesds());
        try b.boolean(self.recor_ubksds());
        try b.boolean(self.recor_ublds());
        try b.boolean(self.recor_ubrrds());
        try b.int(self.ubbklng);
        try b.boolean(self.flag2_ubracfd());
        try b.boolean(self.flag2_ubgds());
        try b.boolean(self.flag2_ubreblk());
        try b.boolean(self.flag2_ubpdse());
        try b.boolean(self.flag2_ubsmsm());
        try b.boolean(self.flag2_ubcompr());
        try b.boolean(self.flag2_ublfs());
        try b.boolean(self.flag2_ubnewname());
        try b.boolean(self.flag3_ubnosphere());
        try b.boolean(self.flag3_ubgvcn());
        try b.boolean(self.flag3_ubf_retain_spcd());
        try b.boolean(self.flag3_ubf_never_exp());
        try b.boolean(self.flag3_ubencrp());
        try b.boolean(self.flag3_ubzfs());
        try b.boolean(self.flag3_ubencrdp());
        try b.int(self.ub_retaindays);
        try b.int64(kb(self.uballsp, self.flag4_uballsp_fmb()));
        try b.int64(kb(self.ubusesp, self.flag4_ubusesp_fmb()));
        try b.int64(kb(self.ubrecsp, self.flag4_ubrecsp_fmb()));
        try b.int64(kb(self.ub_user_datasize, self.flag4_ub_fmb()));
        try b.int64(kb(self.ub_comp_datasize, self.flag4_ub_fmb()));
        try b.text(util.ascii(&self.ubfrvol));
        try b.int(self.ubencrpt);
        // X'FFFF' type / all-X'FF' label = not encrypted.
        const encrypted = self.ubencrpt != 0xFFFF and self.ubencrpl[0] != 0xFF;
        try b.text(if (encrypted) util.ascii(&self.ubencrpl) else "");
    }
};

pub const Record = RecordB;
pub const record_key = "B ";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordB size: {d}\n", .{@sizeOf(RecordB)});
    try std.testing.expect(@sizeOf(RecordB) == 324);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(68, @offsetOf(RecordB, "ubflag1"));
    try std.testing.expectEqual(72, @offsetOf(RecordB, "ubdsize"));
    try std.testing.expectEqual(76, @offsetOf(RecordB, "ubtime"));
    try std.testing.expectEqual(84, @offsetOf(RecordB, "ubdclng"));
    try std.testing.expectEqual(148, @offsetOf(RecordB, "ubmclng"));
    try std.testing.expectEqual(180, @offsetOf(RecordB, "ubrecrd"));
    try std.testing.expectEqual(184, @offsetOf(RecordB, "ubflag2"));
    try std.testing.expectEqual(185, @offsetOf(RecordB, "ubflag3"));
    try std.testing.expectEqual(186, @offsetOf(RecordB, "ub_retaindays"));
    try std.testing.expectEqual(188, @offsetOf(RecordB, "uballsp"));
    try std.testing.expectEqual(200, @offsetOf(RecordB, "ub_user_datasize"));
    try std.testing.expectEqual(208, @offsetOf(RecordB, "ubfrvol"));
    try std.testing.expectEqual(214, @offsetOf(RecordB, "ubflag4"));
    try std.testing.expectEqual(228, @offsetOf(RecordB, "ubencrpt"));
    try std.testing.expectEqual(230, @offsetOf(RecordB, "ubencrpl"));
    try std.testing.expectEqual(294, @offsetOf(RecordB, "ubencrpr"));
}

test "synthetic B record is decoded into record_b" {
    const put = common.TestHarness.putEbcdic;
    var t: common.TestHarness = undefined;
    try t.init();
    defer t.deinit();

    // Build a big-endian, EBCDIC record the way DFSMShsm would write it.
    var rec: [324]u8 = @splat(0);
    std.mem.writeInt(u16, rec[0..2], rec.len, .big);
    put(rec[4..6], "B ");
    @memset(rec[24..68], 0x40); // EBCDIC blanks
    put(rec[24..68], "USER1.BACKUP.DATA");
    rec[68] = 0x80 | 0x20; // UBINCAT, UBBWO
    put(rec[69..70], "D");
    rec[70] = 0x02; // DSORG = PO
    std.mem.writeInt(i32, rec[72..76], 2048, .big); // UBDSIZE (KB)
    @memcpy(rec[76..80], &[_]u8{ 0x23, 0x59, 0x01, 0x50 }); // 23:59:01.50
    @memcpy(rec[80..84], &[_]u8{ 0x20, 0x25, 0x36, 0x5F }); // 2025 day 365 = 2025-12-31
    std.mem.writeInt(u16, rec[148..150], 7, .big);
    put(rec[150..157], "STANDEF");
    rec[180] = 0x40 | 0x10; // RECFM = VB
    rec[184] = 0x10 | 0x08; // UBPDSE, UBSMSM
    rec[185] = 0x20; // UBF_RETAIN_SPCD
    std.mem.writeInt(u16, rec[186..188], 400, .big); // UB_RETAINDAYS
    std.mem.writeInt(i32, rec[188..192], 5, .big); // UBALLSP in MB (see UBFLAG4)
    put(rec[208..214], "PRD001");
    rec[214] = 0x80; // UBALLSP_FMB
    std.mem.writeInt(u16, rec[228..230], 0x0100, .big); // AES-256 XTS
    @memset(rec[230..294], 0x40);
    put(rec[230..294], "SYS.KEY.LABEL1");

    try common.processRecord(&t.ctx, &rec);
    try std.testing.expectEqual(1, t.ctx.count.get("B ").?);

    const expect = struct {
        fn col(h: *common.TestHarness, comptime name: []const u8, want: []const u8) !void {
            try std.testing.expectEqualStrings(want, try h.queryText("SELECT " ++ name ++ " FROM record_b"));
        }
    }.col;
    try expect(&t, "ubdsnam", "USER1.BACKUP.DATA");
    try expect(&t, "ubincat", "1");
    try expect(&t, "ubnoenq", "0");
    try expect(&t, "ubbwo", "1");
    try expect(&t, "ubdevcl", "D");
    try expect(&t, "ubdsgpo", "1");
    try expect(&t, "ubdsize", "2048");
    try expect(&t, "ubdate", "2025-12-31");
    try expect(&t, "ubtime", "23:59:01.50");
    try expect(&t, "ubmgtcl", "STANDEF");
    try expect(&t, "ubstgcl", "");
    try expect(&t, "ubrecfm", "V");
    try expect(&t, "ubrecfb", "1");
    try expect(&t, "ubpdse", "1");
    try expect(&t, "ubsmsm", "1");
    try expect(&t, "ubf_retain_spcd", "1");
    try expect(&t, "ub_retaindays", "400");
    try expect(&t, "uballsp", "5120"); // 5 MB -> KB
    try expect(&t, "ubfrvol", "PRD001");
    try expect(&t, "ubencrpt", "256");
    try expect(&t, "ubencrpl", "SYS.KEY.LABEL1");
}
