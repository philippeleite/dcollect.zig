const std = @import("std");
const util = @import("util.zig");
const common = @import("common.zig");
const Header = common.Header;

/// Management Class Construct Information (record type 'MC').
/// z/OS 3.1 DFSMS Access Method Services Commands, Appendix F, Table 18.
/// The manual documents fields up to offset 362; real records can be longer
/// (760 bytes on z/OS 3.1), and the trailing bytes are ignored.
pub const RecordMC = extern struct {
    header: Header,
    dmcnmlen: u16,
    dmcname: [30]u8,
    dmcuser: [8]u8,
    dmcdate: [10]u8,
    _res1: [2]u8,
    dmctime: [8]u8,
    dmcdesc: [120]u8,
    dmcspec1: [1]u8,
    dmcspec2: [1]u8,
    dmcrlf: [1]u8,
    _res2: [1]u8,
    dmcgdgfl: [1]u8,
    _res3: [1]u8,
    dmcpelem: i16,
    _res4: [4]u8,
    dmcretf: [1]u8,
    dmcrfmt: u8,
    _res5: [2]u8,
    // align(1) on 4-byte fields keeps the struct at 362 bytes instead of padding to 364.
    dmcexpdy: i32 align(1),
    dmcexdat: i32 align(1), // overlaid by DMCEYEAR (u16) + DMCEDAY (u16) when DMCRFMT = 1 (date)
    dmcmigf: [1]u8,
    _res6: [1]u8,
    dmcprdy: i16,
    dmcl1dy: i16,
    dmccmau: u8,
    _res7: [1]u8,
    dmcbkflg: [1]u8,
    _res8: [3]u8,
    dmcbkfq: i16,
    dmcbkvs: i16,
    dmcbvrd: i16,
    dmcbkdy: i16,
    dmcbknp: i16,
    dmcbadu: u8,
    dmccpytc: u8,
    dmcbkudc: [8]u8,
    dmcmretf: [1]u8,
    dmcmrtdy: [3]u8,
    dmctscr: [1]u8,
    dmctslu: [1]u8,
    dmcperd: [1]u8,
    _res9: [1]u8,
    dmcvscy: i16,
    dmcvscm: i16,
    dmcvscd: i16,
    dmcvsuy: i16,
    dmcvsum: i16,
    dmcvsud: i16,
    dmcvprd: i16,
    dmcvpmd: i16,
    dmcvpqd: i16,
    dmcvpqm: i16,
    dmcvpyd: i16,
    dmcvpym: i16,
    _res10: [16]u8,
    dmcctsrl: i16,
    dmcctcpy: i16,
    dmcl2dy: i16, // printed as "MCDL2DY" in the manual
    dmcclen: u16,
    dmcclnam: [30]u8,
    _res11: [2]u8,
    dmcszlte: u32 align(1), // printed as "DCMSZLTE" in the manual
    dmcszgt: u32 align(1), // printed as "DCMSZGT" in the manual
    dmcaclte: i8,
    dmcacgt: i8,
    _res12: [4]u8,

    pub const tableSQL =
        \\ DROP TABLE IF EXISTS record_mc;
        \\ CREATE TABLE record_mc (
        \\     id INTEGER PRIMARY KEY AUTOINCREMENT,
        \\     dmcname TEXT NOT NULL DEFAULT '',
        \\     dmcuser TEXT NOT NULL DEFAULT '',
        \\     dmcdate TEXT NOT NULL DEFAULT '',
        \\     dmctime TEXT NOT NULL DEFAULT '',
        \\     dmcdesc TEXT NOT NULL DEFAULT '',
        \\     dmcfbver BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfbvrd BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfrbk BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfrnp BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfexdt BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfexdy BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfprdy BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfl1dy BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfrlmg BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfpele BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfbkfq BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcprel BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcprcn BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcprim BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcrlomg BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcpelem SMALLINT NOT NULL DEFAULT 0,
        \\     dmcdynol BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcdtnol BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcrfmt SMALLINT NOT NULL DEFAULT 0,
        \\     dmcexpdy INTEGER NOT NULL DEFAULT 0,
        \\     dmcexdat INTEGER NOT NULL DEFAULT 0,
        \\     dmceyear INTEGER NOT NULL DEFAULT 0,
        \\     dmceday INTEGER NOT NULL DEFAULT 0,
        \\     dmcl1nol BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcprdy SMALLINT NOT NULL DEFAULT 0,
        \\     dmcl1dy SMALLINT NOT NULL DEFAULT 0,
        \\     dmccmau SMALLINT NOT NULL DEFAULT 0,
        \\     dmcrbnol BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcnpnol BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcautbk BOOLEAN NOT NULL DEFAULT 0,
        \\     dmccpytf BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcbkfq SMALLINT NOT NULL DEFAULT 0,
        \\     dmcbkvs SMALLINT NOT NULL DEFAULT 0,
        \\     dmcbvrd SMALLINT NOT NULL DEFAULT 0,
        \\     dmcbkdy SMALLINT NOT NULL DEFAULT 0,
        \\     dmcbknp SMALLINT NOT NULL DEFAULT 0,
        \\     dmcbadu SMALLINT NOT NULL DEFAULT 0,
        \\     dmccpytc SMALLINT NOT NULL DEFAULT 0,
        \\     dmcbkudc TEXT NOT NULL DEFAULT '',
        \\     dmcrpnol BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcmrtdy INTEGER NOT NULL DEFAULT 0,
        \\     dmctcyr BOOLEAN NOT NULL DEFAULT 0,
        \\     dmctcmn BOOLEAN NOT NULL DEFAULT 0,
        \\     dmctcdy BOOLEAN NOT NULL DEFAULT 0,
        \\     dmctsyr BOOLEAN NOT NULL DEFAULT 0,
        \\     dmctsmn BOOLEAN NOT NULL DEFAULT 0,
        \\     dmctsdy BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcpemn BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcpeqd BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcpeqm BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcpeyd BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcpeym BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcfirst BOOLEAN NOT NULL DEFAULT 0,
        \\     dmclast BOOLEAN NOT NULL DEFAULT 0,
        \\     dmcvscy SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvscm SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvscd SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvsuy SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvsum SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvsud SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvprd SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvpmd SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvpqd SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvpqm SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvpyd SMALLINT NOT NULL DEFAULT 0,
        \\     dmcvpym SMALLINT NOT NULL DEFAULT 0,
        \\     dmcctsrl SMALLINT NOT NULL DEFAULT 0,
        \\     dmcctcpy SMALLINT NOT NULL DEFAULT 0,
        \\     dmcl2dy SMALLINT NOT NULL DEFAULT 0,
        \\     dmcclnam TEXT NOT NULL DEFAULT '',
        \\     dmcszlte BIGINT NOT NULL DEFAULT 0,
        \\     dmcszgt BIGINT NOT NULL DEFAULT 0,
        \\     dmcaclte SMALLINT NOT NULL DEFAULT 0,
        \\     dmcacgt SMALLINT NOT NULL DEFAULT 0
        \\ );
        \\
    ;

    pub const insertSQL =
        \\ INSERT INTO record_mc (
        \\     dmcname,
        \\     dmcuser,
        \\     dmcdate,
        \\     dmctime,
        \\     dmcdesc,
        \\     dmcfbver,
        \\     dmcfbvrd,
        \\     dmcfrbk,
        \\     dmcfrnp,
        \\     dmcfexdt,
        \\     dmcfexdy,
        \\     dmcfprdy,
        \\     dmcfl1dy,
        \\     dmcfrlmg,
        \\     dmcfpele,
        \\     dmcfbkfq,
        \\     dmcprel,
        \\     dmcprcn,
        \\     dmcprim,
        \\     dmcrlomg,
        \\     dmcpelem,
        \\     dmcdynol,
        \\     dmcdtnol,
        \\     dmcrfmt,
        \\     dmcexpdy,
        \\     dmcexdat,
        \\     dmceyear,
        \\     dmceday,
        \\     dmcl1nol,
        \\     dmcprdy,
        \\     dmcl1dy,
        \\     dmccmau,
        \\     dmcrbnol,
        \\     dmcnpnol,
        \\     dmcautbk,
        \\     dmccpytf,
        \\     dmcbkfq,
        \\     dmcbkvs,
        \\     dmcbvrd,
        \\     dmcbkdy,
        \\     dmcbknp,
        \\     dmcbadu,
        \\     dmccpytc,
        \\     dmcbkudc,
        \\     dmcrpnol,
        \\     dmcmrtdy,
        \\     dmctcyr,
        \\     dmctcmn,
        \\     dmctcdy,
        \\     dmctsyr,
        \\     dmctsmn,
        \\     dmctsdy,
        \\     dmcpemn,
        \\     dmcpeqd,
        \\     dmcpeqm,
        \\     dmcpeyd,
        \\     dmcpeym,
        \\     dmcfirst,
        \\     dmclast,
        \\     dmcvscy,
        \\     dmcvscm,
        \\     dmcvscd,
        \\     dmcvsuy,
        \\     dmcvsum,
        \\     dmcvsud,
        \\     dmcvprd,
        \\     dmcvpmd,
        \\     dmcvpqd,
        \\     dmcvpqm,
        \\     dmcvpyd,
        \\     dmcvpym,
        \\     dmcctsrl,
        \\     dmcctcpy,
        \\     dmcl2dy,
        \\     dmcclnam,
        \\     dmcszlte,
        \\     dmcszgt,
        \\     dmcaclte,
        \\     dmcacgt) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);
        \\
    ;

    pub const spec1_dmcfbver = util.bitFlag(RecordMC, "dmcspec1", 0x80);
    pub const spec1_dmcfbvrd = util.bitFlag(RecordMC, "dmcspec1", 0x40);
    pub const spec1_dmcfrbk = util.bitFlag(RecordMC, "dmcspec1", 0x20);
    pub const spec1_dmcfrnp = util.bitFlag(RecordMC, "dmcspec1", 0x10);
    pub const spec1_dmcfexdt = util.bitFlag(RecordMC, "dmcspec1", 0x08);
    pub const spec1_dmcfexdy = util.bitFlag(RecordMC, "dmcspec1", 0x04);
    pub const spec1_dmcfprdy = util.bitFlag(RecordMC, "dmcspec1", 0x02);

    pub const spec2_dmcfl1dy = util.bitFlag(RecordMC, "dmcspec2", 0x80);
    pub const spec2_dmcfrlmg = util.bitFlag(RecordMC, "dmcspec2", 0x40);
    pub const spec2_dmcfpele = util.bitFlag(RecordMC, "dmcspec2", 0x20);
    pub const spec2_dmcfbkfq = util.bitFlag(RecordMC, "dmcspec2", 0x10);

    pub const rlf_dmcprel = util.bitFlag(RecordMC, "dmcrlf", 0x80);
    pub const rlf_dmcprcn = util.bitFlag(RecordMC, "dmcrlf", 0x40);
    pub const rlf_dmcprim = util.bitFlag(RecordMC, "dmcrlf", 0x20);

    pub const gdgfl_dmcrlomg = util.bitFlag(RecordMC, "dmcgdgfl", 0x80);

    pub const retf_dmcdynol = util.bitFlag(RecordMC, "dmcretf", 0x80);
    pub const retf_dmcdtnol = util.bitFlag(RecordMC, "dmcretf", 0x40);

    pub const migf_dmcl1nol = util.bitFlag(RecordMC, "dmcmigf", 0x20);

    pub const bkflg_dmcrbnol = util.bitFlag(RecordMC, "dmcbkflg", 0x80);
    pub const bkflg_dmcnpnol = util.bitFlag(RecordMC, "dmcbkflg", 0x40);
    pub const bkflg_dmcautbk = util.bitFlag(RecordMC, "dmcbkflg", 0x10);
    pub const bkflg_dmccpytf = util.bitFlag(RecordMC, "dmcbkflg", 0x08);

    pub const mretf_dmcrpnol = util.bitFlag(RecordMC, "dmcmretf", 0x80);

    pub const tscr_dmctcyr = util.bitFlag(RecordMC, "dmctscr", 0x80);
    pub const tscr_dmctcmn = util.bitFlag(RecordMC, "dmctscr", 0x40);
    pub const tscr_dmctcdy = util.bitFlag(RecordMC, "dmctscr", 0x20);

    pub const tslu_dmctsyr = util.bitFlag(RecordMC, "dmctslu", 0x80);
    pub const tslu_dmctsmn = util.bitFlag(RecordMC, "dmctslu", 0x40);
    pub const tslu_dmctsdy = util.bitFlag(RecordMC, "dmctslu", 0x20);

    pub const perd_dmcpemn = util.bitFlag(RecordMC, "dmcperd", 0x80);
    pub const perd_dmcpeqd = util.bitFlag(RecordMC, "dmcperd", 0x40);
    pub const perd_dmcpeqm = util.bitFlag(RecordMC, "dmcperd", 0x20);
    pub const perd_dmcpeyd = util.bitFlag(RecordMC, "dmcperd", 0x10);
    pub const perd_dmcpeym = util.bitFlag(RecordMC, "dmcperd", 0x08);
    pub const perd_dmcfirst = util.bitFlag(RecordMC, "dmcperd", 0x04);
    pub const perd_dmclast = util.bitFlag(RecordMC, "dmcperd", 0x02);

    pub inline fn bind(self: *RecordMC, b: *common.Binder) !void {
        // Lengths come from the input file; clamp so a corrupt record can't slice out of bounds.
        const name = self.dmcname[0..@min(self.dmcnmlen, self.dmcname.len)];
        util.bcd2asc(name);
        try b.text(name);
        util.bcd2asc(&self.dmcuser);
        try b.text(&self.dmcuser);
        util.bcd2asc(&self.dmcdate);
        try b.text(&self.dmcdate);
        util.bcd2asc(&self.dmctime);
        try b.text(&self.dmctime);
        util.bcd2asc(&self.dmcdesc);
        try b.text(&self.dmcdesc);
        try b.boolean(self.spec1_dmcfbver());
        try b.boolean(self.spec1_dmcfbvrd());
        try b.boolean(self.spec1_dmcfrbk());
        try b.boolean(self.spec1_dmcfrnp());
        try b.boolean(self.spec1_dmcfexdt());
        try b.boolean(self.spec1_dmcfexdy());
        try b.boolean(self.spec1_dmcfprdy());
        try b.boolean(self.spec2_dmcfl1dy());
        try b.boolean(self.spec2_dmcfrlmg());
        try b.boolean(self.spec2_dmcfpele());
        try b.boolean(self.spec2_dmcfbkfq());
        try b.boolean(self.rlf_dmcprel());
        try b.boolean(self.rlf_dmcprcn());
        try b.boolean(self.rlf_dmcprim());
        try b.boolean(self.gdgfl_dmcrlomg());
        try b.int(self.dmcpelem);
        try b.boolean(self.retf_dmcdynol());
        try b.boolean(self.retf_dmcdtnol());
        try b.int(self.dmcrfmt);
        try b.int(self.dmcexpdy);
        try b.int(self.dmcexdat);
        const exdat: u32 = @bitCast(self.dmcexdat);
        try b.int(@intCast(exdat >> 16)); // DMCEYEAR
        try b.int(@intCast(exdat & 0xFFFF)); // DMCEDAY
        try b.boolean(self.migf_dmcl1nol());
        try b.int(self.dmcprdy);
        try b.int(self.dmcl1dy);
        try b.int(self.dmccmau);
        try b.boolean(self.bkflg_dmcrbnol());
        try b.boolean(self.bkflg_dmcnpnol());
        try b.boolean(self.bkflg_dmcautbk());
        try b.boolean(self.bkflg_dmccpytf());
        try b.int(self.dmcbkfq);
        try b.int(self.dmcbkvs);
        try b.int(self.dmcbvrd);
        try b.int(self.dmcbkdy);
        try b.int(self.dmcbknp);
        try b.int(self.dmcbadu);
        try b.int(self.dmccpytc);
        // Unset destination class is X'00'-filled, not blanks; don't store NULs in TEXT.
        const bkudc = std.mem.trimEnd(u8, &self.dmcbkudc, "\x00");
        util.bcd2asc(@constCast(bkudc));
        try b.text(bkudc);
        try b.boolean(self.mretf_dmcrpnol());
        try b.int64(util.b3toInt(self.dmcmrtdy));
        try b.boolean(self.tscr_dmctcyr());
        try b.boolean(self.tscr_dmctcmn());
        try b.boolean(self.tscr_dmctcdy());
        try b.boolean(self.tslu_dmctsyr());
        try b.boolean(self.tslu_dmctsmn());
        try b.boolean(self.tslu_dmctsdy());
        try b.boolean(self.perd_dmcpemn());
        try b.boolean(self.perd_dmcpeqd());
        try b.boolean(self.perd_dmcpeqm());
        try b.boolean(self.perd_dmcpeyd());
        try b.boolean(self.perd_dmcpeym());
        try b.boolean(self.perd_dmcfirst());
        try b.boolean(self.perd_dmclast());
        try b.int(self.dmcvscy);
        try b.int(self.dmcvscm);
        try b.int(self.dmcvscd);
        try b.int(self.dmcvsuy);
        try b.int(self.dmcvsum);
        try b.int(self.dmcvsud);
        try b.int(self.dmcvprd);
        try b.int(self.dmcvpmd);
        try b.int(self.dmcvpqd);
        try b.int(self.dmcvpqm);
        try b.int(self.dmcvpyd);
        try b.int(self.dmcvpym);
        try b.int(self.dmcctsrl);
        try b.int(self.dmcctcpy);
        try b.int(self.dmcl2dy);
        const clnam = self.dmcclnam[0..@min(self.dmcclen, self.dmcclnam.len)];
        util.bcd2asc(clnam);
        try b.text(clnam);
        try b.int64(self.dmcszlte);
        try b.int64(self.dmcszgt);
        try b.int(self.dmcaclte);
        try b.int(self.dmcacgt);
    }
};

pub const Record = RecordMC;
pub const record_key = "MC";
pub const process = common.genericProcess(@This());

test "record size" {
    std.debug.print("RecordMC size: {d}\n", .{@sizeOf(RecordMC)});
    try std.testing.expect(@sizeOf(RecordMC) == 362);
}

test "field offsets match IBM layout" {
    try std.testing.expectEqual(204, @offsetOf(RecordMC, "dmcspec1"));
    try std.testing.expectEqual(216, @offsetOf(RecordMC, "dmcretf"));
    try std.testing.expectEqual(224, @offsetOf(RecordMC, "dmcexdat"));
    try std.testing.expectEqual(236, @offsetOf(RecordMC, "dmcbkflg"));
    try std.testing.expectEqual(252, @offsetOf(RecordMC, "dmcbkudc"));
    try std.testing.expectEqual(261, @offsetOf(RecordMC, "dmcmrtdy"));
    try std.testing.expectEqual(268, @offsetOf(RecordMC, "dmcvscy"));
    try std.testing.expectEqual(308, @offsetOf(RecordMC, "dmcctsrl"));
    try std.testing.expectEqual(316, @offsetOf(RecordMC, "dmcclnam"));
    try std.testing.expectEqual(348, @offsetOf(RecordMC, "dmcszlte"));
    try std.testing.expectEqual(356, @offsetOf(RecordMC, "dmcaclte"));
}
