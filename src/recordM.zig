const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Migrated Data Set Information (record type 'M', written by DFSMShsm with MIGRATEDATA).
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 15.
/// Not validated against real data: the sample file has no M records.
pub const RecordM = extern struct {
    header: Header,
    umdsnam: [44]u8,
    umflag1: [1]u8,
    umdevcl: [1]u8,
    umdsorg1: [1]u8, // DS1DSORG byte 1
    umdsorg2: [1]u8, // DS1DSORG byte 2
    umdsize: i32,
    umtime: [4]u8, // packed hhmmssth
    umdate: [4]u8, // packed yyyydddF
    umdclng: u16,
    umdatcl: [30]u8,
    umsclng: u16,
    umstgcl: [30]u8,
    ummclng: u16,
    ummgtcl: [30]u8,
    umrecrd: [1]u8,
    umrecor: [1]u8,
    umbklng: u16,
    umflag2: [1]u8,
    umpdsev: u8,
    umnmig: i16,
    umallsp: i32,
    umusesp: i32,
    umrecsp: i32,
    umcredt: [4]u8,
    umexpdt: [4]u8,
    umlbkdt: [8]u8, // STCK
    umlrfdt: [4]u8,
    um_user_datasize: i32,
    um_comp_datasize: i32,
    umfrvol: [6]u8,
    umlrecl: [4]u8, // binary fullword at an unaligned offset
    umflag3: [1]u8,
    umflag4: [1]u8,
    um_cloud_name_length: u16,
    um_cloud_name: [30]u8,
    um_container_name: [44]u8,
    um_obj_number: i32,
    um_cld_comp_percent: u8,
    _res1: [31]u8,
    umencrpt: u16,
    umencrpl: [64]u8,
    umencrpr: [30]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_m;
        \\ CREATE TABLE record_m (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     umdsnam TEXT NOT NULL DEFAULT '',
        \\     umlevel SMALLINT NOT NULL DEFAULT 0,
        \\     umchind BOOLEAN NOT NULL DEFAULT 0,
        \\     umsdsp BOOLEAN NOT NULL DEFAULT 0,
        \\     umdevcl TEXT NOT NULL DEFAULT '',
        \\     umdsgis BOOLEAN NOT NULL DEFAULT 0,
        \\     umdsgps BOOLEAN NOT NULL DEFAULT 0,
        \\     umdsgda BOOLEAN NOT NULL DEFAULT 0,
        \\     umdsgpo BOOLEAN NOT NULL DEFAULT 0,
        \\     umdsgu BOOLEAN NOT NULL DEFAULT 0,
        \\     umdsggs BOOLEAN NOT NULL DEFAULT 0,
        \\     umdsgvs BOOLEAN NOT NULL DEFAULT 0,
        \\     umdsize BIGINT NOT NULL DEFAULT 0,
        \\     umdate DATE NOT NULL DEFAULT '0000-00-00',
        \\     umtime TEXT NOT NULL DEFAULT '',
        \\     umdatcl TEXT NOT NULL DEFAULT '',
        \\     umstgcl TEXT NOT NULL DEFAULT '',
        \\     ummgtcl TEXT NOT NULL DEFAULT '',
        \\     umrecfm TEXT NOT NULL DEFAULT '',
        \\     umrecft BOOLEAN NOT NULL DEFAULT 0,
        \\     umrecfb BOOLEAN NOT NULL DEFAULT 0,
        \\     umrecfs BOOLEAN NOT NULL DEFAULT 0,
        \\     umrecfa BOOLEAN NOT NULL DEFAULT 0,
        \\     umrecfc BOOLEAN NOT NULL DEFAULT 0,
        \\     umesds BOOLEAN NOT NULL DEFAULT 0,
        \\     umksds BOOLEAN NOT NULL DEFAULT 0,
        \\     umlds BOOLEAN NOT NULL DEFAULT 0,
        \\     umrrds BOOLEAN NOT NULL DEFAULT 0,
        \\     umbklng INTEGER NOT NULL DEFAULT 0,
        \\     umracfd BOOLEAN NOT NULL DEFAULT 0,
        \\     umgds BOOLEAN NOT NULL DEFAULT 0,
        \\     umreblk BOOLEAN NOT NULL DEFAULT 0,
        \\     umpdse BOOLEAN NOT NULL DEFAULT 0,
        \\     umsmsm BOOLEAN NOT NULL DEFAULT 0,
        \\     umcompr BOOLEAN NOT NULL DEFAULT 0,
        \\     umlfs BOOLEAN NOT NULL DEFAULT 0,
        \\     umencrp BOOLEAN NOT NULL DEFAULT 0,
        \\     umpdsev SMALLINT NOT NULL DEFAULT 0,
        \\     umnmig SMALLINT NOT NULL DEFAULT 0,
        \\     umallsp BIGINT NOT NULL DEFAULT 0,
        \\     umusesp BIGINT NOT NULL DEFAULT 0,
        \\     umrecsp BIGINT NOT NULL DEFAULT 0,
        \\     umcredt DATE NOT NULL DEFAULT '0000-00-00',
        \\     umexpdt DATE NOT NULL DEFAULT '0000-00-00',
        \\     umlbkdt DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00.000',
        \\     umlrfdt DATE NOT NULL DEFAULT '0000-00-00',
        \\     um_user_datasize BIGINT NOT NULL DEFAULT 0,
        \\     um_comp_datasize BIGINT NOT NULL DEFAULT 0,
        \\     umfrvol TEXT NOT NULL DEFAULT '',
        \\     umlrecl INTEGER NOT NULL DEFAULT 0,
        \\     umempty BOOLEAN NOT NULL DEFAULT 0,
        \\     um_ca_reclaim_elig BOOLEAN NOT NULL DEFAULT 0,
        \\     umzfs BOOLEAN NOT NULL DEFAULT 0,
        \\     umencrdp BOOLEAN NOT NULL DEFAULT 0,
        \\     um_bson BOOLEAN NOT NULL DEFAULT 0,
        \\     um_json BOOLEAN NOT NULL DEFAULT 0,
        \\     um_cld_comp BOOLEAN NOT NULL DEFAULT 0,
        \\     um_cld_encrypt BOOLEAN NOT NULL DEFAULT 0,
        \\     um_cloud_name TEXT NOT NULL DEFAULT '',
        \\     um_container_name TEXT NOT NULL DEFAULT '',
        \\     um_obj_number INTEGER NOT NULL DEFAULT 0,
        \\     um_cld_comp_percent SMALLINT NOT NULL DEFAULT 0,
        \\     umencrpt INTEGER NOT NULL DEFAULT 0,
        \\     umencrpl TEXT NOT NULL DEFAULT ''
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_m (
        \\     umdsnam, umlevel, umchind, umsdsp, umdevcl,
        \\     umdsgis, umdsgps, umdsgda, umdsgpo, umdsgu, umdsggs, umdsgvs,
        \\     umdsize, umdate, umtime, umdatcl, umstgcl, ummgtcl,
        \\     umrecfm, umrecft, umrecfb, umrecfs, umrecfa, umrecfc,
        \\     umesds, umksds, umlds, umrrds, umbklng,
        \\     umracfd, umgds, umreblk, umpdse, umsmsm, umcompr, umlfs, umencrp,
        \\     umpdsev, umnmig, umallsp, umusesp, umrecsp,
        \\     umcredt, umexpdt, umlbkdt, umlrfdt,
        \\     um_user_datasize, um_comp_datasize, umfrvol, umlrecl,
        \\     umempty, um_ca_reclaim_elig, umzfs, umencrdp, um_bson, um_json, um_cld_comp, um_cld_encrypt,
        \\     um_cloud_name, um_container_name, um_obj_number, um_cld_comp_percent,
        \\     umencrpt, umencrpl
        \\ ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const flag1_umchind = util.bitFlag(RecordM, "umflag1", 0x20);
    pub const flag1_umsdsp = util.bitFlag(RecordM, "umflag1", 0x10);

    pub const dsorg_umdsgis = util.bitFlag(RecordM, "umdsorg1", 0x80);
    pub const dsorg_umdsgps = util.bitFlag(RecordM, "umdsorg1", 0x40);
    pub const dsorg_umdsgda = util.bitFlag(RecordM, "umdsorg1", 0x20);
    pub const dsorg_umdsgpo = util.bitFlag(RecordM, "umdsorg1", 0x02);
    pub const dsorg_umdsgu = util.bitFlag(RecordM, "umdsorg1", 0x01);
    pub const dsorg_umdsggs = util.bitFlag(RecordM, "umdsorg2", 0x80);
    pub const dsorg_umdsgvs = util.bitFlag(RecordM, "umdsorg2", 0x08);

    pub const recrd_umrecff = util.bitFlag(RecordM, "umrecrd", 0x80);
    pub const recrd_umrecfv = util.bitFlag(RecordM, "umrecrd", 0x40);
    pub const recrd_umrecft = util.bitFlag(RecordM, "umrecrd", 0x20);
    pub const recrd_umrecfb = util.bitFlag(RecordM, "umrecrd", 0x10);
    pub const recrd_umrecfs = util.bitFlag(RecordM, "umrecrd", 0x08);
    pub const recrd_umrecfa = util.bitFlag(RecordM, "umrecrd", 0x04);
    pub const recrd_umrecfc = util.bitFlag(RecordM, "umrecrd", 0x02);

    pub const recor_umesds = util.bitFlag(RecordM, "umrecor", 0x80);
    pub const recor_umksds = util.bitFlag(RecordM, "umrecor", 0x40);
    pub const recor_umlds = util.bitFlag(RecordM, "umrecor", 0x20);
    pub const recor_umrrds = util.bitFlag(RecordM, "umrecor", 0x10);

    pub const flag2_umracfd = util.bitFlag(RecordM, "umflag2", 0x80);
    pub const flag2_umgds = util.bitFlag(RecordM, "umflag2", 0x40);
    pub const flag2_umreblk = util.bitFlag(RecordM, "umflag2", 0x20);
    pub const flag2_umpdse = util.bitFlag(RecordM, "umflag2", 0x10);
    pub const flag2_umsmsm = util.bitFlag(RecordM, "umflag2", 0x08);
    pub const flag2_umcompr = util.bitFlag(RecordM, "umflag2", 0x04);
    pub const flag2_umlfs = util.bitFlag(RecordM, "umflag2", 0x02);
    pub const flag2_umencrp = util.bitFlag(RecordM, "umflag2", 0x01);

    pub const flag3_umempty = util.bitFlag(RecordM, "umflag3", 0x80);
    pub const flag3_um_ca_reclaim_elig = util.bitFlag(RecordM, "umflag3", 0x40);
    pub const flag3_umzfs = util.bitFlag(RecordM, "umflag3", 0x20);
    pub const flag3_umencrdp = util.bitFlag(RecordM, "umflag3", 0x10);
    pub const flag3_um_bson = util.bitFlag(RecordM, "umflag3", 0x08);
    pub const flag3_um_json = util.bitFlag(RecordM, "umflag3", 0x04);
    pub const flag3_um_cld_comp = util.bitFlag(RecordM, "umflag3", 0x02);
    pub const flag3_um_cld_encrypt = util.bitFlag(RecordM, "umflag3", 0x01);

    pub const flag4_umallsp_fmb = util.bitFlag(RecordM, "umflag4", 0x80);
    pub const flag4_umusesp_fmb = util.bitFlag(RecordM, "umflag4", 0x40);
    pub const flag4_umrecsp_fmb = util.bitFlag(RecordM, "umflag4", 0x20);
    pub const flag4_umdsize_fmb = util.bitFlag(RecordM, "umflag4", 0x10);
    pub const flag4_um_fmb = util.bitFlag(RecordM, "umflag4", 0x08);

    /// Sizes are stored in KB; HSM reports some in MB when the matching UMFLAG4 bit is on.
    fn kb(value: i32, in_mb: bool) i64 {
        return if (in_mb) @as(i64, value) * 1024 else value;
    }

    fn date(b: *common.Binder, field: *const [4]u8) !void {
        var buf: [10]u8 = undefined;
        try util.dcdate(&buf, field);
        try b.text(&buf);
    }

    pub inline fn bind(self: *RecordM, b: *common.Binder) !void {
        try b.text(util.ascii(&self.umdsnam));
        try b.int(self.umflag1[0] >> 6); // UMLEVEL: 0 = L0, 1 = ML1, 2 = ML2
        try b.boolean(self.flag1_umchind());
        try b.boolean(self.flag1_umsdsp());
        try b.text(util.ascii(&self.umdevcl)); // 'D' = DASD, 'T' = tape
        try b.boolean(self.dsorg_umdsgis());
        try b.boolean(self.dsorg_umdsgps());
        try b.boolean(self.dsorg_umdsgda());
        try b.boolean(self.dsorg_umdsgpo());
        try b.boolean(self.dsorg_umdsgu());
        try b.boolean(self.dsorg_umdsggs());
        try b.boolean(self.dsorg_umdsgvs());
        try b.int64(kb(self.umdsize, self.flag4_umdsize_fmb()));
        try date(b, &self.umdate);
        var time_buf: [11]u8 = undefined;
        try b.text(try util.pdtime(&time_buf, &self.umtime));
        // Lengths come from the input file; clamp so a corrupt record can't slice out of bounds.
        try b.text(util.ascii(self.umdatcl[0..@min(self.umdclng, self.umdatcl.len)]));
        try b.text(util.ascii(self.umstgcl[0..@min(self.umsclng, self.umstgcl.len)]));
        try b.text(util.ascii(self.ummgtcl[0..@min(self.ummclng, self.ummgtcl.len)]));

        const recfm: []const u8 = if (self.recrd_umrecff() and self.recrd_umrecfv())
            "U"
        else if (self.recrd_umrecff())
            "F"
        else if (self.recrd_umrecfv())
            "V"
        else
            "";
        try b.text(recfm);
        try b.boolean(self.recrd_umrecft());
        try b.boolean(self.recrd_umrecfb());
        try b.boolean(self.recrd_umrecfs());
        try b.boolean(self.recrd_umrecfa());
        try b.boolean(self.recrd_umrecfc());
        try b.boolean(self.recor_umesds());
        try b.boolean(self.recor_umksds());
        try b.boolean(self.recor_umlds());
        try b.boolean(self.recor_umrrds());
        try b.int(self.umbklng);
        try b.boolean(self.flag2_umracfd());
        try b.boolean(self.flag2_umgds());
        try b.boolean(self.flag2_umreblk());
        try b.boolean(self.flag2_umpdse());
        try b.boolean(self.flag2_umsmsm());
        try b.boolean(self.flag2_umcompr());
        try b.boolean(self.flag2_umlfs());
        try b.boolean(self.flag2_umencrp());
        try b.int(self.umpdsev);
        try b.int(self.umnmig);
        try b.int64(kb(self.umallsp, self.flag4_umallsp_fmb()));
        try b.int64(kb(self.umusesp, self.flag4_umusesp_fmb()));
        try b.int64(kb(self.umrecsp, self.flag4_umrecsp_fmb()));
        try date(b, &self.umcredt);
        try date(b, &self.umexpdt);
        var ts_buf: [23]u8 = undefined;
        try b.text(try util.stckTimestamp(&ts_buf, &self.umlbkdt));
        try date(b, &self.umlrfdt);
        try b.int64(kb(self.um_user_datasize, self.flag4_um_fmb()));
        try b.int64(kb(self.um_comp_datasize, self.flag4_um_fmb()));
        try b.text(util.ascii(&self.umfrvol));
        try b.int64(std.mem.readInt(u32, &self.umlrecl, .big));
        try b.boolean(self.flag3_umempty());
        try b.boolean(self.flag3_um_ca_reclaim_elig());
        try b.boolean(self.flag3_umzfs());
        try b.boolean(self.flag3_umencrdp());
        try b.boolean(self.flag3_um_bson());
        try b.boolean(self.flag3_um_json());
        try b.boolean(self.flag3_um_cld_comp());
        try b.boolean(self.flag3_um_cld_encrypt());
        try b.text(util.ascii(self.um_cloud_name[0..@min(self.um_cloud_name_length, self.um_cloud_name.len)]));
        try b.text(util.ascii(&self.um_container_name));
        try b.int(self.um_obj_number);
        try b.int(self.um_cld_comp_percent);
        try b.int(self.umencrpt);
        // X'FFFF' type / all-X'FF' label = not encrypted.
        const encrypted = self.umencrpt != 0xFFFF and self.umencrpl[0] != 0xFF;
        try b.text(if (encrypted) util.ascii(&self.umencrpl) else "");
    }
};

pub const Record = RecordM;
pub const record_key = "M ";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordM size: {d}\n", .{@sizeOf(RecordM)});
    try std.testing.expect(@sizeOf(RecordM) == 448);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(68, @offsetOf(RecordM, "umflag1"));
    try std.testing.expectEqual(72, @offsetOf(RecordM, "umdsize"));
    try std.testing.expectEqual(76, @offsetOf(RecordM, "umtime"));
    try std.testing.expectEqual(84, @offsetOf(RecordM, "umdclng"));
    try std.testing.expectEqual(148, @offsetOf(RecordM, "ummclng"));
    try std.testing.expectEqual(180, @offsetOf(RecordM, "umrecrd"));
    try std.testing.expectEqual(184, @offsetOf(RecordM, "umflag2"));
    try std.testing.expectEqual(188, @offsetOf(RecordM, "umallsp"));
    try std.testing.expectEqual(208, @offsetOf(RecordM, "umlbkdt"));
    try std.testing.expectEqual(220, @offsetOf(RecordM, "um_user_datasize"));
    try std.testing.expectEqual(228, @offsetOf(RecordM, "umfrvol"));
    try std.testing.expectEqual(234, @offsetOf(RecordM, "umlrecl"));
    try std.testing.expectEqual(238, @offsetOf(RecordM, "umflag3"));
    try std.testing.expectEqual(240, @offsetOf(RecordM, "um_cloud_name_length"));
    try std.testing.expectEqual(272, @offsetOf(RecordM, "um_container_name"));
    try std.testing.expectEqual(316, @offsetOf(RecordM, "um_obj_number"));
    try std.testing.expectEqual(352, @offsetOf(RecordM, "umencrpt"));
    try std.testing.expectEqual(354, @offsetOf(RecordM, "umencrpl"));
    try std.testing.expectEqual(418, @offsetOf(RecordM, "umencrpr"));
}

test "synthetic M record is decoded into record_m" {
    var t: common.TestHarness = undefined;
    try t.init();
    defer t.deinit();

    // Build a big-endian, EBCDIC record the way DFSMShsm would write it.
    var rec: [448]u8 = @splat(0);
    std.mem.writeInt(u16, rec[0..2], rec.len, .big);
    common.TestHarness.putEbcdic(rec[4..6], "M ");
    @memset(rec[24..68], 0x40); // EBCDIC blanks
    common.TestHarness.putEbcdic(rec[24..68], "USER1.MIGRATED.DATA");
    rec[68] = 0x80 | 0x20; // UMLEVEL = 2 (ML2), UMCHIND
    common.TestHarness.putEbcdic(rec[69..70], "T");
    rec[70] = 0x40; // DSORG = PS
    std.mem.writeInt(i32, rec[72..76], 300, .big); // UMDSIZE (MB, see UMFLAG4)
    @memcpy(rec[76..80], &[_]u8{ 0x13, 0x45, 0x25, 0x07 }); // 13:45:25.07
    @memcpy(rec[80..84], &[_]u8{ 0x20, 0x24, 0x06, 0x0F }); // 2024 day 060 = 2024-02-29
    std.mem.writeInt(u16, rec[116..118], 6, .big);
    common.TestHarness.putEbcdic(rec[118..124], "SCBASE");
    rec[180] = 0x80 | 0x10; // RECFM = FB
    std.mem.writeInt(u16, rec[182..184], 27920, .big); // UMBKLNG
    rec[184] = 0x08; // UMSMSM
    std.mem.writeInt(i16, rec[186..188], 3, .big); // UMNMIG
    std.mem.writeInt(i32, rec[188..192], 1500, .big); // UMALLSP (KB)
    @memcpy(rec[208..216], &[_]u8{ 0xDE, 0xB9, 0x4C, 0x56, 0x70, 0x60, 0x80, 0x00 }); // STCK 2024-02-29 12:34:56.789
    common.TestHarness.putEbcdic(rec[228..234], "WORK01");
    std.mem.writeInt(u32, rec[234..238], 80, .big); // UMLRECL
    rec[239] = 0x10; // UMDSIZE_FMB: UMDSIZE is in MB
    std.mem.writeInt(u16, rec[352..354], 0xFFFF, .big); // not encrypted
    @memset(rec[354..418], 0xFF);

    try common.processRecord(&t.ctx, &rec);
    try std.testing.expectEqual(1, t.ctx.count.get("M ").?);

    const expect = struct {
        fn col(h: *common.TestHarness, comptime name: []const u8, want: []const u8) !void {
            try std.testing.expectEqualStrings(want, try h.queryText("SELECT " ++ name ++ " FROM record_m"));
        }
    }.col;
    try expect(&t, "umdsnam", "USER1.MIGRATED.DATA");
    try expect(&t, "umlevel", "2");
    try expect(&t, "umchind", "1");
    try expect(&t, "umdevcl", "T");
    try expect(&t, "umdsgps", "1");
    try expect(&t, "umdsize", "307200"); // 300 MB -> KB
    try expect(&t, "umdate", "2024-02-29");
    try expect(&t, "umtime", "13:45:25.07");
    try expect(&t, "umstgcl", "SCBASE");
    try expect(&t, "umrecfm", "F");
    try expect(&t, "umrecfb", "1");
    try expect(&t, "umbklng", "27920");
    try expect(&t, "umsmsm", "1");
    try expect(&t, "umnmig", "3");
    try expect(&t, "umallsp", "1500");
    try expect(&t, "umcredt", "0000-00-00");
    try expect(&t, "umlbkdt", "2024-02-29 12:34:56.789");
    try expect(&t, "umfrvol", "WORK01");
    try expect(&t, "umlrecl", "80");
    try expect(&t, "umencrpt", "65535");
    try expect(&t, "umencrpl", "");
}
