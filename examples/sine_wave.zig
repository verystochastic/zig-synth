const std = @import("std");
const zig_synth = @import("zig-synth");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const sample_rate = 44100;
    const duration = 2.0;
    const num_samples = @as(usize, @intFromFloat(duration * @as(f32, @floatFromInt(sample_rate))));

    var samples = try allocator.alloc(i16, num_samples);
    defer allocator.free(samples);

    var osc = zig_synth.Oscillator.init(440.0, @as(f32, @floatFromInt(sample_rate)));

    for (0..num_samples) |i| {
        const sample = osc.next();
        samples[i] = @as(i16, @intFromFloat(sample * 32767.0));
    }

    const file = try std.fs.cwd().createFile("output.wav", .{});
    defer file.close();

    try write_wav(file, samples, sample_rate);
    std.debug.print("Wrote output.wav\n", .{});
}

fn write_wav(file: std.fs.File, samples: []i16, sample_rate: u32) !void {
    const writer = file.writer();
    const num_samples = samples.len;
    const byte_rate = sample_rate * 2;
    const subchunk2_size = @as(u32, @intCast(num_samples)) * 2;
    const chunk_size = 36 + subchunk2_size;

    try writer.writeAll("RIFF");
    try writer.writeInt(u32, chunk_size, .little);
    try writer.writeAll("WAVE");
    try writer.writeAll("fmt ");
    try writer.writeInt(u32, 16, .little);
    try writer.writeInt(u16, 1, .little);
    try writer.writeInt(u16, 1, .little);
    try writer.writeInt(u32, sample_rate, .little);
    try writer.writeInt(u32, byte_rate, .little);
    try writer.writeInt(u16, 2, .little);
    try writer.writeInt(u16, 16, .little);
    try writer.writeAll("data");
    try writer.writeInt(u32, subchunk2_size, .little);

    for (samples) |sample| {
        try writer.writeInt(i16, sample, .little);
    }
}
