# BetterYou

A gamified iOS fitness tracking app built with SwiftUI and SwiftData. Log workouts, complete daily and weekly quests, earn XP and coins, level up, and unlock avatars, badges, and power-ups in the in-app Store.

## Features

- **Workout Logging** — Strength, Cardio, Bodyweight, and Custom workout types with sets/reps/weight tracking
- **Quest System** — 3 daily + 3 weekly quests that auto-refresh, with progress tracking
- **XP & Leveling** — Earn XP from workouts (+50) and quests (+100/+250), level up every 500 XP
- **Coin Economy** — Earn coins alongside XP; spend them in the Store without affecting your level
- **Store** — 8 avatars, 8 badges/titles, and Streak Freeze power-ups
- **Stats Dashboard** — Total workouts, time, volume; weekly progress; per-type breakdown; body weight chart (Swift Charts)
- **Profile Customization** — Equip owned avatars and titles, edit display name and body weight
- **Dark Neon Theme** — Gaming-inspired UI with glowing accents, rounded cards, and celebration animations

## Requirements

- Xcode 15+ (built with Xcode 16)
- iOS 17.0+ deployment target
- No third-party dependencies

## Build & Run

1. Open `BetterYou.xcodeproj` in Xcode.
2. Select an iPhone simulator (e.g., iPhone 15).
3. Press **Cmd+R** to build and run.

The app seeds initial data on first launch — a default user profile, the store catalog, and 6 quests.

## Architecture

```
BetterYou/
  BetterYouApp.swift              App entry point, SwiftData container setup
  Theme/
    AppTheme.swift                Colors, fonts, layout constants
    ViewModifiers.swift           .neonGlow(), .surfaceCard() modifiers
  Models/
    UserProfile.swift             Singleton user — XP, level, coins, streak
    Workout.swift                 Logged workout with embedded SetEntry array
    Quest.swift                   Daily/weekly quest with progress tracking
    StoreItem.swift               Purchasable avatar, badge, or power-up
    WeightLog.swift               Body weight log entry
    Enums.swift                   WorkoutType, QuestCadence, TargetMetric, etc.
  Services/
    XPEngine.swift                XP/coin awards, level calculation, purchases
    QuestEngine.swift             Quest refresh and progress recomputation
    SeedData.swift                Quest templates, store catalog, bootstrap
  Screens/
    Root/RootTabView.swift        5-tab navigation shell
    Home/HomeView.swift           Level ring, XP/streak pills, quest preview
    Home/LevelRingView.swift      Animated XP progress ring
    Quests/QuestsView.swift       Daily/Weekly segmented quest list
    Quests/QuestCardView.swift    Individual quest card with progress bar
    Quests/LogWorkoutSheet.swift  Workout creation form
    Stats/StatsView.swift         KPI cards, weekly bar, type breakdown
    Stats/WeightChartView.swift   Swift Charts line chart for body weight
    Store/StoreView.swift         Sectioned store with coin balance
    Store/StoreItemCard.swift     Buy/Owned/Equipped item row
    Profile/ProfileView.swift     Avatar/title pickers, settings, reset
    Profile/AvatarPickerView.swift Grid of owned avatars
  Components/
    PrimaryButton.swift           Reusable neon CTA button
    ProgressBar.swift             Animated progress bar
    GlowingBadge.swift            Circular level badge with ring
    LevelUpSheet.swift            Celebration modal on level-up
  Preview Content/
    PreviewSampleData.swift       In-memory sample data for Xcode previews
```

## Game Mechanics

| Action | XP | Coins |
|---|---|---|
| Log a workout | +50 | +10 |
| Complete daily quest | +100 | +25 |
| Complete weekly quest | +250 | +60 |

**Leveling:** Level N requires N x 500 lifetime XP. Every 5th level grants a bonus Streak Freeze.

**Store:** Coins are separate from XP — spending coins does not reduce your level.

## Team

- **Surya Prakash Seth** (230907028)
- **Naman Ahuja** (230961174)

CSE 4456 — iOS Application Development, MIT Manipal, Spring 2026
