<div align="center">

<img src="assets/illustrations/appIconLightMode.png" alt="inside-out logo" width="120" />

# inside-out 🧸

### Meet **Dooby** — an AI bear that helps neurodiverse children practice therapy tasks through play.

A Flutter app for children aged **3–10** with autism, Down syndrome, or speech difficulties. Specialists assign therapy tasks; Poly turns them into friendly, voice-driven conversations and quietly reports back on the child's speech, emotion, and progress.

<br/>

[![Total Commits](https://img.shields.io/github/commit-activity/t/AnasNasr-afk/inside-out?style=for-the-badge&logo=git&logoColor=white&label=Total%20Commits&color=6C5CE7)](https://github.com/AnasNasr-afk/inside-out/commits)
[![Last Commit](https://img.shields.io/github/last-commit/AnasNasr-afk/inside-out?style=for-the-badge&logo=github&label=Last%20Commit&color=00B894)](https://github.com/AnasNasr-afk/inside-out/commits)
[![Top Language](https://img.shields.io/github/languages/top/AnasNasr-afk/inside-out?style=for-the-badge&logo=dart&logoColor=white&color=0175C2)](https://github.com/AnasNasr-afk/inside-out)
[![Repo Size](https://img.shields.io/github/repo-size/AnasNasr-afk/inside-out?style=for-the-badge&logo=files&logoColor=white&color=FD79A8)](https://github.com/AnasNasr-afk/inside-out)

[![Claude Code Tokens](https://img.shields.io/badge/Built%20with%20Claude%20Code-~720M%20tokens-D97757?style=for-the-badge&logo=anthropic&logoColor=white)](https://claude.com/claude-code)

</div>

---

## 🎬 Demo

<div align="center">

  
[![Watch the demo](https://img.shields.io/badge/▶_Watch_the_Demo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://drive.google.com/file/d/1ZuhQnwiSW1_Qi8YFHEMC4HHDkRcVpWHX/view?usp=sharing)

</div>

---

## 📸 Screenshots

> _Placeholders below._ Add your images to `docs/screenshots/` (filenames shown) and they'll render automatically.

<div align="center">

| Onboarding | Poly Avatar | Spin Wheel |
|:---:|:---:|:---:|
| <img src="docs/screenshots/onboarding.png" width="220" alt="Onboarding" /> | <img src="docs/screenshots/poly.png" width="220" alt="Poly avatar" /> | <img src="docs/screenshots/wheel.png" width="220" alt="Task wheel" /> |
| **Daily Check-in** | **Tasks** | **Session Report** |
| <img src="docs/screenshots/checkin.png" width="220" alt="Daily check-in" /> | <img src="docs/screenshots/tasks.png" width="220" alt="Tasks" /> | <img src="docs/screenshots/report.png" width="220" alt="Report" /> |

</div>

---

## ✨ Features

- 🐻 **Poly, the AI bear** — a Rive-animated character that listens, talks, and reacts in real time.
- 🗣️ **Voice-first conversations** — speech-to-text in, Google Cloud TTS out; Poly speaks back to the child.
- 🎡 **Spin-the-wheel tasks** — specialist-assigned therapy tasks turned into a playful picker.
- 🧠 **GPT-4o mini brain** — child-safe persona, per-turn emotion + language awareness, capped conversation memory.
- 🌍 **Multi-language** — Poly adapts language and voice to the child.
- 📊 **Automatic session reports** — speech clarity, sentence quality, emotion, and concerns summarized for the specialist.
- 🌗 **Daily mood check-in** — mood is attached to the parent's task-completion note.
- 💬 **Specialist chat** — in-app messaging via Sendbird.
- 🔔 **Push notifications** — Firebase Cloud Messaging for task and specialist updates.
- 🔐 **Auth** — Firebase Auth with Google Sign-In.

---

## 🛠️ Tech Stack

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![OpenAI](https://img.shields.io/badge/OpenAI_GPT--4o_mini-412991?style=for-the-badge&logo=openai&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Cloud_TTS-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)
![Rive](https://img.shields.io/badge/Rive-1D1D1D?style=for-the-badge&logo=rive&logoColor=white)

</div>

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart SDK `>=3.6.0`) |
| **State management** | Riverpod (AI avatar) + BLoC / Cubit (rest of app) + `get_it` |
| **AI / NLP** | OpenAI GPT-4o mini (via HTTP) |
| **Voice** | `speech_to_text` (STT) · Google Cloud TTS + `just_audio` (TTS) |
| **Animation** | Rive (`bear_character.riv`) · Lottie · `flutter_svg` |
| **Backend & data** | Firebase Auth · Cloud Firestore · Firebase Messaging |
| **Chat** | Sendbird Chat SDK |
| **Auth** | Firebase Auth · Google Sign-In |
| **Local storage** | `shared_preferences` · `path_provider` |
| **Serialization** | `dart_mappable` |
| **Tooling** | `build_runner` · `flutter_gen` · `custom_lint` · `riverpod_lint` |

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── cubits/          # BLoC cubits (auth, avatar, task)
│   ├── models/          # models + requests/ + responses/
│   ├── networking/      # api_client + repositories/
│   ├── routing/         # app_router + routes
│   ├── services/        # notifications
│   ├── theme/ · widgets/ · helpers/ · env/
├── ai_avatar/           # Poly feature (Riverpod) — avatar screen, AI repo, TTS
├── presentation/        # auth · chat · child_mood · games · home ·
│                        # notification · on_boarding · poly_missions ·
│                        # profile · reports · tasks
└── main.dart
```

**Poly's session state machine:** `idle → greeting → listening → processing → responded`

**AI prompt design:** a system persona primes Poly's character and language rules; the specialist's task description is injected once per session; each turn adds the child's emotion, language, and profile. Conversation history is capped at 10 messages to control cost and latency.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.6.0`
- A Firebase project (Auth, Firestore, Messaging)
- An OpenAI API key
- A Google Cloud API key with the Text-to-Speech API enabled

### Setup

```bash
# 1. Clone
git clone https://github.com/AnasNasr-afk/inside-out.git
cd inside-out

# 2. Install dependencies
flutter pub get

# 3. Generate code (mappers, Riverpod, assets)
dart run build_runner build --delete-conflicting-outputs

# 4. Run
flutter run
```

### Environment

Create a `.env` file in the project root:

```env
OPENAI_API_KEY=your_openai_key
GOOGLE_TTS_API_KEY=your_google_cloud_key
```

Add your Firebase config (`google-services.json` / `GoogleService-Info.plist`) and ensure `firebase_options.dart` is generated via `flutterfire configure`.

---

## 📂 Assets to add

To complete this README, drop the following in:

- `docs/screenshots/` → `onboarding.png`, `poly.png`, `wheel.png`, `checkin.png`, `tasks.png`, `report.png`
- A demo video link (YouTube/Loom) or a GitHub-hosted `.mp4` in the **Demo** section

---

<div align="center">

Built with 🧸 and Flutter by **[Anas Nasr](https://github.com/AnasNasr-afk)**

</div>
