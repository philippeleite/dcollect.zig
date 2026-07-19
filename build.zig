const std = @import("std");

pub fn build(b: *std.Build) void {
    const strip = b.option(bool, "strip", "Strip debug information");
    const single_threaded = b.option(bool, "single-threaded", "Build single-threaded version");

    const zon = @import("build.zig.zon");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "dcollect",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .strip = strip orelse false,
            .single_threaded = single_threaded orelse false,
            .imports = &.{},
        }),
    });

    const c_header = b.addTranslateC(.{
        .root_source_file = b.path("lib/sqlite/sqlite3.h"),
        .optimize = optimize,
        .target = target,
        .link_libc = true,
    });
    const c_headermod = c_header.createModule();
    exe.root_module.addImport("sqlite", c_headermod);

    const c_source = b.addLibrary(.{
        .name = "sqlite",
        .root_module = b.createModule(.{
            .optimize = optimize,
            .target = target,
            .link_libc = true,
        }),
    });
    c_source.root_module.addCSourceFile(.{
        .file = b.path("lib/sqlite/sqlite3.c"),
        .flags = &.{
            "-DSQLITE_DQS=0",
            "-DSQLITE_DEFAULT_SYNCHRONOUS=0",
            "-DSQLITE_DEFAULT_MEMSTATUS=0",
            "-DSQLITE_DEFAULT_CACHE_SIZE=-32000",
            "-DSQLITE_USE_ALLOCA=1",
            "-DSQLITE_THREADSAFE=0",
            "-DSQLITE_TEMP_STORE=3",
            "-DSQLITE_ENABLE_API_ARMOR=1",
            "-DSQLITE_ENABLE_UNLOCK_NOTIFY",
            "-DSQLITE_DEFAULT_FILE_PERMISSIONS=0600",
            "-DSQLITE_OMIT_DECLTYPE=1",
            "-DSQLITE_OMIT_DEPRECATED=1",
            "-DSQLITE_OMIT_LOAD_EXTENSION=1",
            "-DSQLITE_OMIT_PROGRESS_CALLBACK=1",
            "-DSQLITE_OMIT_SHARED_CACHE",
            "-DSQLITE_OMIT_TRACE=1",
            "-DSQLITE_OMIT_UTF16=1",
            "-DHAVE_USLEEP=0",
        },
    });
    c_source.root_module.addIncludePath(b.path("lib/sqlite"));
    exe.root_module.linkLibrary(c_source);
    exe.root_module.addIncludePath(b.path("lib/sqlite"));

    const options = b.addOptions();
    options.addOption([]const u8, "version", zon.version);
    exe.root_module.addOptions("zon", options);

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_exe_tests.step);
}
