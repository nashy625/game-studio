# Nashy Game Studio Arcade

A native macOS SpriteKit arcade app containing three small portfolio games:

- **One Button Samurai**: press Space to dash, parry close calls, build focus, and survive the ambush.
- **Micro Dungeon**: use WASD or arrow keys to clear three procedural tactical floors with traps, relics, armor, and upgrades.
- **Stock Market Survivor**: buy, sell, or hold through timed market shocks and protect your portfolio for 30 days.
- **Neon Pong Royale**: use W/S or arrow keys to win a first-to-seven paddle duel.

## Why This Exists

This repo is the start of a small native game studio pipeline: build compact,
finished desktop games for portfolio demos, then polish the strongest concepts
toward Steam-ready releases.

## Run in Development

```bash
swift run GameStudioApp
```

## Build

```bash
swift build
```

## Package as a macOS App

```bash
./scripts/package-macos.sh
```

The packaged app is written to:

```text
dist/Nashy Game Studio Arcade.app
```

## Controls

- `Esc`: return to the game menu.
- `R`: restart the active game.
- One Button Samurai: `Space` for dash, parry, and focus strike.
- Micro Dungeon: `WASD` or arrow keys.
- Stock Market Survivor: `B` to buy, `S` to sell, `H` to hold.
- Neon Pong Royale: `W/S` or arrow keys.
