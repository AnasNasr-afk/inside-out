import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

/// Synthesized sounds for the Child Mode transition — no audio files needed.
/// Call [ChildModeSounds.instance.init()] before first use.
class ChildModeSounds {
  ChildModeSounds._();
  static final instance = ChildModeSounds._();

  bool muted = false;
  bool _ready = false;

  String? _whooshPath, _thudPath, _chimePath, _sparklePath, _tapPath,
      _coinPath;

  // Pool of players for rapid coin ticks (one tick every 26 ms)
  final _coinPool = <AudioPlayer>[];
  int _coinIdx = 0;

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_ready) return;
    _ready = true;
    final dir = await getTemporaryDirectory();
    _whooshPath  = await _save(dir, 'cm_whoosh.wav',  _whooshSamples());
    _thudPath    = await _save(dir, 'cm_thud.wav',    _thudSamples());
    _chimePath   = await _save(dir, 'cm_chime.wav',   _chimeSamples());
    _sparklePath = await _save(dir, 'cm_sparkle.wav', _sparkleSamples());
    _tapPath     = await _save(dir, 'cm_tap.wav',     _tapSamples());
    _coinPath    = await _save(dir, 'cm_coin.wav',    _coinSamples());

    for (int i = 0; i < 6; i++) {
      final p = AudioPlayer();
      await p.setAudioSource(AudioSource.uri(Uri.file(_coinPath!)));
      _coinPool.add(p);
    }
  }

  void dispose() {
    for (final p in _coinPool) {
      p.dispose();
    }
    _ready = false;
  }

  void playWhoosh()  => _once(_whooshPath);
  void playThud()    => _once(_thudPath);
  void playChime()   => _once(_chimePath);
  void playSparkle() => _once(_sparklePath);
  void playTap()     => _once(_tapPath);

  void playCoin() {
    if (muted || _coinPath == null) return;
    final p = _coinPool[_coinIdx % _coinPool.length];
    _coinIdx++;
    p.seek(Duration.zero).then((_) => p.play());
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<void> _once(String? path) async {
    if (muted || path == null) return;
    final p = AudioPlayer();
    try {
      await p.setAudioSource(AudioSource.uri(Uri.file(path)));
      await p.play();
    } catch (_) {}
    p.dispose();
  }

  Future<String> _save(Directory dir, String name, List<double> samples) async {
    final path = '${dir.path}/$name';
    await File(path).writeAsBytes(_makeWav(samples));
    return path;
  }

  // ── WAV builder ────────────────────────────────────────────────────────────

  static Uint8List _makeWav(List<double> samples, {int sr = 44100}) {
    final pcm = ByteData(samples.length * 2);
    for (int i = 0; i < samples.length; i++) {
      pcm.setInt16(
          i * 2, (samples[i].clamp(-1.0, 1.0) * 32767).round(), Endian.little);
    }
    final data = pcm.buffer.asUint8List();
    final hdr = ByteData(44);
    void tag(int off, String s) {
      for (int i = 0; i < s.length; i++) {
        hdr.setUint8(off + i, s.codeUnitAt(i));
      }
    }
    tag(0, 'RIFF');
    hdr.setUint32(4, 36 + data.length, Endian.little);
    tag(8, 'WAVE');
    tag(12, 'fmt ');
    hdr.setUint32(16, 16, Endian.little);
    hdr.setUint16(20, 1, Endian.little);  // PCM
    hdr.setUint16(22, 1, Endian.little);  // mono
    hdr.setUint32(24, sr, Endian.little);
    hdr.setUint32(28, sr * 2, Endian.little);
    hdr.setUint16(32, 2, Endian.little);
    hdr.setUint16(34, 16, Endian.little);
    tag(36, 'data');
    hdr.setUint32(40, data.length, Endian.little);
    return Uint8List.fromList([...hdr.buffer.asUint8List(), ...data]);
  }

  // ── Wave generators ────────────────────────────────────────────────────────

  static double _tri(double t, double freq) {
    final p = (t * freq) % 1.0;
    return p < 0.5 ? 4 * p - 1 : 3 - 4 * p;
  }

  static double _sq(double t, double freq) =>
      (t * freq) % 1.0 < 0.5 ? 1.0 : -1.0;

  // White-noise sweep 280→2800 Hz, ~0.6 s
  static List<double> _whooshSamples() {
    const sr = 44100;
    const dur = 0.6;
    final len = (sr * dur).round();
    final rng = math.Random(42);
    return List.generate(len, (i) {
      final t = i / sr;
      final noise = rng.nextDouble() * 2 - 1;
      final env = math.sin(t / dur * math.pi);
      final sweep = 280 + (2800 - 280) * t / dur;
      final mod = (math.sin(2 * math.pi * sweep * t * 0.08) * 0.5 + 0.5);
      return (noise * env * mod * 0.28).clamp(-1.0, 1.0);
    });
  }

  // 120 Hz + 68 Hz sines with fast exponential decay
  static List<double> _thudSamples() {
    const sr = 44100;
    final len = (sr * 0.28).round();
    return List.generate(len, (i) {
      final t = i / sr;
      final s1 = math.sin(2 * math.pi * 120 * t) * math.exp(-t * 22) * 0.40;
      final s2 = math.sin(2 * math.pi * 68  * t) * math.exp(-t * 16) * 0.32;
      return (s1 + s2).clamp(-1.0, 1.0);
    });
  }

  // C5-E5-G5-C6 triangle arpeggio + 1568 Hz sine, staggered 90ms
  static List<double> _chimeSamples() {
    const sr = 44100;
    final len = (sr * 1.0).round();
    const freqs  = [523.25, 659.25, 783.99, 1046.5];
    const starts = [0.0,    0.09,   0.18,   0.27  ];
    return List.generate(len, (i) {
      final t = i / sr;
      double s = 0;
      for (int n = 0; n < 4; n++) {
        if (t < starts[n]) continue;
        final dt = t - starts[n];
        s += _tri(dt, freqs[n]) * math.exp(-dt * 5) * 0.22;
      }
      if (t >= 0.36) {
        final dt = t - 0.36;
        s += math.sin(2 * math.pi * 1568 * dt) * math.exp(-dt * 8) * 0.12;
      }
      return s.clamp(-1.0, 1.0);
    });
  }

  // 6 random blips 1.5–3 kHz, 50 ms apart
  static List<double> _sparkleSamples() {
    const sr = 44100;
    final len = (sr * 0.45).round();
    final rng = math.Random(7);
    final freqs = List.generate(6, (_) => 1500 + rng.nextDouble() * 1500);
    return List.generate(len, (i) {
      final t = i / sr;
      double s = 0;
      for (int n = 0; n < 6; n++) {
        final start = n * 0.05;
        if (t < start || t > start + 0.12) continue;
        final dt = t - start;
        s += math.sin(2 * math.pi * freqs[n] * dt) *
            math.exp(-dt * 55) * 0.07;
      }
      return s.clamp(-1.0, 1.0);
    });
  }

  // 880 + 1320 Hz square blip (~80 ms)
  static List<double> _coinSamples() {
    const sr = 44100;
    final len = (sr * 0.08).round();
    return List.generate(len, (i) {
      final t = i / sr;
      double s = 0;
      if (t < 0.05) {
        s += _sq(t, 880)  * math.exp(-t * 80) * 0.06;
      }
      if (t >= 0.025 && t < 0.075) {
        final dt = t - 0.025;
        s += _sq(dt, 1320) * math.exp(-dt * 80) * 0.05;
      }
      return s.clamp(-1.0, 1.0);
    });
  }

  // 440 Hz triangle tap (~70 ms)
  static List<double> _tapSamples() {
    const sr = 44100;
    final len = (sr * 0.07).round();
    return List.generate(len, (i) {
      final t = i / sr;
      return (_tri(t, 440) * math.exp(-t * 65) * 0.12).clamp(-1.0, 1.0);
    });
  }
}
