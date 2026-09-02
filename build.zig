const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addModule("zig-synth", .{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const example = b.addExecutable(.{
        .name = "sine_wave",
        .root_source_file = b.path("examples/sine_wave.zig"),
        .target = target,
        .optimize = optimize,
    });

    example.root_module.addImport("zig-synth", lib);

    b.installArtifact(example);

    const run_cmd = b.addRunArtifact(example);
    const run_step = b.step("run", "Run sine_wave example");
    run_step.dependOn(&run_cmd.step);
}
