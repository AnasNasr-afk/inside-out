# Handoff: Poly Missions — "Talk to Poly" task screen (UI FIRST)

## ⚠️ Build order — UI ONLY first
**Phase 1 (do this now): build the UI and the screen-state flow with MOCK data and SIMULATED timing.**
Do **not** integrate microphone capture, audio recording, or any speech/AI analysis yet. The "recording" and "analyzing" steps are visual states driven by timers/buttons. We will wire real mic + AI in a later phase.

When you finish Phase 1, stop and let me review. Phase 2 (real mic + AI) comes after.

## About the file
`IO Poly Missions.dc.html` is an HTML **design reference** (a working prototype). Recreate its look and flow in **this codebase's** framework/patterns — don't paste it. Everything is inline-styled; read the inline `style="…"` for exact values and the logic class for the state machine. Fidelity: **high**.

> Poly (the polar-bear mascot) must NOT be redrawn — in the prototype he's a drop-in image slot. In the app, render the existing Poly asset in that spot.

---

## Screen purpose
A child opens "Talk to Poly", **picks a mission**, Poly **asks about it**, the child **records a spoken answer**, Poly **analyzes & responds**, and the **task is marked done**. Repeat for the next mission.

## The state machine (single screen, 5 phases)
| Phase | UI | Transition |
|---|---|---|
| **pick** | 3 floating mission cards; Poly bubble "Pick a mission, HOSS!"; "Today's wins" shelf at bottom. | Tap a card → **focus** |
| **focus** | Picked task animates to a **large centered pill**; the other tasks **shrink to small dimmed chips** above it. Poly bubble shows that task's **question**. Big violet **mic** button ("Tap to answer Poly"). | Tap mic → **recording** |
| **recording** | Bubble "I'm listening… 👂". A pill with a **pulsing red dot + running timer (m:ss) + animated waveform**. Big red **Stop** button ("Tap to stop"). | Tap stop → **analyzing** |
| **analyzing** | Bubble "Hmm, let me think… 🤔". A pill "**Poly is thinking…**" with 3 bouncing dots. *(Phase 1: a ~1.8 s timer stands in for AI.)* | auto after delay → **response** |
| **response** | Bubble shows Poly's **praise** for that task. Centered task gets a **Done ✓** badge; **+10** floats off Poly; **confetti**; **star counter** increments. Green **"Next mission"** button. | Tap next → **pick** (task now marked done). When all done, button reads "All done!". |

### Mission data (mock)
Each: `{ key, label, color, deepColor, question, response, reward:10 }`
1. **Brush teeth** — mint `#1ED8C4`/`#0E8F82` — Q: "Show me how you brush your teeth — tell me the steps!" — R: "Awesome! Up, down and all around — super clean! 🦷"
2. **Tidy toys** — gold `#FFC93C`/`#A9750E` — Q: "How do you tidy your toys? Tell me your plan!" — R: "Great plan! A tidy room feels so good. 🧸"
3. **Say hello** — violet `#8A6BFF`/`#5A3DD6` — Q: "Can you say hello and tell me your name?" — R: "So friendly! That was a lovely hello. 👋"

### State to track
`phase` ('pick'|'focus'|'recording'|'analyzing'|'response'), `currentTaskIndex`, `completed[]`, `coins`, `recordingSeconds`.

---

## Visual design
- **Background:** twilight gradient `#2B2360 → #4A3A9C → #6E5BC9 → #3FA8C9` with two blurred **aurora ribbons** (violet `#9B7BFF` + mint `#3FE0CE`), **twinkling star** dots, gentle **falling snow**, a light **snow-mound ground** (`#EAF4F8→#C6DCEA`), and a soft white **glow** behind Poly.
- **Top bar:** a single frosted-glass round **back** button, top-left. *(No language/EN badge — removed.)*
- **Progress chip (top center):** frosted pill — gold star + coin count (tabular) + divider + "X/3 done".
- **Mission cards (pick):** white rounded-22 cards, icon tile (task color @ 15% bg, deep color icon), label, "⭐+10". Gentle **float** bob, out of phase. Completed = faded + check badge.
- **Current task pill (focus+):** white rounded-20 pill, 3px border in task color, icon tile + label; gains a mint "Done ✓" chip in response.
- **Other chips (focus+):** small frosted pills (icon + label) at ~65% opacity — the "shrunk" tasks.
- **Speech bubble:** white rounded-20 with a downward tail, centered above Poly; text changes per phase (always visible).
- **Poly:** centered, standing on the mound with a soft shadow; idle **bob**, switches to a **cheer** hop on response. Use the existing Poly image asset.
- **Mic button:** 78px violet gradient circle (`#8A6BFF→#6A4BF0`) with a pulsing ring. **Stop button:** 78px coral `#FF5B72` circle with a rounded square. **Continue:** mint `#14D9C4` pill.
- **Waveform:** ~9 thin white bars with varied heights animating scaleY. **Thinking:** 3 white dots bouncing in sequence.
- **"Today's wins" shelf (pick only):** frosted bar; completed missions appear as colored rounded badges with a check.
- **Tokens:** primary violet `#7C5CFF`/`#8A6BFF`, success mint `#14D9C4`, accent coral `#FF5B72`, gold `#FFC93C`, ink `#2B2360`. Font **Plus Jakarta Sans**. Icons are inline Lucide-style SVG (tooth, box, waving hand, mic, square, check, star, chevrons) — substitute your icon set.

## Motion (build with framework-native animation)
- **Pick → focus:** picked card scales up & moves to center; others scale down + fade to chips (shared-element / layout transition).
- **Select / dim:** spring; ~0.22s ease.
- **Recording:** looping waveform + pulsing dot; timer counts each second.
- **Analyzing:** looping dot bounce.
- **Response:** Poly cheer hop, +10 float-up, confetti fall (~28 pieces), Done stamp, counter tick.
- Make **resting/critical elements visible by default**; use entrance animations only as enhancement so a paused timeline never leaves a control invisible. Honor **reduced-motion** (cross-fade instead).

## Sounds (already in the prototype; Phase 1 keep simple)
Synth blips via Web Audio: pick "pop", record-start (rising), record-stop (falling), win fanfare. Add a **mute** toggle. *(Fine to stub in Phase 1.)*

## Phase 2 (LATER — do NOT build yet)
- Replace the mic button with real **audio recording** (getUserMedia / platform recorder).
- Replace the analyzing timer with a real **speech-to-text + evaluation / AI** call; drive the response text and pass/fail from its result.
- Persist completed missions, coins, and streak to real data.

## Files
- `IO Poly Missions.dc.html` — the prototype (full flow + visuals + the mock data, questions, responses, and timing to mirror).
