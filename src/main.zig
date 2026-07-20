const std = @import("std");
const util = @import("util.zig");
const zon = @import("zon");
const records = @import("records.zig");
const Header = records.Header;
const RecordD = @import("recordD.zig").RecordD;
const RecordA = @import("recordA.zig").RecordA;
const RecordV = @import("recordV.zig").RecordV;
const Database = @import("db.zig").Database;

const Context = struct {
    dcollect_file: []const u8,
    sqlite_db_file: []const u8,
    init: std.process.Init,
    db: Database,

    fn print(self: *Context, comptime fmt: []const u8, args: anytype) !void {
        var stdout_buffer: [1024]u8 = undefined;
        var stdout_writer: std.Io.File.Writer = .init(.stdout(), self.init.io, &stdout_buffer);
        const stdout = &stdout_writer.interface;
        try stdout.print(fmt, args);
        try stdout.flush();
    }
};

pub fn main(init: std.process.Init) !void {
    var ctx = Context{
        .dcollect_file = "",
        .sqlite_db_file = "",
        .init = init,
        .db = undefined,
    };

    var parser = ArgParser{ .ctx = &ctx };
    parser.parseArgs() catch |err| {
        if (err == error.InvalidArguments) {
            std.debug.print("Error: Invalid arguments\n\n", .{});
            std.process.exit(1);
        } else {
            return err;
        }
    };

    var file_parser = FileParser{ .ctx = &ctx };
    file_parser.parseFile() catch |err| {
        std.debug.print("Error processing file {s}: {s}\n", .{ ctx.dcollect_file, @errorName(err) });
        std.process.exit(1);
    };
}

const ArgParser = struct {
    ctx: *Context,

    fn parseArgs(self: *ArgParser) !void {
        const args = self.ctx.init.minimal.args;
        const allocator = self.ctx.init.arena.allocator();

        var iter = args.iterateAllocator(allocator) catch |err| {
            std.debug.print("Error iterating arguments: {s}\n", .{@errorName(err)});
            return err;
        };
        _ = iter.skip(); // Skip the program name
        var arg_count: usize = 0;
        var help_flag: bool = false;
        var version_flag: bool = false;

        var positional_args = try std.ArrayList([]const u8).initCapacity(allocator, 10);
        defer positional_args.deinit(allocator);

        while (iter.next()) |arg| {
            if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
                help_flag = true;
                break;
            }
            if (std.mem.eql(u8, arg, "--version") or std.mem.eql(u8, arg, "-v")) {
                version_flag = true;
                break;
            }
            if (!std.mem.startsWith(u8, arg, "-")) {
                try positional_args.append(allocator, arg);
            }
            arg_count += 1;
        }
        if (help_flag) {
            try self.printUsage();
            std.process.exit(0);
        }
        if (version_flag) {
            try self.ctx.print("dcollect version: {s}\n", .{zon.version});
            std.process.exit(0);
        }
        if (positional_args.items.len != 2) {
            std.debug.print("Error: Expected 2 positional arguments, got {d}\n\n", .{positional_args.items.len});
            try self.printUsage();
            return error.InvalidArguments;
        }
        self.ctx.dcollect_file = positional_args.items[0];
        self.ctx.sqlite_db_file = positional_args.items[1];
    }

    fn printUsage(self: *ArgParser) !void {
        try self.ctx.print("Usage: dcollect [options] <dcollect_file> <sqlite_db_file>\n\n", .{});
        try self.ctx.print("Options:\n", .{});
        try self.ctx.print("  -h, --help       Show this help message\n", .{});
        try self.ctx.print("  -v, --version    Show version information\n", .{});
    }
};

const FileParser = struct {
    ctx: *Context,

    fn parseFile(self: *FileParser) !void {
        const allocator = self.ctx.init.arena.allocator();
        const io = self.ctx.init.io;

        std.log.debug("dcollect_file: {s}\n", .{self.ctx.dcollect_file});
        std.log.debug("sqlite_db_file: {s}\n", .{self.ctx.sqlite_db_file});

        const stat = try std.Io.Dir.cwd().statFile(io, self.ctx.dcollect_file, .{});
        const file_size = stat.size;
        try self.ctx.print("DCOLLECT File: {s}\n", .{self.ctx.dcollect_file});
        try self.ctx.print("DCOLLECT File size: {d} bytes\n\n", .{file_size});

        const file = try std.Io.Dir.cwd().openFile(io, self.ctx.dcollect_file, .{});
        defer file.close(io);

        self.ctx.db = try Database.init(allocator, self.ctx.sqlite_db_file);
        defer self.ctx.db.deinit();

        var read_buffer: [4096]u8 = undefined;
        var reader = file.reader(io, &read_buffer);

        var countD: usize = 0;
        var countA: usize = 0;
        var countV: usize = 0;
        while (true) {
            const header = reader.interface.peekStruct(Header, .big) catch |err| {
                if (err == error.EndOfStream) {
                    break;
                } else {
                    return err;
                }
            };
            var rec_type = header.dcurctyp;
            util.bcd2asc(&rec_type);
            const int_type: u16 = @bitCast(rec_type);

            switch (int_type) {
                util.asUint(u16, "D ") => {
                    var record_d = reader.interface.takeStruct(RecordD, .big) catch |err| {
                        if (err == error.EndOfStream) {
                            break;
                        } else {
                            return err;
                        }
                    };
                    countD += 1;
                    // _ = &record_d; // Currently not processing RecordD, but we can add processing logic here if needed
                    try self.ctx.db.processRecordD(&record_d);
                },
                util.asUint(u16, "A ") => {
                    var record_a = reader.interface.takeStruct(RecordA, .big) catch |err| {
                        if (err == error.EndOfStream) {
                            break;
                        } else {
                            return err;
                        }
                    };
                    countA += 1;
                    // _ = &record_a; // Currently not processing RecordA, but we can add processing logic here if needed
                    try self.ctx.db.processRecordA(&record_a);
                },
                util.asUint(u16, "V ") => {
                    var record_v = reader.interface.takeStruct(RecordV, .big) catch |err| {
                        if (err == error.EndOfStream) {
                            break;
                        } else {
                            return err;
                        }
                    };
                    countV += 1;
                    // _ = &record_v; // Currently not processing RecordV, but we can add processing logic here if needed
                    try self.ctx.db.processRecordV(&record_v);
                },
                else => {
                    _ = reader.interface.take(header.dculeng) catch |err| {
                        if (err == error.EndOfStream) {
                            break;
                        } else {
                            return err;
                        }
                    };
                    continue;
                },
            }
        }

        try self.ctx.print("Processed records:\n", .{});
        try self.ctx.print("+---------------------+\n", .{});
        try self.ctx.print("| D     |  {d:>10} |\n", .{countD});
        try self.ctx.print("+---------------------+\n", .{});
        try self.ctx.print("| A     |  {d:>10} |\n", .{countA});
        try self.ctx.print("+---------------------+\n", .{});
        try self.ctx.print("| V     |  {d:>10} |\n", .{countV});
        try self.ctx.print("+---------------------+\n", .{});
    }
};
