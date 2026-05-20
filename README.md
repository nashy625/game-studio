# Nashy Game Studio Arcade

A native macOS SpriteKit arcade app containing three small portfolio games:

- **One Button Samurai**: press Space to dash through incoming enemies. Win at 30 cuts.
- **Micro Dungeon**: use WASD or arrow keys to clear three tactical dungeon floors.
- **Stock Market Survivor**: buy and sell through 30 days of chaotic market events.

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
- One Button Samurai: `Space`.
- Micro Dungeon: `WASD` or arrow keys.
- Stock Market Survivor: `B` to buy, `S` to sell.
