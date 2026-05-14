# Alfred Apps

29 iOS apps built autonomously by [Alfred](https://github.com/atakankarsli/alfred) — a personal AI assistant running Claude Opus via the Agent SDK. All apps were designed, researched, and coded by Alfred through Telegram conversations over ~2 months (Feb–Apr 2026).

Every app is a standalone SwiftUI project. Each was built from scratch with its own game mechanics, progression system, achievements, and visual identity. **30 out of 31 compiled with zero errors on first or second attempt.**

## Apps

### Originals (Feb 2026)

| App | Description | Files |
|-----|-------------|-------|
| **ColorFlow** | Color tile swapping puzzle | 37 |
| **Lumina/NOVA** | Chain reaction puzzle — cells explode at critical mass, cascade across the grid | 37 |

### Series 1: Daily Life Games (Mar 2026)

| App | Description | Files |
|-----|-------------|-------|
| **BLOOM** | Emotional garden — plant grows based on mood, 8 emotions × 4 seasons | 37 |
| **VITAL** | 2-minute health mini-games (Speed Tap, Memory Flash, Rhythm Pulse, Reflex Hunt) | 31 |
| **MUSE** | 60-second creative prompts across drawing, writing, music, photo | 36 |
| **QUEST** | Daily real-world exploration missions with GPS | 33 |
| **RITUAL** | Morning habit flow with sensory guidance | 37 |
| **TRACE** | Memory pattern puzzle with spatial recall | 37 |
| **LOCUS** | AR memory palace for spatial learning | 37 |
| **IMPRINT** | Daily snapshot mosaic — build a visual diary | 37 |

### Series 2: 20 Apps in 20 Days (Mar–Apr 2026)

| # | App | Description | Files |
|---|-----|-------------|-------|
| 1 | **CIPHER** | Cryptography puzzle — 8 cipher types (Caesar to Vigenère), 4 vaults, 80 levels | 37 |
| 2 | **DRIFT** | Ambient soundscape mixer | 37 |
| 3 | **NEXUS** | Semantic word connection web | 37 |
| 4 | **ORBIT** | Gravity playground — orbital mechanics puzzles | 37 |
| 5 | **PRISM** | Color theory puzzles — RGB/HSL mixing challenges | 37 |
| 6 | **VERSE** | Poetry engine — arrange word tiles into haiku and sonnets | 38 |
| 7 | **FLUX** | Fluid dynamics toy | 35 |
| 8 | **ATLAS** | World geography quiz | 33 |
| 9 | **GLYPH** | Symbol drawing/calligraphy challenges | 35 |
| 10 | **TIDAL** | Wave interference physics puzzles | 39 |
| 11 | **ECHO** | Audio sequence memory (Simon-like) | 37 |
| 12 | **MORPH** | Shape transformation / tangram puzzles | 36 |
| 13 | **ZENITH** | Constellation finder | 37 |
| 14 | **RUNE** | Ancient script decoder — hieroglyphics, runic alphabets | 35 |
| 15 | **EMBER** | Flame-focus meditation and breathing | 35 |
| 16 | **AETHER** | Element combiner (Little Alchemy-style) | 33 |
| 17 | **HELIX** | DNA sequence puzzle | 33 |
| 18 | **PULSE** | Rhythm tapping game | 33 |
| 19 | **SHARD** | Crystal growing simulator — 13 types, temperature/pressure mechanics | 33 |
| 20 | **VOLT** | Circuit builder puzzle | 32 |

## Stats

- **Total:** 29 app folders, ~1,030 Swift files
- **Build success rate:** ~97% (30/31 clean builds)
- **Period:** February 27 – April 28, 2026
- **Builder:** Alfred (Claude Opus via Agent SDK)
- **Interface:** Telegram group chat
- **Zero human code written** — all code authored by Alfred

## How It Was Built

Alfred runs as a background service on macOS, connected to Telegram. The user sent natural language requests like "make me a puzzle game" or "build 20 apps in 20 days" and Alfred autonomously:

1. Researched competitors and game mechanics (web search)
2. Designed the architecture and progression systems
3. Wrote all Swift/SwiftUI code
4. Built with `xcodebuild`
5. Fixed any compile errors
6. Took simulator screenshots and sent them back via Telegram
