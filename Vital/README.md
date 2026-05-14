# Lumina

A beautiful lights-out puzzle game for iOS. Tap cells to toggle them and their neighbors — light up every cell to solve the puzzle.

## Features

- **Lights Out Puzzles** — Tap a cell to toggle it and its 4 neighbors. Light up every cell to win.
- **100 Levels** — Progressive difficulty from 3x3 to 7x7 grids
- **Star Rating** — Earn up to 3 stars based on move efficiency vs par
- **Musical Feedback** — Each cell plays a pentatonic bell note when toggled
- **Daily Puzzles** — Fresh puzzle every day
- **Quick Play** — Endless random puzzles
- **Undo & Hints** — Unlimited undo and hint system
- **10 Themes** — Beautiful light & dark visual themes with glass effects
- **Haptic Feedback** — Tactile response for every interaction

## Tech Stack

- SwiftUI + MVVM
- SwiftData for persistence
- `@Observable` ViewModels
- Procedural sound synthesis (no audio files)
- iOS 18+

## Building

Open `ColorFlow.xcodeproj` in Xcode and run on a simulator or device.
