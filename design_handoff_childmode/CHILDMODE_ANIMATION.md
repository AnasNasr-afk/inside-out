# Handoff: Child Mode — "Game Mode" entry animation + screen

## ⚠️ SCOPE — read this first
Implement **TWO things only**:
1. The **transition animation** that plays when the user toggles **Child Mode ON**.
2. The **Child Mode screen** it lands on ("Poly's World", with the 3 game tiles).

**Do NOT rebuild the Home screen.** The Home screen already exists in the app. In the prototype file it is only included so the animation has a trigger. Wire the animation to the **existing** Home "Child Mode" toggle, and on completion navigate to the new Child Mode screen.

## About the file
`IO ChildMode Enter.dc.html` is an **HTML design reference** (a working prototype). It is not production code to paste — recreate its look, motion, and sound in this app's framework and patterns. Everything is inline-styled; read the inline `style="…"` for exact values and the `<script>`/logic for timing and sound. Fidelity: **high** (final colors, motion, audio).

---

## The animation — phase timeline
Triggered on toggling Child Mode ON. Total ≈ 3.2 s, then you're on the new screen.

| t (ms) | Phase | What happens | Sound |
|---|---|---|---|
| 0 | **open** | Toggle flips ON. A violet **portal** (radial-gradient circle) wipes open via an expanding circular mask, **originating from the toggle** (origin ≈ 84% / 60% of screen). The Home screen scales to 0.92, fades to 0, blurs 6px. | **Whoosh** (filtered white-noise sweep 280→2800 Hz, ~0.6 s) |
| 520 | **reveal** | White **flash**; a **shockwave ring** expands (scale .3→3.4, 1 s); slow-rotating **god-rays** behind center; 2 pulsing rings; **26 stars burst** outward; **Poly mascot springs in** with overshoot, then idle-bobs. Title **"POLY'S WORLD"** pops up with a **gloss shine** sweep. | **Thud** (120 Hz + 68 Hz sines) |
| 1500 | **celebrate** | Gold **"PLAYTIME!"** badge **stamps in** (scale 2→1, rotate settle); subtitle "Ready to play, HOSS?" fades in; **34 confetti** pieces rain; a quick **screen shake** (~0.42 s). | **Fanfare** (C5-E5-G5-C6 triangle arpeggio + 1568 Hz) + **sparkles** (6 random 1.5–3 kHz blips) |
| 3150 | **child** | Violet world fades out; **Child Mode screen fades in** (0.45 s); the **star/coin counter tallies 0→120**; the 3 game tiles **rise in**, staggered (delays 0.05 / 0.16 / 0.27 s). | **Coin blips** per tick (880 + 1320 Hz squares) |
| — | back | Back arrow → return to Home (reset). | — |

### Easing & motion specifics
- Portal mask: `clip-path: circle(0 → 150% at 84% 60%)`, `cubic-bezier(.7,0,.2,1)`, 0.85 s.
- Mascot entrance: scale 0.2→1.18→0.94→1 with `cubic-bezier(.2,.9,.25,1.1)`, ~0.85 s, then a 2.6 s ease-in-out bob loop.
- Title: translateY 30→0 with a slight overshoot; gloss = a white diagonal gradient sweeping left→right once.
- Badge: scale 2→0.88→1, rotate −14°→5°→−3°.
- Tiles: translateY 46→0 + scale 0.94→1, `cubic-bezier(.2,.85,.25,1.05)`.

---

## The Child Mode screen ("Poly's World")
- **Background:** soft gradient `#F1ECFF → #E7F6F3` with two faint floating circles (violet `rgba(124,92,255,.10)`, mint `rgba(20,217,196,.12)`), gentle bob.
- **Header:** back chip (rounded 13, white 70%) + title **"Poly's World"** (19px/800) with sub **"Hi HOSS! · Level 1"** (`#7C5CFF`). Right: white pill with a gold star + **coin count** (tabular numerals).
- **3 game tiles** (rounded 26, padding 20, colored shadow, left icon-tile 62px / title 21px-800 / subtitle 12.5px / right white play-circle):
  1. **Online Tasks** — bg `linear-gradient(135deg,#FFD256,#FFB020)`, text `#4A3300`, sub `#7A5500`, list-checks icon. Subtitle "Finish your daily missions".
  2. **Games** — bg `linear-gradient(135deg,#1ED8C4,#0FB6A6)`, text `#03342F`, gamepad icon. Subtitle "Play & learn with Poly".
  3. **Talk to Poly** — bg `linear-gradient(135deg,#8A6BFF,#6A4BF0)`, white text, smile icon with a mint "online" dot. Subtitle "Chat with your buddy · online". *(This replaces the old "AI Avatar".)*
- Tap on a tile plays a soft click; wire each to its real destination (Tasks list / Games / Poly chat).

## Sounds (synthesized — no audio files)
All generated with the Web Audio API at runtime (see the `audioInit / _tone / sWhoosh / sThud / sChime / sSparkle / sCoin / sTap` methods in the file). Initialize the audio context **inside the tap handler** (browsers require a user gesture). In a native app, use short sound assets or a synth lib with the same intent: whoosh, thud, 4-note rising fanfare, sparkle, coin tick, tap. Provide a **mute setting** (kids' app).

## Design tokens (shared with the rest of the app)
Primary violet `#7C5CFF` · success mint `#14D9C4` · accent coral `#FF5B72` · gold `#FFC93C` · ink `#211E40`. Font **Plus Jakarta Sans**.

## How to translate the technique
- **Web (React):** Framer Motion / CSS keyframes + a small Web Audio helper (reuse the one in the file almost as-is).
- **React Native:** Reanimated (timeline of `withTiming`/`withSequence`), a masked circular reveal (react-native-masked-view or an expanding circle), `react-native-confetti`/custom particles, `expo-av` or `react-native-sound` for SFX.
- **Flutter:** `AnimationController`s sequenced, `ClipPath`/`CircularRevealAnimation` for the portal, a confetti package, `audioplayers` for SFX.

## Accessibility
- Honor **reduced-motion**: skip the portal/celebration, do a quick cross-fade to the screen.
- Provide a **sound on/off** toggle.
- Keep the celebration short and not too flashy (sensory-sensitive users).

## Files
- `IO ChildMode Enter.dc.html` — the prototype (Home trigger + transition + Child Mode screen). Reference the transition logic and the Child Mode screen markup; ignore the Home layout (already built).
