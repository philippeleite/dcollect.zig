# dcollect.zig

`dcollect` is a command-line tool that reads IBM z/OS DCOLLECT binary datasets and writes parsed records into a SQLite database for easy querying.

## What this project does

- Reads a DCOLLECT file generated on z/OS.
- Parses supported record types.
- Creates (or overwrites) SQLite tables for those record types.
- Loads parsed records into SQLite so you can analyze storage and dataset metadata using SQL.

## Requirements

- Zig `0.17.0` or newer
- A DCOLLECT dataset file transferred in **binary mode** (for example, via FTP)

## Build

```bash
zig build
```

The executable is generated at:

```text
zig-out/bin/dcollect
```

## Run

```bash
dcollect [options] <dcollect_file> <sqlite_db_file>
```

### Options

- `-h`, `--help`: Show help message
- `-v`, `--version`: Show version information

### Example

```bash
dcollect MY.DCOLLECT.BIN dcollect.db
```

When finished, the tool prints:

- input file name
- input file size
- count of processed records by type

## SQLite output

Current tables created by the importer:

- `record_d`
- `record_a`
- `record_v`
- `record_dc`
- `record_sc`
- `record_mc`
- `record_sg`
- `record_bc`
- `record_vl`
- `record_ai`
- `record_m`
- `record_b`
- `record_c`
- `record_t`
- `record_ag`
- `record_dr`

> Note: these tables are recreated during import (`DROP TABLE IF EXISTS ...`), so re-running the tool on the same database path replaces previous imported data.

## SQL examples

Things to know before querying:

- Fixed-width text columns keep their trailing blanks (e.g. `dcddsnam`), so use `trim()` when displaying or comparing them.
- `dcdallsp` / `dcdusesp` (D records) are in KB. `dcvvlcap` / `dcvfresp` (V records) are in KB, or in MB when `dcvcylmg = 1`. `dcvperct` is the percent of **free** space. Capacities in VL records (`dvlntcpy`, `dvlnfree`, ...) are in MB.
- Repeating groups in SG, BC and VL records are stored as JSON arrays (see [JSON columns](#json-columns)).

### General

```sql
-- Row count per table
SELECT 'D'  AS type, COUNT(*) AS records FROM record_d
UNION ALL SELECT 'A',  COUNT(*) FROM record_a
UNION ALL SELECT 'V',  COUNT(*) FROM record_v
UNION ALL SELECT 'DC', COUNT(*) FROM record_dc
UNION ALL SELECT 'SC', COUNT(*) FROM record_sc
UNION ALL SELECT 'MC', COUNT(*) FROM record_mc
UNION ALL SELECT 'SG', COUNT(*) FROM record_sg
UNION ALL SELECT 'BC', COUNT(*) FROM record_bc
UNION ALL SELECT 'VL', COUNT(*) FROM record_vl
UNION ALL SELECT 'AI', COUNT(*) FROM record_ai;
```

### Data sets (D, A)

```sql
-- Top 20 largest data sets by allocated space
SELECT trim(dcddsnam) AS dsname, dcdvolsr AS volser,
       ROUND(dcdallsp / 1024.0, 1) AS alloc_mb
FROM record_d
ORDER BY dcdallsp DESC
LIMIT 20;

-- Data sets wasting the most space (allocated but unused)
SELECT trim(dcddsnam) AS dsname,
       ROUND(dcdallsp / 1024.0, 1) AS alloc_mb,
       ROUND(dcdusesp / 1024.0, 1) AS used_mb,
       ROUND((dcdallsp - dcdusesp) / 1024.0, 1) AS unused_mb
FROM record_d
WHERE dcdusesp > 0
ORDER BY dcdallsp - dcdusesp DESC
LIMIT 20;

-- Allocated space by high-level qualifier
SELECT substr(trim(dcddsnam), 1, instr(dcddsnam, '.') - 1) AS hlq,
       COUNT(*) AS datasets,
       ROUND(SUM(dcdallsp) / 1024.0, 1) AS alloc_mb
FROM record_d
WHERE instr(dcddsnam, '.') > 0
GROUP BY hlq
ORDER BY alloc_mb DESC
LIMIT 20;

-- Data sets not referenced in the last 365 days
SELECT trim(dcddsnam) AS dsname, dcdlstrf AS last_ref,
       ROUND(dcdallsp / 1024.0, 1) AS alloc_mb
FROM record_d
WHERE dcdlstrf <> '0000-00-00'
  AND dcdlstrf < date('now', '-365 days')
ORDER BY dcdallsp DESC
LIMIT 20;

-- SMS-managed vs non-SMS space, by storage class
SELECT COALESCE(NULLIF(trim(dcdstgcl), ''), '(non-SMS)') AS storclas,
       COUNT(*) AS datasets,
       ROUND(SUM(dcdallsp) / 1024.0, 1) AS alloc_mb
FROM record_d
GROUP BY storclas
ORDER BY alloc_mb DESC;

-- VSAM KSDS clusters and their data/index components
SELECT trim(dcaassoc) AS cluster, trim(dcadsnam) AS component,
       CASE WHEN dcadata THEN 'DATA' WHEN dcaindex THEN 'INDEX' END AS part
FROM record_a
WHERE dcaksds = 1
ORDER BY cluster, part;
```

### Volumes and storage groups (V, VL, SG)

```sql
-- Fullest volumes (lowest percent free)
SELECT dcvvolsr AS volser, dcvperct AS pct_free,
       ROUND(CASE WHEN dcvcylmg THEN dcvvlcap ELSE dcvvlcap / 1024.0 END) AS capacity_mb,
       ROUND(CASE WHEN dcvcylmg THEN dcvfresp ELSE dcvfresp / 1024.0 END) AS free_mb
FROM record_v
ORDER BY dcvperct
LIMIT 20;

-- Storage group capacity and usage vs. its high threshold
SELECT vl.dvlstgrp AS storgrp,
       COUNT(*) AS volumes,
       SUM(vl.dvlntcpy) AS capacity_mb,
       SUM(vl.dvlnfree) AS free_mb,
       ROUND(100.0 * (SUM(vl.dvlntcpy) - SUM(vl.dvlnfree)) / NULLIF(SUM(vl.dvlntcpy), 0), 1) AS pct_used,
       sg.dsgfhthr AS high_thr
FROM record_vl vl
JOIN record_sg sg ON sg.dsgname = vl.dvlstgrp
GROUP BY vl.dvlstgrp
ORDER BY capacity_mb DESC;

-- SMS volumes: compare VL (MB) with V (KB) for the same volser
SELECT vl.dvlvser, vl.dvlstgrp, vl.dvlntcpy AS vl_capacity_mb,
       ROUND(v.dcvvlcap / 1024.0) AS v_capacity_mb, v.dcvperct AS pct_free
FROM record_vl vl
JOIN record_v v ON trim(v.dcvvolsr) = vl.dvlvser;
```

### SMS constructs (DC, SC, MC, AI)

```sql
-- Management class backup and migration policies
SELECT dmcname, dmcbkfq AS backup_freq, dmcbkvs AS backup_versions,
       dmcbkdy AS keep_extra_days, dmcprdy AS primary_days, dmcl1dy AS ml1_days,
       dmcautbk AS auto_backup
FROM record_mc;

-- Storage classes with guaranteed space
SELECT dscname, trim(dscdesc) AS description
FROM record_sc
WHERE dscdfgsp = 1;

-- Where the SMS ACS routines are stored (empty = routine not defined)
SELECT 'DATACLAS' AS routine, daiddsnm AS dataset, daiddsmr AS member, daiddate AS updated FROM record_ai
UNION ALL SELECT 'MGMTCLAS', daimdsnm, daimdsmr, daimdate FROM record_ai
UNION ALL SELECT 'STORCLAS', daisdsnm, daisdsmr, daisdate FROM record_ai
UNION ALL SELECT 'STORGRP',  daigdsnm, daigdsmr, daigdate FROM record_ai;
```

### JSON columns

Repeating groups are stored as JSON arrays and can be queried with SQLite's built-in JSON functions (`json_each`, `json_extract`, `json_array_length`).

| Table       | JSON columns                                                                 |
| ----------- | ---------------------------------------------------------------------------- |
| `record_sg` | `dsgdmpcl`, `dsgstat`, `dsgcsmss`, `dsgolbnm`, `dsgsysst`, `dsgcnsms`        |
| `record_bc` | `dbcfsysn`, `dbcsfeat`, `dbcsysnt`, `dbcsysnm`, `dbcsysft`, `dbcsnmty`       |
| `record_vl` | `dvlsmss`, `dvlmvss`, `dvlcsmss`, `dvlstsms`, `dvlstmvs`, `dvlsrsms`, `dvlogsms` |
| `record_ag` | `dagdsnms` (array of `{"dsn": ..., "member": ...}` objects, defined entries only) |
| `record_dr` | `ddrsout`, `ddrcfcs`, `ddrreqst`, `ddrcurst`                                 |

The per-system arrays are positional: element N of `dsgsysst` (SG) or `dvlstsms` (VL) is the status on the system named in element N of `dbcsysnm` (BC). The 8-element arrays (`dsgstat`, `dvlsmss`, ...) line up with `dbcfsysn` the same way. Status values: SMS `1` = enabled, `2` = quiesced/all, `3` = quiesced/new, `4` = disabled/all, `5` = disabled/new. MVS `1` = online, `2` = offline, `3` = pending offline, `4` = boxed, `5` = not ready. OAM (DR) `0` = no connectivity, `1` = online, `2` = offline, `3` = no outstanding request.

```sql
-- Systems defined in the SMS base configuration
SELECT j.key AS slot, j.value AS system
FROM record_bc, json_each(record_bc.dbcsysnm) AS j
WHERE j.value <> '';

-- Storage group status on each system (SG x BC by array position)
SELECT sg.dsgname,
       json_extract(bc.dbcsysnm, '$[' || st.key || ']') AS system,
       CASE st.value WHEN 1 THEN 'ENABLED'      WHEN 2 THEN 'QUIESCED/ALL'
                     WHEN 3 THEN 'QUIESCED/NEW' WHEN 4 THEN 'DISABLED/ALL'
                     WHEN 5 THEN 'DISABLED/NEW' END AS status
FROM record_sg sg
CROSS JOIN record_bc bc
JOIN json_each(sg.dsgsysst) AS st
WHERE json_extract(bc.dbcsysnm, '$[' || st.key || ']') <> ''
ORDER BY sg.dsgname, system;

-- Volumes that are not SMS-enabled or not online on some system
SELECT vl.dvlvser, vl.dvlstgrp,
       json_extract(bc.dbcsysnm, '$[' || sms.key || ']') AS system,
       sms.value AS sms_status,
       json_extract(vl.dvlstmvs, '$[' || sms.key || ']') AS mvs_status
FROM record_vl vl
CROSS JOIN record_bc bc
JOIN json_each(vl.dvlstsms) AS sms
WHERE json_extract(bc.dbcsysnm, '$[' || sms.key || ']') <> ''
  AND (sms.value <> 1 OR json_extract(vl.dvlstmvs, '$[' || sms.key || ']') <> 1);

-- Storage groups with auto-dump classes defined
SELECT dsgname, j.value AS dump_class
FROM record_sg, json_each(record_sg.dsgdmpcl) AS j
WHERE j.value <> '';

-- Read a single slot and the array length
SELECT dvlvser,
       json_extract(dvlstsms, '$[0]') AS sms_status_sys0,
       json_extract(dvlstmvs, '$[0]') AS mvs_status_sys0,
       json_array_length(dvlstsms) AS slots
FROM record_vl
LIMIT 5;
```

## Implemented DCOLLECT record types

| Type | Description                                     | Implemented |
| ---- | ----------------------------------------------- | :---------: |
| D    | Active Data Set Record                          |     ✅      |
| A    | VSAM Association Information                    |     ✅      |
| V    | Volume Information                              |     ✅      |
| M    | Migrated Data Set Information                   |    ✅ ¹     |
| B    | Backup Data Set Information                     |    ✅ ¹     |
| C    | DASD Capacity Planning Information              |    ✅ ¹     |
| T    | Tape Capacity Planning Information              |    ✅ ¹     |
| DC   | Data Class Construct Information                |     ✅      |
| SC   | Storage Class Construct Information             |     ✅      |
| MC   | Management Class Construct Information          |     ✅      |
| BC   | Base Configuration Information                  |     ✅      |
| SG   | Storage Group Construct Information             |     ✅      |
| VL   | Storage Group Volume Information                |     ✅      |
| AG   | Aggregate Group Information                     |    ✅ ¹     |
| DR   | OAM Drive Record Information                    |    ✅ ¹     |
| LB   | OAM Library Record Information                  |     ❌      |
| CN   | Cache Names from Base Configuration Information |     ❌      |
| AI   | Accounting Information from ACS Routines        |     ✅      |

¹ Implemented from the IBM documentation and covered by synthetic-record tests, but not yet validated against a real DCOLLECT file. Reports of mismatches are welcome.

## Notes

- Unknown or unsupported record types are skipped.
- For reliable parsing, ensure the DCOLLECT file is not text-converted during transfer.
