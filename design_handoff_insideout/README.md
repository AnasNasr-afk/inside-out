# Handoff: InsideOut — Home + 5 core screens

## Overview
InsideOut is a mobile app supporting a child (here "HOSS", 12, ADHD) with daily emotional / behavioral tasks, a friendly mascot ("Poly"), specialist session reports, and a care team. This package covers **6 screens**: Home, Tasks, Task Detail, Reports, Profile, and the Poly Avatar (activity picker).

## About the design files
The files in this bundle are **design references created in HTML** — prototypes showing the intended look and behavior. They are **not production code to copy verbatim**. Your job is to **recreate these designs in the target codebase's existing environment and patterns** (React Native, Flutter, SwiftUI, React web, etc.). If the project has no UI environment yet, pick the most appropriate framework and implement them there.

Two reference formats are included:
- **`reference_flat/`** — `01_home.html` and `02_screens.html` are fully flattened, plain HTML with **inline styles only**. These are the **source of truth for exact pixels, colors, and typography** — read the inline `style="…"` on any element to get precise values.
- **`source_components/`** — the original `.dc.html` components. Read these for **interaction logic and state** (look at each `class Component extends DCLogic { renderVals() {…} }` block). They require a runtime to render, so use them for *behavior*, not for rendering.

## Fidelity
**High-fidelity (hifi).** Final colors, typography, spacing, and interactions are all specified. Recreate pixel-faithfully using the codebase's own components where equivalents exist (buttons, cards, list rows), matching the tokens below.

---

## Design Tokens

### Color roles (IMPORTANT — single primary)
| Role | Hex | Usage |
|---|---|---|
| **Primary (brand)** | `#7C5CFF` | Selected/active states, key buttons, links, progress, brand emphasis. Dark variant `#6A4BF0`. Tint bg `#EDE9FF`, soft tint `#F1ECFF` / `#F4F2FB`. |
| **Success** | `#14D9C4` | Completed tasks, confirm CTAs, "logged" state. Deep `#0FA697`/`#0FBDAD`. On-light text `#0FA697`. Tint `#E2FBF6`. Gradient `#17E2CD → #0FBDAD`. |
| **Accent (sparing)** | `#FF5B72` | Destructive (Log Out), Parent badge, one warm feature banner. **Never** used as primary. Gradient `#FF7E6B → #FF5B72`. Tint `#FFE7EC`, text `#E25069`. |
| **Warn/info** | `#FFC93C` | Pending badge, "Latest" stat. Tint `#FFF1DD`/`#FFF3D4`, text `#A9750E`/`#E8910E`. |
| **Ink (text)** | `#211E40` | Primary text. |
| **Muted text** | `#8B89A6` | Secondary text. Also `#9A98B6`, `#6E6B8C`. |
| **App background** | `#FBFAFF` | Screen background. |
| **Card** | `#FFFFFF` | Card surface. |
| **Borders** | `#ECEAF4` / `#EEEDF6` / `#EFEDF6` | Hairlines & card borders. |

**Avatar tile palette** (playful, brand-harmonized): violet `#7C5CFF`, mint `#14D9C4`, gold `#FFC93C`, coral `#FF5B72`, green `#5BD17A`, blue `#4CA9F5`.

### Typography
- **Font:** Plus Jakarta Sans (weights 400/500/600/700/800). Fallback `system-ui, sans-serif`.
- Screen title: 28px / 800 / letter-spacing −0.6px
- Detail H1: 27px / 800 / −0.6px / line-height 1.15
- Section header: 17px / 800 / −0.2px
- Card title: 15–16px / 700–800
- Body: 14.5–15px / 500 / line-height 1.5
- Meta / caption: 12–13px / 600
- Badge / pill: 11–13px / 800
- Nav label: 11px / 700
- Big numerals (79%, "14"): 34–40px / 800 / tight tracking, tabular where it's a timer.

### Radius
Phone frame 44 · cards 20–26 · hero 24–26 · pills & badges 999 · icon tiles 13–16 · filter chips 999.

### Shadows
- Card: `0 6px 18px rgba(33,30,64,.05)`
- Elevated / nav: `0 16px 36px rgba(33,30,64,.16)`
- Colored CTA: `0 12–16px 24–30px <accent>@0.3–0.4` (e.g. `0 16px 30px rgba(124,92,255,.38)`)

### Layout / frame
- Design canvas per screen: **392 × 812** px.
- Status bar height 48px (time left, signal/wifi/battery right). Content starts at y=48.
- Horizontal screen padding: 18–22px. Vertical gaps between blocks: 12–18px.
- Floating bottom nav: 16px side padding, ~16px from bottom, sits above content with a `#FBFAFF`→transparent fade behind it.

---

## Screens / Views

### 1. Home (`reference_flat/01_home.html`, `InsideOut Home.dc.html`)
Composed of reusable blocks (each its own component):
- **Header** — 46px gradient avatar tile (violet→mint) with initial, "Good morning" / name, two 44px rounded action chips (search, bell with coral dot).
- **Banner** — coral gradient nudge card, title + subtitle, gold pill with **live countdown** `mm:ss` (ticks每second, loops at 0).
- **MoodCard** — navy `#232048` hero, radius 26. "Daily check-in" pill + gold streak badge; 92px mint circle (smile icon); "How are you feeling today?"; **row of 5 selectable mood dots** (Great/Good/Okay/Low/Rough, colors mint/green/gold/orange/coral); white footer pill with mint "Log my mood" button + avatar stack + "1,204 checked in".
- **ChildModeCard** — soft violet card, icon tile, title + subtitle, **toggle switch** (mint when on).
- **Upcoming tasks** — section header + 3 TaskCards (icon tile + title + subtitle + trailing state: time pill / "Remind me" / done check).
- **BottomNav** — see below.

### 2. Tasks (`IO Tasks.dc.html`)
- Title "Tasks" (28/800).
- **Weekly Progress hero** — violet gradient `#7C5CFF→#6A4BF0`, radius 24: "Weekly Progress" label, "11 of 14 tasks completed" (21/800), "79%" (34/800), progress bar (track `rgba(255,255,255,.22)`, fill white at 79%).
- **Filter chips** — All (active: violet bg, white text), Pending, Completed (inactive: white, border `#ECEAF4`).
- **Task cards** (radius 20, 5px left accent bar):
  - *Completed:* mint accent + 40px mint check tile, **strikethrough** title (`#9A98B6`), "Completed · Jun 11" in `#0FA697`, mint "Completed" badge (`#E2FBF6`/`#0FA697`).
  - *Pending:* violet accent + 40px violet **dashed** tile (empty), ink title, "Due today · 6:00 PM", gold "Pending" badge (`#FFF3D4`/`#A9750E`).
- BottomNav with **Tasks** active.

### 3. Task Detail (`IO TaskDetail.dc.html`)
- Back chip (42px, `#ECEAF6`) + "TASK DETAIL" overline.
- H1 task name (27/800).
- **Completion banner** — mint tint `#E2FBF6`, border `#B6F0E6`: 48px mint check circle + "Task Completed" (`#0E8F82`) / "Completed on Jun 11" (`#23A597`).
- **Description** — section label with 4px violet accent bar; body in `#F4F2FB` rounded card.
- **Timeline** — two nodes connected by a 2px line: "Assigned" (violet dot `#7C5CFF`, ring `#E4DCFB`) Jun 11 / "Completed" (mint dot `#14D9C4`, ring `#C8F5EE`) Jun 11, right-aligned dates.
- **Sticky footer** — mint "Task completed" button.

### 4. Reports (`IO Reports.dc.html`)
- Back chip + "Reports".
- "Session Overview" + **stat grid**: large mint card (`#E2FBF6`, bar-chart icon, "14" / "Total Reports"); right column = gold card (`#FFF1DD`, calendar, "Jun 13" / "Latest") + pink card (`#FFE7EC`, person, "DR Omnia…" / "Specialist").
- **Feature banner** — coral gradient, "14 Reports" / "From Poly sessions with HOSS" + 72px translucent robot circle. *(The one allowed coral feature moment.)*
- "Session Reports" — list rows: 10px mint status dot, "Jun 13" / "DR Omnia Nasr", chevron-down (expandable intent), 1px top borders.

### 5. Profile (`IO Profile.dc.html`)
- Title "Profile".
- **Profile card** — 64px mint gradient avatar (smile), "HOSS" / "12 years old", mint "Child" badge; footer strip (`#F6F5FB`) "Case: **ADHD**" with brain icon.
- **Care Team** — two cards: Anas (coral "A" avatar, coral "Parent" badge, "Primary caregiver") · DR Omnia Nasr (violet briefcase, violet "Specialist" badge, "Child psychologist").
- **Menu rows** — Help & FAQ, Terms & Conditions, Privacy Policy, About App (violet icon tiles, chevron-right), **Log Out** (coral icon + coral label = destructive). 1px dividers.
- BottomNav with **Profile** active.

### 6. Avatar / Poly (`IO Avatar.dc.html`)
- Background gradient `#EFEBFF → #E7F6F3`.
- Back chip + "EN" language chip (top).
- **Poly mascot = placeholder** (128px dashed rounded tile labeled "Poly mascot"). **Drop the real mascot art here** — it is intentionally a slot.
- **Speech bubble** (white, tail up) — greeting; updates on selection to "Yay! Let's do <activity>."
- **Activity grid** — 2 columns × 3 rows of solid-color tiles (icon in translucent circle + label). Tap selects (white 3px border + ring + check badge top-right). Gold tile uses dark text `#3A2E12`; others white.
- **"Surprise me"** — violet gradient button with dice icon; picks a random activity and updates the bubble.

### Bottom navigation (`IO BottomNav.dc.html`) — shared
- Floating white pill, radius 28, 4 **equal** tabs: **Explore · Tasks · Chat · Profile** (compass / list-checks / message / user icons). **No center FAB.**
- Active tab: icon sits in a violet pill (`#EDE9FF` bg, `#7C5CFF` icon), label `#7C5CFF`. Inactive: `#9A98B6`.
- Prop: `active` ∈ {explore, tasks, chat, profile}.

---

## Interactions & Behavior
- **Mood dots** (Home): single-select; selected dot grows to 48px, fills with its color, gets a 3px ring; label turns white/bold.
- **Log my mood**: sets logged state → button label "Logged today", bg `#0FBFAE`, shows check icon.
- **Banner countdown**: decrement 1s; format `mm:ss`; loop back to start at 0.
- **Child Mode toggle**: knob translateX 0↔22px, track `#D9D6EA`↔`#14D9C4`, ~0.22s transition.
- **Filter chips** (Tasks): single-select; active = violet solid.
- **Activity tiles** (Avatar): single-select; selected gets white border + ring + check badge; bubble text updates.
- **Surprise me**: random index → same selected styling + bubble update.
- **Bottom nav**: tap switches active tab (visual only here; wire to your router).
- Transitions are subtle (0.18–0.22s ease) on selection/toggle states.

## State Management
- `mood.selectedIndex` (0–4, default 1) and `mood.logged` (bool)
- `childMode.on` (bool)
- `banner.secondsLeft` (number, ticking)
- `nav.active` ('explore' | 'tasks' | 'chat' | 'profile')
- `avatar.selectedIndex` (0–5 or null)
- Data lists: tasks (title, subtitle, done), reports (date, who), care team, menu items — currently static placeholder data; wire to your real sources.

## Assets
- **Icons:** all inline SVG, Lucide-style (stroke 2, round caps): search, bell, compass, list-checks, message-circle, user, smile, flame, clock, calendar, bar-chart, briefcase, brain, shield, file-text, info, log-out, eye, heart, layers, sparkles/star, dice, chevrons, check. Substitute your icon library's equivalents.
- **Poly mascot:** intentionally a **placeholder slot** on the Avatar screen — supply the real illustration.
- **Avatars:** placeholder gradient circles / initials — replace with real images.
- **Fonts:** Plus Jakarta Sans (Google Fonts). Swap for the codebase's font if it has an established one.

## Files
- `reference_flat/01_home.html` — flattened Home + component library (exact styles).
- `reference_flat/02_screens.html` — flattened Tasks, Task Detail, Reports, Profile, Avatar (exact styles).
- `source_components/*.dc.html` — original components (read for interaction logic & state).

## Notes
- **Color discipline is the key rule:** violet `#7C5CFF` is the *only* primary; mint = success; coral = sparing accent (don't let coral become a second primary).
- All spacing/sizing in the references is in CSS px on a 392-wide frame — scale to your device metrics.
- Keep hit targets ≥ 44px (nav, chips, toggles already comply).
