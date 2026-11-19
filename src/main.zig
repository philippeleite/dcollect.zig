const std = @import("std");
const util = @import("util.zig");
const zon = @import("zon");
const common = @import("common.zig");
const Context = common.Context;
const Database = common.Database;

pub fn main(init: std.process.Init) !void {
    var ctx = Context.init(init);
    defer ctx.deinit();

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
    try file_parser.showCounters();
}

const ArgParser = struct {
    ctx: *Context,

    fn parseArgs(self: *ArgParser) !void {
        const args = self.ctx.in.minimal.args;
        const allocator = self.ctx.in.arena.allocator();

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
        const allocator = self.ctx.in.arena.allocator();
        const io = self.ctx.in.io;

        // Check if the dcollect file exists and get its size
        const stat = std.Io.Dir.cwd().statFile(io, self.ctx.dcollect_file, .{}) catch |err| {
            if (err == error.FileNotFound) {
                std.log.err("DCOLLECT file not found: {s}", .{self.ctx.dcollect_file});
            } else {
                std.log.err("Failed to stat dcollect file: {s}", .{@errorName(err)});
            }
            return err;
        };
        const file_size = stat.size;
        try self.ctx.print("DCOLLECT File: {s}\n", .{self.ctx.dcollect_file});
        try self.ctx.print("DCOLLECT File size: {d} bytes\n\n", .{file_size});

        // Open the dcollect file for reading
        const file = try std.Io.Dir.cwd().openFile(io, self.ctx.dcollect_file, .{.mode = .read_only});
        defer file.close(io);

        // Initialize the SQLite database
        self.ctx.db = try Database.init(allocator, self.ctx.sqlite_db_file);
        defer self.ctx.db.deinit();

        var read_buffer: [4096]u8 = undefined;
        var reader = file.reader(io, &read_buffer);

        while (true) {
            const reclen = reader.interface.peekInt(u16, .big) catch |err| {
                if (err == error.EndOfStream) {
                    break;
                } else {
                    return err;
                }
            };

            const record = reader.interface.take(reclen) catch |err| {
                if (err == error.EndOfStream) {
                    break;
                } else {
                    return err;
                }
            };
            try common.processRecord(self.ctx, record);
        }
    }

    fn showCounters(self: *FileParser) !void {
        var buffer: [32]u8 = undefined;
        try self.ctx.print("Processed records:\n", .{});
        try self.ctx.print("+--------------------+\n", .{});
        var it = self.ctx.count.iterator();
        while (it.next()) |entry| {
            const value = util.commaInt(&buffer, entry.value_ptr.*);
            try self.ctx.print("| {s:<3} | {s:>12} |\n", .{ entry.key_ptr.*, value });
            try self.ctx.print("+--------------------+\n", .{});
        }
    }
};

test "parseFile processes testdata/DCOLLECT and produces expected row counts" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    var init: std.process.Init = undefined;
    init.arena = &arena;
    init.gpa = std.testing.allocator;
    init.io = std.testing.io;

    var ctx = Context.init(init);
    defer ctx.deinit();
    ctx.dcollect_file = "testdata/DCOLLECT";
    ctx.sqlite_db_file = ":memory:";

    // `zig build test` runs the test binary in a mode where stdin/stdout are
    // reserved for the build runner's test protocol, so `ctx.print` must not
    // write to the real stdout here. Discard it instead.
    var discard_buffer: [256]u8 = undefined;
    var discarding: std.Io.Writer.Discarding = .init(&discard_buffer);
    ctx.stdout_override = &discarding.writer;

    var file_parser = FileParser{ .ctx = &ctx };
    try file_parser.parseFile();

    try std.testing.expectEqual(@as(usize, 3791), ctx.count.get("D ").?);
    try std.testing.expectEqual(@as(usize, 962), ctx.count.get("A ").?);
    try std.testing.expectEqual(@as(usize, 19), ctx.count.get("V ").?);
    try std.testing.expectEqual(@as(usize, 12), ctx.count.get("DC").?);
    try std.testing.expectEqual(@as(usize, 13), ctx.count.get("SC").?);
}
