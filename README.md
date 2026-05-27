# Nashy Game Studio Arcade

A native macOS SpriteKit arcade app containing eight small portfolio games:

- **One Button Samurai**: press Space to dash, parry close calls, build focus, and survive the ambush.
- **Micro Dungeon**: use WASD or arrow keys to clear three procedural tactical floors with traps, relics, armor, and upgrades.
- **Stock Market Survivor**: buy, sell, or hold through timed market shocks and protect your portfolio for 30 days.
- **Neon Pong Royale**: use W/S or arrow keys to win a first-to-seven paddle duel.
- **Campus Dash**: collect notes, dodge bikes, and reach class before the timer runs out.
- **Brickforge Breakout**: clear three forge stages with paddle control, heat splits, and multiball pressure.
- **Starforge Courier**: collect cargo, dodge asteroids, and complete six deliveries before oxygen runs out.
- **Rhythm Forge**: hit A/S/D/F lanes on beat, build combo, and clear a 32-note timing set.

## Why This Exists

This repo is the start of a small native game studio pipeline: build compact,
finished desktop games for portfolio demos, then polish the strongest concepts
toward Steam-ready releases.

The arcade shell uses a Steam-inspired library menu with capsule-style game
cards, genre labels, and release-build positioning so the collection reads like
an indie store shelf rather than a loose prototype folder.

## Steam-Ready Polish Pass

The current shell is focused on making the collection feel presentable before
adding more prototypes:

- store-style capsule cards for every game
- playable status chips and short session-length labels
- richer generated capsule art for each prototype
- release-track positioning for the strongest games
- packaged macOS app output for portfolio demos

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
- Campus Dash: `WASD` or arrow keys.
- Brickforge Breakout: `A/D` or arrows to move, `Space` for heat split.
- Starforge Courier: `WASD` or arrows to fly.
- Rhythm Forge: `A/S/D/F` to strike lanes.
