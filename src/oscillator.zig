const std = @import("std");

pub const Oscillator = struct {
    phase: f32,
    frequency: f32,
    sample_rate: f32,

    pub fn init(frequency: f32, sample_rate: f32) Oscillator {
        return .{
            .phase = 0.0,
            .frequency = frequency,
            .sample_rate = sample_rate,
        };
    }

    pub fn next(self: *Oscillator) f32 {
        const sample = std.math.sin(self.phase * std.math.tau);
        self.phase += self.frequency / self.sample_rate;
        if (self.phase >= 1.0) {
            self.phase -= 1.0;
        }
        return sample;
    }
};
