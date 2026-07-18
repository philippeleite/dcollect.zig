pub const Header = extern struct {
    dculeng: u16,
    _res1: [2]u8,
    dcurctyp: [2]u8,
    dcuvers: u16,
    dcusysid: [4]u8,
    dcutime: [4]u8,
    dcudate: [4]u8,
    _res2: [4]u8,
};
