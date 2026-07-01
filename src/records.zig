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

pub const RecordD = extern struct {
    header: Header,
    dcddsnam: [44]u8,
    dcderror: [1]u8,
    dcdflag1: [1]u8,
    dcdflag2: [1]u8,
    dcdflag3: [1]u8,
    _res1: [2]u8,
    dcddsorg: [2]u8,
    dcdrecrd: [1]u8,
    dcdnmext: u8,
    dcdvolsr: [6]u8,
    dcdbklng: u16,
    dcdlrecl: u16,
    dcdallsp: i32,
    dcdusesp: i32,
    dcdscall: i32,
    dcdnmblk: i32,
    dcdcredt: [4]u8,
    dcdexpdt: [4]u8,
    dcdlstrf: [4]u8,
    dcddsser: [6]u8,
    dcdvolsq: u16,
    dcdlbkdt: [8]u8,
    dcddclng: u16,
    dcdatcl: [30]u8,
    dcdsclng: u16,
    dcdstgcl: [30]u8,
    dcdmclng: u16,
    dcdmgtcl: [30]u8,
    dcdsglng: u16,
    dcdstgrp: [30]u8,
    dcdccsid: [2]u8,
    dcdcatf: [1]u8,
    dcddscbf: [1]u8,
    dcdudsiz: i64 align(1),
    dcdcudsz: i64 align(1),
    dcdexflg: [2]u8,
    dcdscnt: u16,
    dcdovera: i32,
    dcdacct: [32]u8,
    dcdflag5: [1]u8,
    _res2: [6]u8,
    dcdds9f1: u8,
    dcdjbnmc: [8]u8,
    dcdstnmc: [8]u8,
    dcdtimec: [6]u8,
    _res3: [2]u8,
    dcdallsx: i64 align(1),
    dcdusesx: i64 align(1),
    dcdscalx: i64 align(1),
    dcdnmblx: i64 align(1),
    dcdxpsev: u8,
    dcdctype: u8,
    dcdtype: u16,
    dcdklbl: [64]u8,
    _res4: [16]u8,

    pub fn error_dcdemngd(self: *RecordD) bool {
        return self.dcderror[0] & 0x80 != 0;
    }

    pub fn error_dcdedvvr(self: *RecordD) bool {
        return self.dcderror[0] & 0x40 != 0;
    }

    pub fn error_dcdnospc(self: *RecordD) bool {
        return self.dcderror[0] & 0x20 != 0;
    }

    pub fn error_dcdvsami(self: *RecordD) bool {
        return self.dcderror[0] & 0x10 != 0;
    }

    pub fn error_dcdnofm1(self: *RecordD) bool {
        return self.dcderror[0] & 0x08 != 0;
    }

    pub fn flag1_dcdracfd(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x80 != 0;
    }

    pub fn flag1_dcdsmsm(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x40 != 0;
    }

    pub fn flag1_dcdtemp(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x20 != 0;
    }

    pub fn flag1_dcdpdse(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x10 != 0;
    }

    pub fn flag1_dcdgds(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x08 != 0;
    }

    pub fn flag1_dcdreblk(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x04 != 0;
    }

    pub fn flag1_dcdchind(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x02 != 0;
    }

    pub fn flag1_dcdckdsi(self: *RecordD) bool {
        return self.dcdflag1[0] & 0x01 != 0;
    }

    pub fn flag2_dcdnovvr(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x80 != 0;
    }

    pub fn flag2_dcdintcg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x40 != 0;
    }

    pub fn flag2_dcdinicf(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x20 != 0;
    }

    pub fn flag2_dcdallfg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x08 != 0;
    }

    pub fn flag2_dcdusefg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x04 != 0;
    }

    pub fn flag2_dcdsecfg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x02 != 0;
    }

    pub fn flag2_dcdnmbfg(self: *RecordD) bool {
        return self.dcdflag2[0] & 0x01 != 0;
    }

    pub fn flag3_dcdpdsex(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x80 != 0;
    }

    pub fn flag3_dcdstrp(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x40 != 0;
    }

    pub fn flag3_dcdddmex(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x20 != 0;
    }

    pub fn flag3_dcdcpoit(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x10 != 0;
    }

    pub fn flag3_dcdgt64k(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x08 != 0;
    }

    pub fn flag3_dcdcmptv(self: *RecordD) bool {
        return self.dcdflag3[0] & 0x04 != 0;
    }

    pub fn dsorg_dcddsgis(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x80 != 0;
    }

    pub fn dsorg_dcddsgps(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x40 != 0;
    }

    pub fn dsorg_dcddsgda(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x20 != 0;
    }

    pub fn dsorg_dcddsgpo(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x02 != 0;
    }

    pub fn dsorg_dcddsgu(self: *RecordD) bool {
        return self.dcddsorg[0] & 0x01 != 0;
    }

    pub fn dsorg_dcddsggs(self: *RecordD) bool {
        return self.dcddsorg[1] & 0x80 != 0;
    }

    pub fn dsorg_dcddsgvs(self: *RecordD) bool {
        return self.dcddsorg[1] & 0x08 != 0;
    }

    pub fn recrd_dcdrecff(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x80 != 0;
    }

    pub fn recrd_dcdrecfv(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x40 != 0;
    }

    pub fn recrd_dcdrecft(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x20 != 0;
    }

    pub fn recrd_dcdrecfb(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x10 != 0;
    }

    pub fn recrd_dcdrecfs(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x08 != 0;
    }

    pub fn recrd_dcdrecfa(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x04 != 0;
    }

    pub fn recrd_dcdrecfc(self: *RecordD) bool {
        return self.dcdrecrd[0] & 0x02 != 0;
    }

    pub fn flag5_dcdallfx(self: *RecordD) bool {
        return self.dcdflag5[0] & 0x80 != 0;
    }

    pub fn flag5_dcdusefx(self: *RecordD) bool {
        return self.dcdflag5[0] & 0x40 != 0;
    }

    pub fn flag5_dcdscafx(self: *RecordD) bool {
        return self.dcdflag5[0] & 0x20 != 0;
    }

    pub fn flag5_dcdnmbfx(self: *RecordD) bool {
        return self.dcdflag5[0] & 0x10 != 0;
    }
};

pub const RecordA = extern struct {
    header: Header,
    dcadsnam: [44]u8,
    dcaassoc: [44]u8,
    dcaflag1: [1]u8,
    dcaflag2: [1]u8,
    _res1: [2]u8,
    dcahurba: u32,
    dcaharba: u32,
    dcanlr: i32,
    dcadlr: i32,
    dcainr: i32,
    dcaupr: i32,
    dcartr: i32,
    dcaasp: i32,
    dcacis: i32,
    dcacas: i32,
    dcaexc: i32,
    dcarkp: u16,
    dcakln: u16,
    dcahurbc: i64 align(1),
    dcaharbc: i64 align(1),
    dcacisz: i32,
    dcacaci: i32,
    dcatrdt: [4]u8,
    _res2: [12]u8,

    pub fn flag1_dcaksds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x80 != 0;
    }

    pub fn flag1_dcaesds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x40 != 0;
    }

    pub fn flag1_dcarrds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x20 != 0;
    }

    pub fn flag1_dcalds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x10 != 0;
    }

    pub fn flag1_dcakrds(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x08 != 0;
    }

    pub fn flag1_dcaaix(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x04 != 0;
    }

    pub fn flag1_dcadata(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x02 != 0;
    }

    pub fn flag1_dcaindex(self: *RecordA) bool {
        return self.dcaflag1[0] & 0x01 != 0;
    }

    pub fn flag2_dcakr1st(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x80 != 0;
    }

    pub fn flag2_dcaixupg(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x40 != 0;
    }

    pub fn flag2_dcavrrds(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x20 != 0;
    }

    pub fn flag2_dcanstat(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x10 != 0;
    }

    pub fn flag2_dcasrci(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x08 != 0;
    }

    pub fn flag2_dcag4g(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x04 != 0;
    }

    pub fn flag2_dcazfs(self: *RecordA) bool {
        return self.dcaflag2[0] & 0x02 != 0;
    }
};

pub const RecordV = extern struct {
    header: Header,
    dcvvolsr: [6]u8,
    dcvflag1: [1]u8,
    dcverror: [1]u8,
    _res1: [3]u8,
    dcvperct: u8,
    dcvfresp: i32,
    dcvalloc: i32,
    dcvvlcap: i32,
    dcvfragi: i32,
    dcvlgext: i32,
    dcvfrext: i32,
    dcvfdscb: i32,
    dcvfvirs: i32,
    dcvdvtyp: [8]u8,
    dcvdvnum: [2]u8,
    _res2: [2]u8,
    dcvsglng: u16,
    dcvsgtcl: [30]u8,
    dcvdptyp: [8]u8,
    dcvtrpct: u8,
    dcveavol: u8,
    _res3: [2]u8,
    dcvtrfsp: i32,
    dcvtralc: i32,
    dcvtrvlc: i32,
    dcvtrfrg: i32,
    dcvtrlge: i32,
    dcvtrfrx: i32,
    dcvfcyls: i32,
    dcvftrks: i32,
    _res4: [4]u8,

    pub fn flag1_dcvinxex(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x80 != 0;
    }

    pub fn flag1_dcvinxen(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x40 != 0;
    }

    pub fn flag1_dcvuspvt(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x20 != 0;
    }

    pub fn flag1_dcvuspub(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x10 != 0;
    }

    pub fn flag1_dcvussto(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x08 != 0;
    }

    pub fn flag1_dcvshrds(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x04 != 0;
    }

    pub fn flag1_dcvmangd(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x02 != 0;
    }

    pub fn flag1_dcvinitl(self: *RecordV) bool {
        return self.dcvflag1[0] & 0x01 != 0;
    }

    pub fn error_dcvevlcp(self: *RecordV) bool {
        return self.dcverror[0] & 0x80 != 0;
    }

    pub fn error_dcvebytk(self: *RecordV) bool {
        return self.dcverror[0] & 0x40 != 0;
    }

    pub fn error_dcvelspc(self: *RecordV) bool {
        return self.dcverror[0] & 0x20 != 0;
    }
};
