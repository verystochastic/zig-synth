# zig-synth

DSP synthesis library for Zig.

## Status

MVP. Oscillators only. Sine wave implemented.

## Build

```bash
zig build run
```

Generates `output.wav` — 2 seconds at 440 Hz.

## API

```zig
const zig_synth = @import("zig-synth");

var osc = zig_synth.Oscillator.init(frequency, sample_rate);
const sample = osc.next();
```

## Current

- Oscillator (sine only)
- Example: sine_wave.zig generates WAV files

## Planned

- Waveforms: sawtooth, square, triangle
- Envelope (ADSR)
- Filters
- FM synthesis

## License

MIT
