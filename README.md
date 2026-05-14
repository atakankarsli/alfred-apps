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

Alfred runs as a background service on macOS, connected to Telegram. The user sent natural language requests like "make me a puzzle game" or "build 20 apps in 20 days." Alfred autonomously researched, designed, coded, built, fixed errors, and sent back simulator screenshots — all through chat.

## Evolution: How Alfred Learned to Build Apps

### Phase 1: One-at-a-time, heavy debugging (Feb 27 – Mar 4)

The first 3 apps (ColorFlow → Lumina → NOVA) were iterative rewrites of the same project. Each required significant debugging: missing types, broken views, SwiftData schema crashes, environment setup issues. Alfred would write code, hit 5–10 compile errors, fix them one by one, and often break something else in the process.

**Key struggle:** Full-file rewrites would accidentally delete shared components (FloatingOrbsView, BounceButtonStyle) defined at the bottom of HomeView.swift.

### Phase 2: Template discovery, batch production (Mar 8–9)

The user asked for 8 apps built from a shared base. Alfred copied ColorFlow's project structure and adapted it per app. This was the breakthrough — a reusable skeleton with known file layout. Production speed jumped from 1 app/day to 4 apps/day.

**Key insight:** Alfred started recognizing its own recurring errors (AppTheme vs Theme, bestStreak vs longestStreak) and pre-emptively avoiding them.

### Phase 3: Scheduled automation, 20-day marathon (Mar 9 – Apr 28)

The user scheduled 60 cron tasks (3 per day: research, build, polish). Alfred ran autonomously — morning research with web search and competitor analysis, afternoon builds, evening polish. By Day 5+, most apps compiled on the first try.

**Key evolution:** Alfred went from "write everything → build → fix 8 errors → build again" to "write everything correctly the first time → build → 0 errors."

## What Went Wrong (Recurring Failures)

| Problem | Frequency | Root Cause |
|---------|-----------|------------|
| SwiftUI "expression too complex" | Every 2–3 apps | Nested view builders exceeding Swift's type checker limits |
| Shared components lost on file rewrite | First 10 apps | Components co-located at bottom of HomeView.swift, deleted during full rewrites |
| Type name mismatches | Every new app | Inconsistent naming between model layer and views (Theme vs AppTheme, etc.) |
| Stale scheduled task cache | Ongoing | In-memory scheduler kept firing old prompts after DB updates |
| Context window exhaustion | ~10 times | Sessions grew past 120K tokens, SDK threw "prompt is too long" |
| Simulator screenshot failures | Occasional | Headless simulator can't tap UI elements — required code workarounds |
| @MainActor concurrency errors | Early apps | `deinit` can't reference `@MainActor` properties, `Task { [weak self] }` patterns |

## What Should Have Been Done Differently

**1. Extract a real project template early.** Alfred kept copying ColorFlow and manually renaming things. A proper Xcode template with placeholder names would have eliminated the entire class of type-name mismatch errors.

**2. Shared components in their own files from Day 1.** FloatingOrbsView and BounceButtonStyle being at the bottom of HomeView.swift caused repeated breakage. Moving them to dedicated files would have been a 5-minute fix that saved hours of debugging.

**3. Build before writing all files.** Alfred's pattern was: write 30+ Swift files → build → fix errors. A better approach: write the core model + one view → build → add views incrementally. Catch errors early instead of debugging 8 failures at once.

**4. Session management.** The 20-app marathon ran in a single growing session that repeatedly hit context limits. Should have started a fresh session per app from the beginning. (This was later fixed in Alfred's core with auto-compaction at 70% and overflow recovery.)

**5. Scheduled task architecture.** The cron scheduler cached prompts in memory and didn't pick up DB changes. This caused massive noise — dozens of stale tasks firing alongside new ones. Needed a cache-invalidation mechanism or DB-only reads.

**6. Validate UI, not just compilation.** Alfred verified "0 errors, 0 warnings" but rarely checked if screens were actually reachable. Multiple apps had unreachable views (e.g., SHARD's Lab screen had no navigation path from HomeView). A simple "can I navigate to every screen?" check would have caught these.
