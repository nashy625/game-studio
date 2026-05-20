import AppKit
import Foundation
import GameplayKit
import SpriteKit

private let appSize = CGSize(width: 1040, height: 680)

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!
    private var skView: GameSKView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)

        skView = GameSKView(frame: CGRect(origin: .zero, size: appSize))
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = false

        window = NSWindow(
            contentRect: CGRect(origin: .zero, size: appSize),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Nashy Game Studio Arcade"
        window.center()
        window.contentView = skView
        window.makeKeyAndOrderFront(nil)

        presentMenu()
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    private func presentMenu() {
        let scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.onSelect = { [weak self] game in
            self?.presentGame(game)
        }
        skView.presentScene(scene, transition: .crossFade(withDuration: 0.25))
    }

    private func presentGame(_ game: GameKind) {
        let scene: BaseGameScene
        switch game {
        case .samurai:
            scene = SamuraiScene(size: skView.bounds.size)
        case .dungeon:
            scene = DungeonScene(size: skView.bounds.size)
        case .stocks:
            scene = StockScene(size: skView.bounds.size)
        }
        scene.scaleMode = .resizeFill
        scene.onExit = { [weak self] in
            self?.presentMenu()
        }
        skView.presentScene(scene, transition: .push(with: .left, duration: 0.22))
    }
}

final class GameSKView: SKView {
    override var acceptsFirstResponder: Bool { true }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.makeFirstResponder(self)
    }
}

enum GameKind: String, CaseIterable {
    case samurai
    case dungeon
    case stocks

    var title: String {
        switch self {
        case .samurai: return "One Button Samurai"
        case .dungeon: return "Micro Dungeon"
        case .stocks: return "Stock Market Survivor"
        }
    }

    var subtitle: String {
        switch self {
        case .samurai: return "Dash through raiders with one perfectly timed strike."
        case .dungeon: return "Clear tiny tactical floors before your hearts run out."
        case .stocks: return "Trade through chaos and survive the closing bell."
        }
    }

    var accent: NSColor {
        switch self {
        case .samurai: return NSColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1)
        case .dungeon: return NSColor(calibratedRed: 0.15, green: 0.78, blue: 0.49, alpha: 1)
        case .stocks: return NSColor(calibratedRed: 0.16, green: 0.55, blue: 0.95, alpha: 1)
        }
    }
}

extension SKColor {
    static let ink = SKColor(calibratedRed: 0.05, green: 0.06, blue: 0.08, alpha: 1)
    static let panel = SKColor(calibratedRed: 0.10, green: 0.12, blue: 0.15, alpha: 1)
    static let bone = SKColor(calibratedRed: 0.92, green: 0.90, blue: 0.82, alpha: 1)
    static let gold = SKColor(calibratedRed: 0.98, green: 0.72, blue: 0.24, alpha: 1)
}

func label(_ text: String, size: CGFloat, color: SKColor = .bone, weight: NSFont.Weight = .bold) -> SKLabelNode {
    let node = SKLabelNode(fontNamed: "AvenirNext-\(weight == .bold ? "Bold" : "Medium")")
    node.text = text
    node.fontSize = size
    node.fontColor = color
    node.verticalAlignmentMode = .center
    return node
}

func roundedRect(size: CGSize, radius: CGFloat, color: SKColor, stroke: SKColor? = nil, lineWidth: CGFloat = 2) -> SKShapeNode {
    let rect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
    let node = SKShapeNode(rect: rect, cornerRadius: radius)
    node.fillColor = color
    node.strokeColor = stroke ?? color
    node.lineWidth = lineWidth
    return node
}

final class MenuScene: SKScene {
    var onSelect: ((GameKind) -> Void)?
    private var cardFrames: [GameKind: CGRect] = [:]

    override func didMove(to view: SKView) {
        backgroundColor = .ink
        build()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        removeAllChildren()
        build()
    }

    private func build() {
        cardFrames.removeAll()
        let title = label("Nashy Game Studio", size: 46, color: .bone)
        title.position = CGPoint(x: size.width / 2, y: size.height - 86)
        addChild(title)

        let subtitle = label("Desktop arcade builds for portfolio and Steam prototypes", size: 18, color: SKColor.bone.withAlphaComponent(0.72), weight: .regular)
        subtitle.position = CGPoint(x: size.width / 2, y: size.height - 128)
        addChild(subtitle)

        let cardWidth = min(292, max(240, (size.width - 130) / 3))
        let cardSize = CGSize(width: cardWidth, height: 270)
        let spacing = min(34, max(18, (size.width - cardWidth * 3 - 80) / 2))
        let startX = size.width / 2 - cardWidth - spacing

        for (index, game) in GameKind.allCases.enumerated() {
            let x = startX + CGFloat(index) * (cardWidth + spacing)
            let y = size.height / 2 - 10
            cardFrames[game] = CGRect(x: x - cardSize.width / 2, y: y - cardSize.height / 2, width: cardSize.width, height: cardSize.height)

            let card = roundedRect(size: cardSize, radius: 8, color: .panel, stroke: game.accent, lineWidth: 3)
            card.position = CGPoint(x: x, y: y)
            addChild(card)

            let icon = SKShapeNode(circleOfRadius: 42)
            icon.fillColor = game.accent
            icon.strokeColor = .clear
            icon.position = CGPoint(x: x, y: y + 70)
            addChild(icon)

            let glyph = label(glyphFor(game), size: 38, color: .ink)
            glyph.position = icon.position
            addChild(glyph)

            let titleNode = label(game.title, size: 23, color: .bone)
            titleNode.position = CGPoint(x: x, y: y + 10)
            addChild(titleNode)

            let lines = wrapped(game.subtitle, max: 28)
            for (lineIndex, line) in lines.enumerated() {
                let lineNode = label(line, size: 14, color: SKColor.bone.withAlphaComponent(0.72), weight: .regular)
                lineNode.position = CGPoint(x: x, y: y - 30 - CGFloat(lineIndex) * 20)
                addChild(lineNode)
            }

            let cta = label("PLAY", size: 16, color: game.accent)
            cta.position = CGPoint(x: x, y: y - 98)
            addChild(cta)
        }

        let footer = label("Click a game. Press Esc inside any game to return.", size: 16, color: SKColor.bone.withAlphaComponent(0.58), weight: .regular)
        footer.position = CGPoint(x: size.width / 2, y: 46)
        addChild(footer)
    }

    override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        for (game, frame) in cardFrames where frame.contains(point) {
            onSelect?(game)
            return
        }
    }

    private func glyphFor(_ game: GameKind) -> String {
        switch game {
        case .samurai: return "!"
        case .dungeon: return "#"
        case .stocks: return "$"
        }
    }

    private func wrapped(_ text: String, max: Int) -> [String] {
        var lines: [String] = []
        var current = ""
        for word in text.split(separator: " ") {
            let candidate = current.isEmpty ? String(word) : "\(current) \(word)"
            if candidate.count > max {
                lines.append(current)
                current = String(word)
            } else {
                current = candidate
            }
        }
        if !current.isEmpty { lines.append(current) }
        return lines
    }
}

class BaseGameScene: SKScene {
    var onExit: (() -> Void)?
    let hud = SKLabelNode(fontNamed: "AvenirNext-Bold")
    let help = SKLabelNode(fontNamed: "AvenirNext-Medium")
    var isGameOver = false

    override func didMove(to view: SKView) {
        backgroundColor = .ink
        hud.fontSize = 22
        hud.fontColor = .bone
        hud.horizontalAlignmentMode = .left
        hud.verticalAlignmentMode = .center
        hud.position = CGPoint(x: 24, y: size.height - 32)
        addChild(hud)

        help.fontSize = 14
        help.fontColor = SKColor.bone.withAlphaComponent(0.68)
        help.horizontalAlignmentMode = .right
        help.verticalAlignmentMode = .center
        help.position = CGPoint(x: size.width - 24, y: size.height - 32)
        addChild(help)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        hud.position = CGPoint(x: 24, y: size.height - 32)
        help.position = CGPoint(x: size.width - 24, y: size.height - 32)
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {
            onExit?()
        }
    }

    func showEnd(title: String, detail: String, color: SKColor = .gold) {
        isGameOver = true
        let panel = roundedRect(size: CGSize(width: 500, height: 190), radius: 8, color: .panel, stroke: color, lineWidth: 3)
        panel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        panel.zPosition = 1000
        addChild(panel)

        let titleNode = label(title, size: 34, color: color)
        titleNode.position = CGPoint(x: size.width / 2, y: size.height / 2 + 42)
        titleNode.zPosition = 1001
        addChild(titleNode)

        let detailNode = label(detail, size: 18, color: .bone, weight: .regular)
        detailNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        detailNode.zPosition = 1001
        addChild(detailNode)

        let exitNode = label("Press R to restart or Esc for menu", size: 16, color: SKColor.bone.withAlphaComponent(0.68), weight: .regular)
        exitNode.position = CGPoint(x: size.width / 2, y: size.height / 2 - 46)
        exitNode.zPosition = 1001
        addChild(exitNode)
    }
}

final class SamuraiScene: BaseGameScene {
    private let player = SKShapeNode(circleOfRadius: 24)
    private let sword = SKShapeNode(rectOf: CGSize(width: 64, height: 8), cornerRadius: 3)
    private var enemies: [SKShapeNode] = []
    private var particles: [SKShapeNode] = []
    private var lastUpdateTime: TimeInterval = 0
    private var spawnTimer: TimeInterval = 0
    private var dashTimer: TimeInterval = 0
    private var dashCooldown: TimeInterval = 0
    private var score = 0
    private var streak = 0
    private var enemySpeed: CGFloat = 225

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        help.text = "Space: dash   R: restart   Esc: menu"
        player.fillColor = .bone
        player.strokeColor = SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1)
        player.lineWidth = 4
        player.position = CGPoint(x: 150, y: size.height / 2)
        addChild(player)

        sword.fillColor = .gold
        sword.strokeColor = .clear
        sword.position = CGPoint(x: 44, y: 0)
        sword.isHidden = true
        player.addChild(sword)
        updateHUD()
    }

    override func keyDown(with event: NSEvent) {
        if event.charactersIgnoringModifiers?.lowercased() == "r" {
            reset()
            return
        }
        if isGameOver {
            super.keyDown(with: event)
            return
        }
        if event.keyCode == 49 && dashCooldown <= 0 {
            dashTimer = 0.20
            dashCooldown = 0.55
            sword.isHidden = false
            player.run(.sequence([
                .scale(to: 1.28, duration: 0.06),
                .scale(to: 1.0, duration: 0.16)
            ]))
        }
        super.keyDown(with: event)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = min(currentTime - lastUpdateTime, 0.033)
        lastUpdateTime = currentTime
        if isGameOver { return }

        spawnTimer -= dt
        dashTimer -= dt
        dashCooldown -= dt
        if dashTimer <= 0 { sword.isHidden = true }
        if spawnTimer <= 0 {
            spawnEnemy()
            spawnTimer = max(0.42, 1.06 - Double(score) * 0.015)
        }

        let activeDash = dashTimer > 0
        for enemy in enemies {
            enemy.position.x -= (enemySpeed + CGFloat(score) * 4) * CGFloat(dt)
            if activeDash && enemy.frame.intersects(player.calculateAccumulatedFrame()) {
                kill(enemy)
            } else if enemy.frame.intersects(player.frame.insetBy(dx: 8, dy: 8)) {
                showEnd(title: "Cut Down", detail: "Final score: \(score)", color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
            } else if enemy.position.x < -60 {
                streak = 0
                enemy.removeFromParent()
            }
        }
        enemies.removeAll { $0.parent == nil || $0.position.x < -60 }
        updateParticles(dt)
        updateHUD()
    }

    private func spawnEnemy() {
        let enemy = SKShapeNode(rectOf: CGSize(width: 34, height: 44), cornerRadius: 5)
        enemy.fillColor = SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1)
        enemy.strokeColor = .clear
        let laneOffset = CGFloat([-120, -60, 0, 60, 120].randomElement() ?? 0)
        enemy.position = CGPoint(x: size.width + 40, y: size.height / 2 + laneOffset)
        addChild(enemy)
        enemies.append(enemy)
    }

    private func kill(_ enemy: SKShapeNode) {
        score += 1
        streak += 1
        enemy.removeFromParent()
        for _ in 0..<8 {
            let p = SKShapeNode(circleOfRadius: CGFloat.random(in: 3...7))
            p.fillColor = .gold
            p.strokeColor = .clear
            p.position = enemy.position
            p.userData = ["vx": CGFloat.random(in: -160...80), "vy": CGFloat.random(in: -130...130), "life": 0.35]
            addChild(p)
            particles.append(p)
        }
        if score >= 30 {
            showEnd(title: "Perfect Run", detail: "You cleared the ambush with a \(streak)x streak.")
        }
    }

    private func updateParticles(_ dt: TimeInterval) {
        for p in particles {
            let vx = p.userData?["vx"] as? CGFloat ?? 0
            let vy = p.userData?["vy"] as? CGFloat ?? 0
            let life = (p.userData?["life"] as? Double ?? 0) - dt
            p.position.x += vx * CGFloat(dt)
            p.position.y += vy * CGFloat(dt)
            p.alpha = max(0, CGFloat(life / 0.35))
            p.userData?["life"] = life
            if life <= 0 { p.removeFromParent() }
        }
        particles.removeAll { $0.parent == nil }
    }

    private func updateHUD() {
        hud.text = "One Button Samurai   Score \(score)   Streak \(streak)"
    }

    private func reset() {
        removeAllChildren()
        enemies.removeAll()
        particles.removeAll()
        lastUpdateTime = 0
        spawnTimer = 0
        dashTimer = 0
        dashCooldown = 0
        score = 0
        streak = 0
        isGameOver = false
        didMove(to: view!)
    }
}

final class DungeonScene: BaseGameScene {
    private let cols = 12
    private let rows = 8
    private let tile: CGFloat = 54
    private var origin = CGPoint.zero
    private var walls = Set<GridPoint>()
    private var enemies: [GridPoint] = []
    private var loot = Set<GridPoint>()
    private var player = GridPoint(x: 1, y: 1)
    private var exit = GridPoint(x: 10, y: 6)
    private var hp = 5
    private var floor = 1
    private var score = 0
    private var rng = GKRandomSource.sharedRandom()

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        help.text = "WASD/arrows: move or attack   R: restart   Esc: menu"
        startFloor()
    }

    override func keyDown(with event: NSEvent) {
        if event.charactersIgnoringModifiers?.lowercased() == "r" {
            restart()
            return
        }
        if isGameOver {
            super.keyDown(with: event)
            return
        }
        let key = event.charactersIgnoringModifiers?.lowercased() ?? ""
        var delta = GridPoint(x: 0, y: 0)
        if key == "w" || event.keyCode == 126 { delta.y = 1 }
        if key == "s" || event.keyCode == 125 { delta.y = -1 }
        if key == "a" || event.keyCode == 123 { delta.x = -1 }
        if key == "d" || event.keyCode == 124 { delta.x = 1 }
        if delta.x != 0 || delta.y != 0 {
            movePlayer(delta)
        }
        super.keyDown(with: event)
    }

    private func startFloor() {
        walls.removeAll()
        enemies.removeAll()
        loot.removeAll()
        player = GridPoint(x: 1, y: 1)
        exit = GridPoint(x: cols - 2, y: rows - 2)

        for x in 0..<cols {
            walls.insert(GridPoint(x: x, y: 0))
            walls.insert(GridPoint(x: x, y: rows - 1))
        }
        for y in 0..<rows {
            walls.insert(GridPoint(x: 0, y: y))
            walls.insert(GridPoint(x: cols - 1, y: y))
        }

        let blocked = Set([player, exit, GridPoint(x: 2, y: 1), GridPoint(x: 1, y: 2)])
        for _ in 0..<(8 + floor) {
            let p = randomOpen(excluding: blocked)
            walls.insert(p)
        }
        for _ in 0..<(2 + floor) {
            enemies.append(randomOpen(excluding: blocked.union(walls).union(Set(enemies))))
        }
        for _ in 0..<3 {
            loot.insert(randomOpen(excluding: blocked.union(walls).union(Set(enemies)).union(loot)))
        }
        draw()
    }

    private func movePlayer(_ delta: GridPoint) {
        let target = GridPoint(x: player.x + delta.x, y: player.y + delta.y)
        if walls.contains(target) { return }
        if let enemyIndex = enemies.firstIndex(of: target) {
            enemies.remove(at: enemyIndex)
            score += 20
        } else {
            player = target
        }
        if loot.contains(player) {
            loot.remove(player)
            hp = min(7, hp + 1)
            score += 10
        }
        if player == exit {
            floor += 1
            score += 100
            if floor > 3 {
                draw()
                showEnd(title: "Dungeon Cleared", detail: "Score: \(score)")
                return
            }
            startFloor()
            return
        }
        moveEnemies()
        if hp <= 0 {
            draw()
            showEnd(title: "The Dungeon Wins", detail: "You reached floor \(floor).", color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
            return
        }
        draw()
    }

    private func moveEnemies() {
        var occupied = Set(enemies)
        for index in enemies.indices {
            let e = enemies[index]
            occupied.remove(e)
            var candidates = [
                GridPoint(x: e.x + 1, y: e.y),
                GridPoint(x: e.x - 1, y: e.y),
                GridPoint(x: e.x, y: e.y + 1),
                GridPoint(x: e.x, y: e.y - 1)
            ]
            candidates.sort { $0.distance(to: player) < $1.distance(to: player) }
            if let next = candidates.first(where: { !walls.contains($0) && !occupied.contains($0) }) {
                enemies[index] = next
            }
            occupied.insert(enemies[index])
            if enemies[index] == player {
                hp -= 1
                enemies[index] = e
            }
        }
    }

    private func draw() {
        children.filter { $0.name == "dungeon" }.forEach { $0.removeFromParent() }
        origin = CGPoint(x: size.width / 2 - CGFloat(cols) * tile / 2 + tile / 2, y: size.height / 2 - CGFloat(rows) * tile / 2 + tile / 2 - 4)
        hud.text = "Micro Dungeon   Floor \(floor)/3   HP \(hp)   Score \(score)"

        for y in 0..<rows {
            for x in 0..<cols {
                let p = GridPoint(x: x, y: y)
                let cell = roundedRect(size: CGSize(width: tile - 5, height: tile - 5), radius: 5, color: walls.contains(p) ? SKColor(calibratedRed: 0.18, green: 0.20, blue: 0.23, alpha: 1) : SKColor(calibratedRed: 0.09, green: 0.12, blue: 0.13, alpha: 1), stroke: SKColor.bone.withAlphaComponent(0.08), lineWidth: 1)
                cell.position = pointFor(p)
                cell.name = "dungeon"
                addChild(cell)
            }
        }

        let exitNode = roundedRect(size: CGSize(width: tile - 16, height: tile - 16), radius: 6, color: SKColor(calibratedRed: 0.15, green: 0.78, blue: 0.49, alpha: 1))
        exitNode.position = pointFor(exit)
        exitNode.name = "dungeon"
        addChild(exitNode)

        for p in loot {
            let node = SKShapeNode(circleOfRadius: 11)
            node.fillColor = .gold
            node.strokeColor = .clear
            node.position = pointFor(p)
            node.name = "dungeon"
            addChild(node)
        }

        for e in enemies {
            let node = SKShapeNode(rectOf: CGSize(width: 32, height: 32), cornerRadius: 6)
            node.fillColor = SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1)
            node.strokeColor = .clear
            node.position = pointFor(e)
            node.name = "dungeon"
            addChild(node)
        }

        let hero = SKShapeNode(circleOfRadius: 18)
        hero.fillColor = .bone
        hero.strokeColor = SKColor(calibratedRed: 0.15, green: 0.78, blue: 0.49, alpha: 1)
        hero.lineWidth = 4
        hero.position = pointFor(player)
        hero.name = "dungeon"
        addChild(hero)
    }

    private func randomOpen(excluding taken: Set<GridPoint>) -> GridPoint {
        for _ in 0..<200 {
            let p = GridPoint(x: Int.random(in: 1..<(cols - 1)), y: Int.random(in: 1..<(rows - 1)))
            if !taken.contains(p) { return p }
        }
        return GridPoint(x: 2, y: 2)
    }

    private func pointFor(_ p: GridPoint) -> CGPoint {
        CGPoint(x: origin.x + CGFloat(p.x) * tile, y: origin.y + CGFloat(p.y) * tile)
    }

    private func restart() {
        isGameOver = false
        hp = 5
        floor = 1
        score = 0
        children.filter { $0.zPosition >= 1000 }.forEach { $0.removeFromParent() }
        startFloor()
    }
}

struct GridPoint: Hashable {
    var x: Int
    var y: Int

    func distance(to other: GridPoint) -> Int {
        abs(x - other.x) + abs(y - other.y)
    }
}

final class StockScene: BaseGameScene {
    private var cash: Double = 500
    private var shares: Int = 0
    private var price: Double = 50
    private var day: Int = 1
    private var eventTimer: TimeInterval = 2.0
    private var lastUpdateTime: TimeInterval = 0
    private var priceLine = SKShapeNode()
    private var history: [Double] = [50]
    private let news = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let portfolio = SKLabelNode(fontNamed: "AvenirNext-Bold")

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        help.text = "B: buy   S: sell   R: restart   Esc: menu"
        news.fontSize = 22
        news.fontColor = .gold
        news.verticalAlignmentMode = .center
        news.position = CGPoint(x: size.width / 2, y: size.height - 92)
        addChild(news)

        portfolio.fontSize = 28
        portfolio.fontColor = .bone
        portfolio.verticalAlignmentMode = .center
        portfolio.position = CGPoint(x: size.width / 2, y: 74)
        addChild(portfolio)
        drawMarket()
        announce("Opening bell. Don't blow up.")
    }

    override func keyDown(with event: NSEvent) {
        let key = event.charactersIgnoringModifiers?.lowercased() ?? ""
        if key == "r" {
            restart()
            return
        }
        if isGameOver {
            super.keyDown(with: event)
            return
        }
        if key == "b" && cash >= price {
            shares += 1
            cash -= price
        }
        if key == "s" && shares > 0 {
            shares -= 1
            cash += price
        }
        updateText()
        super.keyDown(with: event)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = min(currentTime - lastUpdateTime, 0.05)
        lastUpdateTime = currentTime
        if isGameOver { return }

        eventTimer -= dt
        if eventTimer <= 0 {
            nextEvent()
            eventTimer = 1.35
        }
        if cash + Double(shares) * price <= 0 {
            showEnd(title: "Margin Called", detail: "Your portfolio hit zero.", color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
        }
        if day > 30 {
            let value = Int(cash + Double(shares) * price)
            showEnd(title: value >= 900 ? "Market Wizard" : "Closing Bell", detail: "Final portfolio: $\(value)", color: value >= 900 ? .gold : .bone)
        }
    }

    private func nextEvent() {
        day += 1
        let events: [(String, Double)] = [
            ("AI hype sends risk assets flying", 1.20),
            ("Rate-cut rumor boosts the tape", 1.13),
            ("Bad earnings guidance leaks", 0.76),
            ("Short squeeze detonates", 1.32),
            ("Regulator opens investigation", 0.70),
            ("Influencer says this is the future", 1.09),
            ("Liquidity dries up before lunch", 0.86),
            ("Surprise partnership announced", 1.18)
        ]
        let event = events.randomElement()!
        price = max(5, min(180, price * event.1 + Double.random(in: -4...4)))
        history.append(price)
        if history.count > 28 { history.removeFirst() }
        announce(event.0)
        drawMarket()
        updateText()
    }

    private func announce(_ text: String) {
        news.text = text
        news.run(.sequence([.scale(to: 1.08, duration: 0.08), .scale(to: 1.0, duration: 0.16)]))
    }

    private func drawMarket() {
        children.filter { $0.name == "market" }.forEach { $0.removeFromParent() }
        let area = CGRect(x: 110, y: 150, width: size.width - 220, height: size.height - 300)
        let frame = roundedRect(size: area.size, radius: 8, color: SKColor(calibratedRed: 0.07, green: 0.09, blue: 0.11, alpha: 1), stroke: SKColor(calibratedRed: 0.16, green: 0.55, blue: 0.95, alpha: 1), lineWidth: 2)
        frame.position = CGPoint(x: area.midX, y: area.midY)
        frame.name = "market"
        addChild(frame)

        let path = CGMutablePath()
        let maxP = max(history.max() ?? 1, 100)
        let minP = min(history.min() ?? 0, 5)
        for (i, p) in history.enumerated() {
            let t = history.count == 1 ? 0 : CGFloat(i) / CGFloat(history.count - 1)
            let x = area.minX + 28 + t * (area.width - 56)
            let yT = CGFloat((p - minP) / max(1, maxP - minP))
            let y = area.minY + 34 + yT * (area.height - 68)
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) } else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        priceLine = SKShapeNode(path: path)
        priceLine.strokeColor = .gold
        priceLine.lineWidth = 4
        priceLine.lineCap = .round
        priceLine.name = "market"
        addChild(priceLine)
        updateText()
    }

    private func updateText() {
        let value = cash + Double(shares) * price
        hud.text = "Stock Market Survivor   Day \(min(day, 30))/30   Price $\(Int(price))"
        portfolio.text = "Cash $\(Int(cash))   Shares \(shares)   Portfolio $\(Int(value))"
    }

    private func restart() {
        children.filter { $0.zPosition >= 1000 }.forEach { $0.removeFromParent() }
        isGameOver = false
        cash = 500
        shares = 0
        price = 50
        day = 1
        eventTimer = 1.0
        lastUpdateTime = 0
        history = [50]
        drawMarket()
        announce("Opening bell. Don't blow up.")
    }
}
