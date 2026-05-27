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
        case .pong:
            scene = PongScene(size: skView.bounds.size)
        case .campus:
            scene = CampusDashScene(size: skView.bounds.size)
        case .brickforge:
            scene = BrickforgeScene(size: skView.bounds.size)
        case .starforge:
            scene = StarforgeCourierScene(size: skView.bounds.size)
        case .rhythm:
            scene = RhythmForgeScene(size: skView.bounds.size)
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
    case pong
    case campus
    case brickforge
    case starforge
    case rhythm

    var title: String {
        switch self {
        case .samurai: return "One Button Samurai"
        case .dungeon: return "Micro Dungeon"
        case .stocks: return "Stock Market Survivor"
        case .pong: return "Neon Pong Royale"
        case .campus: return "Campus Dash"
        case .brickforge: return "Brickforge Breakout"
        case .starforge: return "Starforge Courier"
        case .rhythm: return "Rhythm Forge"
        }
    }

    var subtitle: String {
        switch self {
        case .samurai: return "Dash through raiders with one perfectly timed strike."
        case .dungeon: return "Clear tiny tactical floors before your hearts run out."
        case .stocks: return "Trade through chaos and survive the closing bell."
        case .pong: return "Win a first-to-seven neon duel against a ruthless AI."
        case .campus: return "Sprint to class while dodging bikes and collecting notes."
        case .brickforge: return "Shatter neon foundry bricks with heat, shields, and multiball."
        case .starforge: return "Haul cargo through asteroid traffic before oxygen runs out."
        case .rhythm: return "Hit the forge lanes on beat and keep the combo alive."
        }
    }

    var accent: NSColor {
        switch self {
        case .samurai: return NSColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1)
        case .dungeon: return NSColor(calibratedRed: 0.15, green: 0.78, blue: 0.49, alpha: 1)
        case .stocks: return NSColor(calibratedRed: 0.16, green: 0.55, blue: 0.95, alpha: 1)
        case .pong: return NSColor(calibratedRed: 0.90, green: 0.20, blue: 0.95, alpha: 1)
        case .campus: return NSColor(calibratedRed: 0.98, green: 0.63, blue: 0.12, alpha: 1)
        case .brickforge: return NSColor(calibratedRed: 1.00, green: 0.36, blue: 0.18, alpha: 1)
        case .starforge: return NSColor(calibratedRed: 0.25, green: 0.68, blue: 1.00, alpha: 1)
        case .rhythm: return NSColor(calibratedRed: 0.72, green: 0.36, blue: 1.00, alpha: 1)
        }
    }

    var genre: String {
        switch self {
        case .samurai: return "ACTION / TIMING"
        case .dungeon: return "ROGUELIKE / TACTICS"
        case .stocks: return "ARCADE / STRATEGY"
        case .pong: return "SPORTS / ARCADE"
        case .campus: return "DODGER / ROUTE RUN"
        case .brickforge: return "ACTION / BREAKOUT"
        case .starforge: return "SPACE / DELIVERY"
        case .rhythm: return "RHYTHM / TIMING"
        }
    }

    var capsuleLine: String {
        switch self {
        case .samurai: return "Parry. Dash. Survive."
        case .dungeon: return "Tiny runs. Real choices."
        case .stocks: return "Beat the market shock."
        case .pong: return "Neon table duel."
        case .campus: return "Make it before class."
        case .brickforge: return "Clear the heat wall."
        case .starforge: return "Deliver under pressure."
        case .rhythm: return "Strike on the beat."
        }
    }

    var releaseStatus: String {
        switch self {
        case .samurai, .dungeon, .stocks, .brickforge, .starforge, .rhythm: return "FLAGSHIP"
        case .pong, .campus: return "ARCADE"
        }
    }

    var sessionLength: String {
        switch self {
        case .samurai: return "3-5 MIN RUN"
        case .dungeon: return "8-12 MIN RUN"
        case .stocks: return "5 MIN RUN"
        case .pong: return "FIRST TO 7"
        case .campus: return "2 MIN SPRINT"
        case .brickforge: return "3 STAGES"
        case .starforge: return "60 SEC ROUTE"
        case .rhythm: return "32 BEAT SET"
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

func clamp(_ value: CGFloat, _ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
    Swift.max(minValue, Swift.min(maxValue, value))
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
        drawBackdrop()

        let badge = label("STEAM-READY POLISH PASS", size: 14, color: .gold, weight: .regular)
        badge.position = CGPoint(x: size.width / 2, y: size.height - 42)
        addChild(badge)

        let title = label("Nashy Game Studio", size: 50, color: .bone)
        title.position = CGPoint(x: size.width / 2, y: size.height - 86)
        addChild(title)

        let subtitle = label("Native desktop games with polished loops, capsule art direction, and release-ready structure", size: 17, color: SKColor.bone.withAlphaComponent(0.72), weight: .regular)
        subtitle.position = CGPoint(x: size.width / 2, y: size.height - 128)
        addChild(subtitle)

        drawStoreStats()

        let games = GameKind.allCases
        let columns = min(3, games.count)
        let rows = Int(ceil(Double(games.count) / Double(columns)))
        let cardWidth = min(286, max(210, (size.width - 120) / CGFloat(columns)))
        let cardHeight = rows > 2 ? CGFloat(150) : (rows > 1 ? CGFloat(205) : CGFloat(270))
        let cardSize = CGSize(width: cardWidth, height: cardHeight)
        let spacingX = min(30, max(18, (size.width - cardWidth * CGFloat(columns) - 80) / CGFloat(max(1, columns - 1))))
        let spacingY: CGFloat = rows > 2 ? 16 : 22
        let totalWidth = cardWidth * CGFloat(columns) + spacingX * CGFloat(columns - 1)
        let totalHeight = cardHeight * CGFloat(rows) + spacingY * CGFloat(rows - 1)
        let startX = size.width / 2 - totalWidth / 2 + cardWidth / 2
        let startY = size.height / 2 + totalHeight / 2 - cardHeight / 2 - 28

        for (index, game) in games.enumerated() {
            let col = index % columns
            let row = index / columns
            let x = startX + CGFloat(col) * (cardWidth + spacingX)
            let y = startY - CGFloat(row) * (cardHeight + spacingY)
            cardFrames[game] = CGRect(x: x - cardSize.width / 2, y: y - cardSize.height / 2, width: cardSize.width, height: cardSize.height)

            let card = roundedRect(size: cardSize, radius: 8, color: SKColor(calibratedRed: 0.07, green: 0.08, blue: 0.10, alpha: 0.98), stroke: game.accent, lineWidth: 2)
            card.position = CGPoint(x: x, y: y)
            addChild(card)

            let highlight = roundedRect(size: CGSize(width: cardWidth - 12, height: cardHeight - 12), radius: 7, color: .clear, stroke: SKColor.white.withAlphaComponent(0.05), lineWidth: 1)
            highlight.position = CGPoint(x: x, y: y)
            addChild(highlight)

            let capsule = roundedRect(size: CGSize(width: cardWidth - 22, height: cardHeight * 0.42), radius: 6, color: game.accent.withAlphaComponent(0.28), stroke: SKColor.bone.withAlphaComponent(0.10), lineWidth: 1)
            capsule.position = CGPoint(x: x, y: y + cardHeight * 0.22)
            addChild(capsule)

            drawCapsuleArt(for: game, center: capsule.position, size: CGSize(width: cardWidth - 22, height: cardHeight * 0.42))

            for stripe in 0..<5 {
                let line = SKShapeNode(rectOf: CGSize(width: cardWidth - 52, height: 3), cornerRadius: 2)
                line.fillColor = game.accent.withAlphaComponent(0.30)
                line.strokeColor = .clear
                line.zRotation = -0.28
                line.position = CGPoint(x: x + CGFloat(stripe - 2) * 26, y: y + cardHeight * 0.22 + CGFloat(stripe - 2) * 9)
                addChild(line)
            }

            let icon = SKShapeNode(circleOfRadius: 34)
            icon.fillColor = game.accent
            icon.strokeColor = .clear
            icon.position = CGPoint(x: x, y: y + cardHeight * 0.22)
            addChild(icon)

            let glyph = label(glyphFor(game), size: 31, color: .ink)
            glyph.position = icon.position
            addChild(glyph)

            drawChip(game.releaseStatus, at: CGPoint(x: x + cardWidth / 2 - 52, y: y + cardHeight / 2 - 20), color: game.accent)

            let titleNode = label(game.title, size: 21, color: .bone)
            titleNode.position = CGPoint(x: x, y: y - 12)
            addChild(titleNode)

            let lines = wrapped(game.subtitle, max: 34).prefix(2)
            for (lineIndex, line) in lines.enumerated() {
                let lineNode = label(line, size: 13, color: SKColor.bone.withAlphaComponent(0.72), weight: .regular)
                lineNode.position = CGPoint(x: x, y: y - 42 - CGFloat(lineIndex) * 17)
                addChild(lineNode)
            }

            let genre = label(game.genre, size: 11, color: SKColor.bone.withAlphaComponent(0.62), weight: .regular)
            genre.position = CGPoint(x: x, y: y - cardHeight * 0.29)
            addChild(genre)

            let session = label(game.sessionLength, size: 10, color: SKColor.bone.withAlphaComponent(0.56), weight: .regular)
            session.position = CGPoint(x: x - cardWidth / 2 + 62, y: y - cardHeight / 2 + 20)
            addChild(session)

            let cta = label("PLAY NOW", size: 14, color: game.accent)
            cta.position = CGPoint(x: x + cardWidth / 2 - 54, y: y - cardHeight / 2 + 20)
            addChild(cta)
        }

        let footer = label("Click a capsule. Press Esc inside any game to return.", size: 16, color: SKColor.bone.withAlphaComponent(0.58), weight: .regular)
        footer.position = CGPoint(x: size.width / 2, y: 46)
        addChild(footer)
    }

    private func drawStoreStats() {
        let stats = [
            "8 playable games",
            "Native macOS build",
            "Capsule shelf UI",
            "Release-track prototypes"
        ]
        let totalWidth: CGFloat = 680
        let chipWidth = totalWidth / CGFloat(stats.count)
        let y = size.height - 160
        for (index, text) in stats.enumerated() {
            let x = size.width / 2 - totalWidth / 2 + chipWidth / 2 + CGFloat(index) * chipWidth
            drawChip(text.uppercased(), at: CGPoint(x: x, y: y), color: index == 0 ? .gold : SKColor.bone.withAlphaComponent(0.62), width: chipWidth - 14)
        }
    }

    private func drawChip(_ text: String, at point: CGPoint, color: SKColor, width: CGFloat = 94) {
        let chip = roundedRect(size: CGSize(width: width, height: 24), radius: 7, color: color.withAlphaComponent(0.12), stroke: color.withAlphaComponent(0.34), lineWidth: 1)
        chip.position = point
        addChild(chip)

        let chipText = label(text, size: 9.5, color: color, weight: .regular)
        chipText.position = point
        addChild(chipText)
    }

    private func drawCapsuleArt(for game: GameKind, center: CGPoint, size artSize: CGSize) {
        let baseY = center.y - artSize.height * 0.24
        switch game {
        case .samurai:
            let blade = SKShapeNode(rectOf: CGSize(width: artSize.width * 0.78, height: 6), cornerRadius: 3)
            blade.fillColor = SKColor.white.withAlphaComponent(0.62)
            blade.strokeColor = .clear
            blade.zRotation = -0.34
            blade.position = CGPoint(x: center.x, y: center.y + 4)
            addChild(blade)
            let sun = SKShapeNode(circleOfRadius: 24)
            sun.fillColor = game.accent.withAlphaComponent(0.52)
            sun.strokeColor = .clear
            sun.position = CGPoint(x: center.x - artSize.width * 0.28, y: center.y + artSize.height * 0.16)
            addChild(sun)
        case .dungeon:
            for row in 0..<3 {
                for col in 0..<5 {
                    let tileNode = roundedRect(size: CGSize(width: 22, height: 18), radius: 3, color: SKColor.black.withAlphaComponent(0.18), stroke: game.accent.withAlphaComponent(0.22), lineWidth: 1)
                    tileNode.position = CGPoint(x: center.x - 52 + CGFloat(col) * 26, y: baseY + CGFloat(row) * 22)
                    addChild(tileNode)
                }
            }
        case .stocks:
            let path = CGMutablePath()
            path.move(to: CGPoint(x: center.x - artSize.width * 0.38, y: baseY))
            path.addLine(to: CGPoint(x: center.x - artSize.width * 0.16, y: baseY + 34))
            path.addLine(to: CGPoint(x: center.x + artSize.width * 0.03, y: baseY + 18))
            path.addLine(to: CGPoint(x: center.x + artSize.width * 0.25, y: baseY + 52))
            path.addLine(to: CGPoint(x: center.x + artSize.width * 0.40, y: baseY + 44))
            let line = SKShapeNode(path: path)
            line.strokeColor = SKColor.white.withAlphaComponent(0.70)
            line.lineWidth = 4
            line.lineCap = .round
            addChild(line)
        case .pong:
            let left = SKShapeNode(rectOf: CGSize(width: 8, height: 56), cornerRadius: 4)
            let right = SKShapeNode(rectOf: CGSize(width: 8, height: 56), cornerRadius: 4)
            left.fillColor = SKColor.white.withAlphaComponent(0.65)
            right.fillColor = left.fillColor
            left.strokeColor = .clear
            right.strokeColor = .clear
            left.position = CGPoint(x: center.x - artSize.width * 0.34, y: center.y)
            right.position = CGPoint(x: center.x + artSize.width * 0.34, y: center.y)
            addChild(left)
            addChild(right)
            let ball = SKShapeNode(circleOfRadius: 8)
            ball.fillColor = game.accent
            ball.strokeColor = .clear
            ball.position = center
            addChild(ball)
        case .campus:
            for offset in [-54, -18, 18, 54] {
                let route = SKShapeNode(rectOf: CGSize(width: 18, height: 58), cornerRadius: 8)
                route.fillColor = SKColor.white.withAlphaComponent(0.15)
                route.strokeColor = .clear
                route.zRotation = 0.28
                route.position = CGPoint(x: center.x + CGFloat(offset), y: center.y)
                addChild(route)
            }
            let note = roundedRect(size: CGSize(width: 42, height: 30), radius: 4, color: .gold.withAlphaComponent(0.72), stroke: .clear, lineWidth: 0)
            note.position = CGPoint(x: center.x, y: center.y + 6)
            addChild(note)
        case .brickforge:
            for row in 0..<3 {
                for col in 0..<6 {
                    let brick = roundedRect(size: CGSize(width: 26, height: 12), radius: 3, color: row == 1 ? .gold.withAlphaComponent(0.55) : game.accent.withAlphaComponent(0.62), stroke: .clear, lineWidth: 0)
                    brick.position = CGPoint(x: center.x - 66 + CGFloat(col) * 26, y: baseY + 8 + CGFloat(row) * 16)
                    addChild(brick)
                }
            }
        case .starforge:
            let ship = SKShapeNode(path: trianglePath(size: 42))
            ship.fillColor = SKColor.white.withAlphaComponent(0.68)
            ship.strokeColor = .clear
            ship.position = center
            addChild(ship)
            for offset in [-54, 52] {
                let asteroid = SKShapeNode(circleOfRadius: 13)
                asteroid.fillColor = game.accent.withAlphaComponent(0.46)
                asteroid.strokeColor = SKColor.white.withAlphaComponent(0.20)
                asteroid.position = CGPoint(x: center.x + CGFloat(offset), y: center.y + CGFloat.random(in: -18...18))
                addChild(asteroid)
            }
        case .rhythm:
            for col in 0..<4 {
                let lane = roundedRect(size: CGSize(width: 18, height: artSize.height * 0.76), radius: 8, color: SKColor.white.withAlphaComponent(0.12), stroke: game.accent.withAlphaComponent(0.24), lineWidth: 1)
                lane.position = CGPoint(x: center.x - 45 + CGFloat(col) * 30, y: center.y)
                addChild(lane)
                let note = SKShapeNode(circleOfRadius: 8)
                note.fillColor = col % 2 == 0 ? game.accent : .gold
                note.strokeColor = .clear
                note.position = CGPoint(x: lane.position.x, y: center.y + CGFloat([-18, 4, 22, -6][col]))
                addChild(note)
            }
        }
    }

    private func drawBackdrop() {
        let heroBand = roundedRect(size: CGSize(width: size.width - 90, height: size.height - 120), radius: 8, color: SKColor(calibratedRed: 0.06, green: 0.07, blue: 0.09, alpha: 0.70), stroke: SKColor.bone.withAlphaComponent(0.08), lineWidth: 1)
        heroBand.position = CGPoint(x: size.width / 2, y: size.height / 2 - 18)
        heroBand.zPosition = -10
        addChild(heroBand)

        for index in 0..<24 {
            let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 1.2...2.6))
            dot.fillColor = SKColor.bone.withAlphaComponent(CGFloat.random(in: 0.08...0.22))
            dot.strokeColor = .clear
            dot.position = CGPoint(x: CGFloat.random(in: 40...(size.width - 40)), y: CGFloat.random(in: 70...(size.height - 60)))
            dot.zPosition = -9
            dot.name = "spark-\(index)"
            addChild(dot)
        }
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
        case .pong: return "*"
        case .campus: return "@"
        case .brickforge: return "%"
        case .starforge: return "^"
        case .rhythm: return "&"
        }
    }

    private func trianglePath(size: CGFloat) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: size / 2))
        path.addLine(to: CGPoint(x: -size / 2, y: -size / 2))
        path.addLine(to: CGPoint(x: size / 2, y: -size / 2))
        path.closeSubpath()
        return path
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

    func flashText(_ text: String, color: SKColor = .gold) {
        let node = label(text, size: 24, color: color)
        node.position = CGPoint(x: size.width / 2, y: size.height - 92)
        node.zPosition = 900
        addChild(node)
        node.run(.sequence([
            .group([.moveBy(x: 0, y: 18, duration: 0.55), .fadeOut(withDuration: 0.55)]),
            .removeFromParent()
        ]))
    }

    func spark(at point: CGPoint, color: SKColor) {
        for _ in 0..<10 {
            let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 2.5...6.5))
            dot.fillColor = color
            dot.strokeColor = .clear
            dot.position = point
            dot.zPosition = 500
            addChild(dot)
            dot.run(.sequence([
                .group([
                    .moveBy(x: CGFloat.random(in: -42...42), y: CGFloat.random(in: -42...42), duration: 0.28),
                    .fadeOut(withDuration: 0.28),
                    .scale(to: 0.25, duration: 0.28)
                ]),
                .removeFromParent()
            ]))
        }
    }
}

final class SamuraiScene: BaseGameScene {
    private let player = SKShapeNode(circleOfRadius: 24)
    private let sword = SKShapeNode(rectOf: CGSize(width: 64, height: 8), cornerRadius: 3)
    private let parryRing = SKShapeNode(circleOfRadius: 58)
    private var enemies: [SKShapeNode] = []
    private var particles: [SKShapeNode] = []
    private var lastUpdateTime: TimeInterval = 0
    private var spawnTimer: TimeInterval = 0
    private var dashTimer: TimeInterval = 0
    private var dashCooldown: TimeInterval = 0
    private var slowMoTimer: TimeInterval = 0
    private var score = 0
    private var streak = 0
    private var parries = 0
    private var focus = 0
    private var enemySpeed: CGFloat = 225

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        help.text = "Space: dash / parry / strike   R: restart   Esc: menu"
        player.fillColor = .bone
        player.strokeColor = SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1)
        player.lineWidth = 4
        player.position = CGPoint(x: 150, y: size.height / 2)
        addChild(player)

        parryRing.strokeColor = .gold.withAlphaComponent(0.36)
        parryRing.fillColor = .clear
        parryRing.lineWidth = 3
        parryRing.position = player.position
        parryRing.alpha = 0
        addChild(parryRing)

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
            if let parryTarget = enemies.first(where: { abs($0.position.x - player.position.x) < 92 && abs($0.position.y - player.position.y) < 70 }) {
                parry(parryTarget)
                dashCooldown = 0.30
                super.keyDown(with: event)
                return
            }
            if focus >= 3 {
                focusStrike()
                dashCooldown = 0.42
                super.keyDown(with: event)
                return
            }
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
        slowMoTimer -= dt
        if dashTimer <= 0 { sword.isHidden = true }
        if spawnTimer <= 0 {
            spawnEnemy()
            spawnTimer = max(0.42, 1.06 - Double(score) * 0.015)
        }

        let activeDash = dashTimer > 0
        for enemy in enemies {
            let slowMo = slowMoTimer > 0 ? CGFloat(0.44) : CGFloat(1)
            enemy.position.x -= (enemySpeed + CGFloat(score) * 4) * slowMo * CGFloat(dt)
            let dangerDistance = abs(enemy.position.x - player.position.x)
            enemy.alpha = dangerDistance < 110 ? 1 : 0.86
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
        parryRing.position = player.position
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

    private func parry(_ enemy: SKShapeNode) {
        parries += 1
        focus = min(3, focus + 1)
        streak += 1
        score += 2
        slowMoTimer = 0.42
        kill(enemy)
        parryRing.alpha = 1
        parryRing.setScale(0.35)
        parryRing.run(.sequence([
            .group([.scale(to: 1.22, duration: 0.18), .fadeOut(withDuration: 0.22)]),
            .scale(to: 1.0, duration: 0.01)
        ]))
    }

    private func focusStrike() {
        focus = 0
        let targets = enemies.filter { $0.position.x < size.width - 80 }
        for enemy in targets.prefix(5) {
            kill(enemy)
        }
        let slash = SKShapeNode(rectOf: CGSize(width: size.width, height: 6), cornerRadius: 3)
        slash.fillColor = .gold
        slash.strokeColor = .clear
        slash.position = CGPoint(x: size.width / 2, y: player.position.y)
        addChild(slash)
        slash.run(.sequence([.fadeOut(withDuration: 0.18), .removeFromParent()]))
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
        let focusPips = String(repeating: "|", count: focus).padding(toLength: 3, withPad: ".", startingAt: 0)
        hud.text = "One Button Samurai   Score \(score)   Streak \(streak)   Parries \(parries)   Focus \(focusPips)"
    }

    private func reset() {
        removeAllChildren()
        enemies.removeAll()
        particles.removeAll()
        lastUpdateTime = 0
        spawnTimer = 0
        dashTimer = 0
        dashCooldown = 0
        slowMoTimer = 0
        score = 0
        streak = 0
        parries = 0
        focus = 0
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
    private var traps = Set<GridPoint>()
    private var enemies: [GridPoint] = []
    private var loot = Set<GridPoint>()
    private var player = GridPoint(x: 1, y: 1)
    private var exit = GridPoint(x: 10, y: 6)
    private var hp = 5
    private var maxHP = 5
    private var floor = 1
    private var score = 0
    private var armor = 0
    private var relics = 0
    private var upgrades: [String] = []
    private let banner = SKLabelNode(fontNamed: "AvenirNext-Bold")

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        help.text = "WASD/arrows: move or attack   R: restart   Esc: menu"
        banner.fontSize = 18
        banner.fontColor = .gold
        banner.verticalAlignmentMode = .center
        banner.position = CGPoint(x: size.width / 2, y: 86)
        banner.alpha = 0
        addChild(banner)
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
        traps.removeAll()
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
        for _ in 0..<(2 + floor + relics / 2) {
            enemies.append(randomOpen(excluding: blocked.union(walls).union(traps).union(Set(enemies))))
        }
        for _ in 0..<(2 + floor) {
            traps.insert(randomOpen(excluding: blocked.union(walls).union(Set(enemies)).union(traps)))
        }
        for _ in 0..<3 {
            loot.insert(randomOpen(excluding: blocked.union(walls).union(Set(enemies)).union(traps).union(loot)))
        }
        draw()
    }

    private func movePlayer(_ delta: GridPoint) {
        let target = GridPoint(x: player.x + delta.x, y: player.y + delta.y)
        if walls.contains(target) { return }
        if let enemyIndex = enemies.firstIndex(of: target) {
            enemies.remove(at: enemyIndex)
            score += 20 + relics * 5
        } else {
            player = target
        }
        if loot.contains(player) {
            loot.remove(player)
            if Bool.random() {
                hp = min(maxHP, hp + 2)
                flashBanner("Potion found: +2 HP")
            } else {
                relics += 1
                score += 25
                flashBanner("Relic found: richer floor clears")
            }
            score += 10
        }
        if traps.contains(player) {
            traps.remove(player)
            let blocked = armor > 0
            takeDamage()
            flashBanner(blocked ? "Armor cracked on a trap" : "Trap sprung: -1 HP")
        }
        if player == exit {
            floor += 1
            score += 100 + relics * 25
            if floor > 3 {
                draw()
                showEnd(title: "Dungeon Cleared", detail: "Score: \(score)   Relics: \(relics)")
                return
            }
            applyUpgrade()
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
                takeDamage()
                enemies[index] = e
            }
        }
    }

    private func draw() {
        children.filter { $0.name == "dungeon" }.forEach { $0.removeFromParent() }
        origin = CGPoint(x: size.width / 2 - CGFloat(cols) * tile / 2 + tile / 2, y: size.height / 2 - CGFloat(rows) * tile / 2 + tile / 2 - 4)
        let upgradeText = upgrades.isEmpty ? "No upgrades" : upgrades.joined(separator: ", ")
        hud.text = "Micro Dungeon   Floor \(floor)/3   HP \(hp)/\(maxHP)   Armor \(armor)   Score \(score)   \(upgradeText)"

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

        for p in traps {
            let node = SKShapeNode(rectOf: CGSize(width: 20, height: 20), cornerRadius: 4)
            node.fillColor = SKColor(calibratedRed: 0.95, green: 0.36, blue: 0.12, alpha: 1)
            node.strokeColor = .clear
            node.zRotation = .pi / 4
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
        maxHP = 5
        floor = 1
        score = 0
        armor = 0
        relics = 0
        upgrades.removeAll()
        banner.text = ""
        banner.alpha = 0
        children.filter { $0.zPosition >= 1000 }.forEach { $0.removeFromParent() }
        startFloor()
    }

    private func applyUpgrade() {
        let choices = ["Iron Heart", "Guard Plate", "Relic Sense"].filter { !upgrades.contains($0) || $0 == "Guard Plate" }
        let upgrade = choices.randomElement() ?? "Guard Plate"
        upgrades.append(upgrade)
        switch upgrade {
        case "Iron Heart":
            maxHP += 1
            hp = maxHP
        case "Relic Sense":
            relics += 1
            hp = min(maxHP, hp + 1)
        default:
            armor += 2
        }
        flashBanner("Upgrade gained: \(upgrade)")
    }

    private func takeDamage() {
        if armor > 0 {
            armor -= 1
        } else {
            hp -= 1
        }
    }

    private func flashBanner(_ text: String) {
        banner.text = text
        banner.alpha = 1
        banner.run(.sequence([.wait(forDuration: 0.85), .fadeOut(withDuration: 0.25)]))
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
    private var decisionTimer: TimeInterval = 0
    private var decisionMade = true
    private var bestAction = "H"
    private var streak = 0
    private var lastUpdateTime: TimeInterval = 0
    private var priceLine = SKShapeNode()
    private var history: [Double] = [50]
    private let news = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let portfolio = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let pressure = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let timerBar = SKSpriteNode(color: .gold, size: CGSize(width: 320, height: 10))

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        help.text = "B: buy   S: sell   H: hold   R: restart   Esc: menu"
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

        pressure.fontSize = 16
        pressure.fontColor = SKColor.bone.withAlphaComponent(0.72)
        pressure.verticalAlignmentMode = .center
        pressure.position = CGPoint(x: size.width / 2, y: 112)
        addChild(pressure)

        timerBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        timerBar.position = CGPoint(x: size.width / 2 - 160, y: 130)
        addChild(timerBar)
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
        if key == "b" || key == "s" || key == "h" {
            handleDecision(key.uppercased())
            return
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
        if !decisionMade {
            decisionTimer -= dt
            timerBar.xScale = max(0.02, CGFloat(decisionTimer / 1.8))
            if decisionTimer <= 0 {
                cash = max(0, cash - 25)
                streak = 0
                decisionMade = true
                announce("Hesitated. Fees and slippage hit your account.")
                updateText()
            }
        }
        if eventTimer <= 0 {
            nextEvent()
            eventTimer = 1.80
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
        let events: [(String, Double, String)] = [
            ("AI hype sends risk assets flying", 1.20, "B"),
            ("Rate-cut rumor boosts the tape", 1.13, "B"),
            ("Bad earnings guidance leaks", 0.76, "S"),
            ("Short squeeze detonates", 1.32, "B"),
            ("Regulator opens investigation", 0.70, "S"),
            ("Influencer says this is the future", 1.09, "H"),
            ("Liquidity dries up before lunch", 0.86, "S"),
            ("Surprise partnership announced", 1.18, "B"),
            ("Rumor mill gets noisy and directionless", 1.00, "H"),
            ("Flash crash reverses into a rip", 1.06, "H")
        ]
        let event = events.randomElement()!
        bestAction = event.2
        decisionTimer = 1.8
        decisionMade = false
        timerBar.xScale = 1
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
        hud.text = "Stock Market Survivor   Day \(min(day, 30))/30   Price $\(Int(price))   Streak \(streak)"
        portfolio.text = "Cash $\(Int(cash))   Shares \(shares)   Portfolio $\(Int(value))"
        pressure.text = decisionMade ? "Waiting for the next market shock..." : "React now: buy, sell, or hold"
    }

    private func restart() {
        children.filter { $0.zPosition >= 1000 }.forEach { $0.removeFromParent() }
        isGameOver = false
        cash = 500
        shares = 0
        price = 50
        day = 1
        eventTimer = 1.0
        decisionTimer = 0
        decisionMade = true
        bestAction = "H"
        streak = 0
        lastUpdateTime = 0
        history = [50]
        timerBar.xScale = 1
        drawMarket()
        announce("Opening bell. Don't blow up.")
    }

    private func handleDecision(_ action: String) {
        switch action {
        case "B":
            let quantity = max(1, min(3, Int(cash / price)))
            if quantity > 0 && cash >= price {
                shares += quantity
                cash -= Double(quantity) * price
            }
        case "S":
            let quantity = max(1, min(3, shares))
            if shares > 0 {
                shares -= quantity
                cash += Double(quantity) * price
            }
        default:
            break
        }

        if !decisionMade {
            decisionMade = true
            if action == bestAction {
                streak += 1
                cash += Double(12 + streak * 4)
                announce("Good read. Streak \(streak) bonus booked.")
            } else {
                streak = 0
                cash = max(0, cash - 18)
                announce("Wrong read. Slippage clipped your account.")
            }
        }
        updateText()
    }
}

final class PongScene: BaseGameScene {
    private let player = SKShapeNode(rectOf: CGSize(width: 18, height: 112), cornerRadius: 7)
    private let ai = SKShapeNode(rectOf: CGSize(width: 18, height: 112), cornerRadius: 7)
    private let ball = SKShapeNode(circleOfRadius: 13)
    private let playerScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let aiScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private var playerScore = 0
    private var aiScore = 0
    private var ballVelocity = CGVector(dx: 430, dy: 210)
    private var moveDirection: CGFloat = 0
    private var lastUpdateTime: TimeInterval = 0

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        help.text = "W/S or arrows: move   R: restart   Esc: menu"
        hud.text = "Neon Pong Royale   First to 7"
        backgroundColor = SKColor(calibratedRed: 0.03, green: 0.04, blue: 0.07, alpha: 1)

        player.fillColor = .bone
        player.strokeColor = SKColor(calibratedRed: 0.90, green: 0.20, blue: 0.95, alpha: 1)
        player.lineWidth = 4
        player.position = CGPoint(x: 76, y: size.height / 2)
        addChild(player)

        ai.fillColor = SKColor(calibratedRed: 0.90, green: 0.20, blue: 0.95, alpha: 1)
        ai.strokeColor = .bone
        ai.lineWidth = 4
        ai.position = CGPoint(x: size.width - 76, y: size.height / 2)
        addChild(ai)

        ball.fillColor = .gold
        ball.strokeColor = .clear
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(ball)

        for y in stride(from: 112, through: size.height - 112, by: 44) {
            let dash = roundedRect(size: CGSize(width: 8, height: 22), radius: 3, color: SKColor.bone.withAlphaComponent(0.26))
            dash.position = CGPoint(x: size.width / 2, y: y)
            dash.name = "pong"
            addChild(dash)
        }

        configureScoreLabel(playerScoreLabel, x: size.width * 0.36)
        configureScoreLabel(aiScoreLabel, x: size.width * 0.64)
        updateScoreText()
        serve(towardPlayer: false)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        ai.position.x = size.width - 76
        playerScoreLabel.position = CGPoint(x: size.width * 0.36, y: size.height - 102)
        aiScoreLabel.position = CGPoint(x: size.width * 0.64, y: size.height - 102)
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
        if key == "w" || event.keyCode == 126 {
            moveDirection = 1
        } else if key == "s" || event.keyCode == 125 {
            moveDirection = -1
        }
        super.keyDown(with: event)
    }

    override func keyUp(with event: NSEvent) {
        let key = event.charactersIgnoringModifiers?.lowercased() ?? ""
        if key == "w" || key == "s" || event.keyCode == 126 || event.keyCode == 125 {
            moveDirection = 0
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = min(currentTime - lastUpdateTime, 0.033)
        lastUpdateTime = currentTime
        if isGameOver { return }

        player.position.y = clamped(player.position.y + moveDirection * 520 * CGFloat(dt), min: 96, max: size.height - 96)

        let aiTarget = ball.position.y + CGFloat.random(in: -18...18)
        let aiDelta = clamped(aiTarget - ai.position.y, min: -430 * CGFloat(dt), max: 430 * CGFloat(dt))
        ai.position.y = clamped(ai.position.y + aiDelta, min: 96, max: size.height - 96)

        ball.position.x += ballVelocity.dx * CGFloat(dt)
        ball.position.y += ballVelocity.dy * CGFloat(dt)

        if ball.position.y > size.height - 34 || ball.position.y < 34 {
            ballVelocity.dy *= -1
            ball.position.y = clamped(ball.position.y, min: 34, max: size.height - 34)
            pulse(ball, color: .bone)
        }

        if ball.frame.intersects(player.frame), ballVelocity.dx < 0 {
            rebound(from: player, direction: 1)
        }
        if ball.frame.intersects(ai.frame), ballVelocity.dx > 0 {
            rebound(from: ai, direction: -1)
        }

        if ball.position.x < -30 {
            aiScore += 1
            pointScored(towardPlayer: true)
        } else if ball.position.x > size.width + 30 {
            playerScore += 1
            pointScored(towardPlayer: false)
        }
    }

    private func configureScoreLabel(_ node: SKLabelNode, x: CGFloat) {
        node.fontSize = 54
        node.fontColor = SKColor.bone.withAlphaComponent(0.36)
        node.verticalAlignmentMode = .center
        node.position = CGPoint(x: x, y: size.height - 102)
        addChild(node)
    }

    private func rebound(from paddle: SKShapeNode, direction: CGFloat) {
        let hitOffset = (ball.position.y - paddle.position.y) / 56
        let speed = min(760, hypot(ballVelocity.dx, ballVelocity.dy) + 32)
        ballVelocity.dx = direction * speed
        ballVelocity.dy = clamped(hitOffset, min: -1.2, max: 1.2) * 360
        pulse(paddle, color: .gold)
    }

    private func pointScored(towardPlayer: Bool) {
        updateScoreText()
        if playerScore >= 7 {
            showEnd(title: "Royale Won", detail: "You beat the neon table \(playerScore)-\(aiScore).")
            return
        }
        if aiScore >= 7 {
            showEnd(title: "AI Takes The Table", detail: "Final score: \(playerScore)-\(aiScore)", color: SKColor(calibratedRed: 0.90, green: 0.20, blue: 0.95, alpha: 1))
            return
        }
        serve(towardPlayer: towardPlayer)
    }

    private func serve(towardPlayer: Bool) {
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2)
        let direction: CGFloat = towardPlayer ? -1 : 1
        ballVelocity = CGVector(dx: direction * CGFloat.random(in: 390...450), dy: CGFloat.random(in: -240...240))
    }

    private func updateScoreText() {
        playerScoreLabel.text = "\(playerScore)"
        aiScoreLabel.text = "\(aiScore)"
    }

    private func pulse(_ node: SKNode, color: SKColor) {
        let flash = SKShapeNode(circleOfRadius: 24)
        flash.fillColor = color.withAlphaComponent(0.24)
        flash.strokeColor = .clear
        flash.position = node.position
        flash.zPosition = -1
        addChild(flash)
        flash.run(.sequence([
            .group([.scale(to: 2.4, duration: 0.18), .fadeOut(withDuration: 0.18)]),
            .removeFromParent()
        ]))
    }

    private func restart() {
        children.filter { $0.zPosition >= 1000 }.forEach { $0.removeFromParent() }
        isGameOver = false
        playerScore = 0
        aiScore = 0
        player.position = CGPoint(x: 76, y: size.height / 2)
        ai.position = CGPoint(x: size.width - 76, y: size.height / 2)
        updateScoreText()
        serve(towardPlayer: false)
    }

    private func clamped(_ value: CGFloat, min minValue: CGFloat, max maxValue: CGFloat) -> CGFloat {
        Swift.max(minValue, Swift.min(maxValue, value))
    }
}

final class BrickforgeScene: BaseGameScene {
    private let paddle = SKShapeNode(rectOf: CGSize(width: 124, height: 18), cornerRadius: 8)
    private var balls: [SKShapeNode] = []
    private var bricks: [SKShapeNode] = []
    private var keysDown = Set<UInt16>()
    private var lastUpdateTime: TimeInterval = 0
    private var stage = 1
    private var lives = 3
    private var score = 0
    private var heat = 0

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = SKColor(calibratedRed: 0.06, green: 0.04, blue: 0.05, alpha: 1)
        help.text = "A/D or arrows: move   Space: heat shield   R: restart   Esc: menu"
        paddle.fillColor = .bone
        paddle.strokeColor = SKColor(calibratedRed: 1.00, green: 0.36, blue: 0.18, alpha: 1)
        paddle.lineWidth = 4
        paddle.position = CGPoint(x: size.width / 2, y: 86)
        addChild(paddle)
        startStage()
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
        keysDown.insert(event.keyCode)
        if event.keyCode == 49 && heat >= 3 {
            heat = 0
            splitBall()
            flashText("HEAT SPLIT")
        }
        super.keyDown(with: event)
    }

    override func keyUp(with event: NSEvent) {
        keysDown.remove(event.keyCode)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = min(currentTime - lastUpdateTime, 0.033)
        lastUpdateTime = currentTime
        if isGameOver { return }

        let direction: CGFloat = (keysDown.contains(2) || keysDown.contains(123) ? -1 : 0) + (keysDown.contains(0) || keysDown.contains(124) ? 1 : 0)
        paddle.position.x = clamp(paddle.position.x + direction * 620 * CGFloat(dt), 86, size.width - 86)

        for ball in balls {
            let vx = ball.userData?["vx"] as? CGFloat ?? 0
            let vy = ball.userData?["vy"] as? CGFloat ?? 0
            ball.position.x += vx * CGFloat(dt)
            ball.position.y += vy * CGFloat(dt)

            if ball.position.x < 18 || ball.position.x > size.width - 18 {
                ball.userData?["vx"] = -vx
                ball.position.x = clamp(ball.position.x, 18, size.width - 18)
                spark(at: ball.position, color: .bone)
            }
            if ball.position.y > size.height - 70 {
                ball.userData?["vy"] = -abs(vy)
                spark(at: ball.position, color: .bone)
            }
            if ball.frame.intersects(paddle.frame), vy < 0 {
                let offset = (ball.position.x - paddle.position.x) / 62
                ball.userData?["vx"] = clamp(offset, -1.25, 1.25) * 390
                ball.userData?["vy"] = abs(vy) + 18
                spark(at: ball.position, color: .gold)
            }
            if ball.position.y < -24 {
                ball.removeFromParent()
            }
        }
        balls.removeAll { $0.parent == nil }
        if balls.isEmpty {
            lives -= 1
            if lives <= 0 {
                showEnd(title: "Forge Cooled", detail: "Stage \(stage), score \(score)", color: SKColor(calibratedRed: 1.00, green: 0.36, blue: 0.18, alpha: 1))
                return
            }
            spawnBall()
        }

        for brick in bricks where brick.parent != nil {
            for ball in balls where ball.frame.intersects(brick.frame) {
                brick.removeFromParent()
                ball.userData?["vy"] = -(ball.userData?["vy"] as? CGFloat ?? 0)
                score += 25 * stage
                heat = min(3, heat + 1)
                spark(at: brick.position, color: SKColor(calibratedRed: 1.00, green: 0.36, blue: 0.18, alpha: 1))
                break
            }
        }
        bricks.removeAll { $0.parent == nil }
        if bricks.isEmpty {
            if stage >= 3 {
                showEnd(title: "Forge Mastered", detail: "All stages cleared. Score \(score)")
                return
            }
            stage += 1
            startStage()
        }
        updateHUD()
    }

    private func startStage() {
        children.filter { $0.name == "brickforge" }.forEach { $0.removeFromParent() }
        balls.forEach { $0.removeFromParent() }
        bricks.removeAll()
        balls.removeAll()
        let rows = 3 + stage
        let cols = 9
        let brickW: CGFloat = 82
        let brickH: CGFloat = 24
        let startX = size.width / 2 - CGFloat(cols - 1) * (brickW + 8) / 2
        let startY = size.height - 138
        for row in 0..<rows {
            for col in 0..<cols {
                let brick = roundedRect(size: CGSize(width: brickW, height: brickH), radius: 5, color: row % 2 == 0 ? SKColor(calibratedRed: 1.00, green: 0.36, blue: 0.18, alpha: 1) : .gold, stroke: SKColor.white.withAlphaComponent(0.12), lineWidth: 1)
                brick.position = CGPoint(x: startX + CGFloat(col) * (brickW + 8), y: startY - CGFloat(row) * (brickH + 10))
                brick.name = "brickforge"
                addChild(brick)
                bricks.append(brick)
            }
        }
        spawnBall()
        updateHUD()
        flashText("STAGE \(stage)")
    }

    private func spawnBall() {
        let ball = SKShapeNode(circleOfRadius: 12)
        ball.fillColor = .bone
        ball.strokeColor = .gold
        ball.lineWidth = 3
        ball.position = CGPoint(x: paddle.position.x, y: paddle.position.y + 44)
        ball.userData = ["vx": CGFloat.random(in: -220...220), "vy": CGFloat(420 + stage * 35)]
        ball.name = "brickforge"
        addChild(ball)
        balls.append(ball)
    }

    private func splitBall() {
        guard let source = balls.first else { return }
        for direction in [-1, 1] {
            let ball = SKShapeNode(circleOfRadius: 10)
            ball.fillColor = .gold
            ball.strokeColor = .clear
            ball.position = source.position
            ball.userData = ["vx": CGFloat(direction * 300), "vy": CGFloat(390)]
            ball.name = "brickforge"
            addChild(ball)
            balls.append(ball)
        }
    }

    private func updateHUD() {
        let heatText = String(repeating: "|", count: heat).padding(toLength: 3, withPad: ".", startingAt: 0)
        hud.text = "Brickforge Breakout   Stage \(stage)/3   Lives \(lives)   Score \(score)   Heat \(heatText)"
    }

    private func restart() {
        children.filter { $0.zPosition >= 1000 }.forEach { $0.removeFromParent() }
        isGameOver = false
        stage = 1
        lives = 3
        score = 0
        heat = 0
        lastUpdateTime = 0
        startStage()
    }
}

final class StarforgeCourierScene: BaseGameScene {
    private let ship = SKShapeNode(path: {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 24))
        path.addLine(to: CGPoint(x: -18, y: -20))
        path.addLine(to: CGPoint(x: 18, y: -20))
        path.closeSubpath()
        return path
    }())
    private let station = SKShapeNode(rectOf: CGSize(width: 108, height: 72), cornerRadius: 10)
    private var asteroids: [SKShapeNode] = []
    private var cargo: SKShapeNode?
    private var keysDown = Set<UInt16>()
    private var lastUpdateTime: TimeInterval = 0
    private var asteroidTimer: TimeInterval = 0
    private var timeLeft: TimeInterval = 60
    private var deliveries = 0
    private var shields = 3
    private var holdingCargo = false
    private var invulnerableTimer: TimeInterval = 0
    private var score = 0

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = SKColor(calibratedRed: 0.02, green: 0.04, blue: 0.08, alpha: 1)
        help.text = "WASD/arrows: fly   collect cargo, deliver to station   R: restart   Esc: menu"
        drawStarfield()
        station.fillColor = SKColor(calibratedRed: 0.25, green: 0.68, blue: 1.00, alpha: 0.18)
        station.strokeColor = SKColor(calibratedRed: 0.25, green: 0.68, blue: 1.00, alpha: 1)
        station.lineWidth = 4
        station.position = CGPoint(x: size.width - 110, y: size.height - 120)
        addChild(station)
        ship.fillColor = .bone
        ship.strokeColor = SKColor(calibratedRed: 0.25, green: 0.68, blue: 1.00, alpha: 1)
        ship.lineWidth = 4
        ship.position = CGPoint(x: 120, y: 120)
        addChild(ship)
        spawnCargo()
        updateHUD()
    }

    override func keyDown(with event: NSEvent) {
        if event.charactersIgnoringModifiers?.lowercased() == "r" {
            restart()
            return
        }
        keysDown.insert(event.keyCode)
        super.keyDown(with: event)
    }

    override func keyUp(with event: NSEvent) {
        keysDown.remove(event.keyCode)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = min(currentTime - lastUpdateTime, 0.033)
        lastUpdateTime = currentTime
        if isGameOver { return }

        timeLeft -= dt
        asteroidTimer -= dt
        invulnerableTimer -= dt
        moveShip(dt)
        if asteroidTimer <= 0 {
            spawnAsteroid()
            asteroidTimer = max(0.28, 0.72 - Double(deliveries) * 0.035)
        }
        for asteroid in asteroids {
            asteroid.position.x += (asteroid.userData?["vx"] as? CGFloat ?? -260) * CGFloat(dt)
            asteroid.position.y += (asteroid.userData?["vy"] as? CGFloat ?? 0) * CGFloat(dt)
            asteroid.zRotation += 1.4 * CGFloat(dt)
            if asteroid.position.x < -80 {
                asteroid.removeFromParent()
            } else if invulnerableTimer <= 0 && asteroid.frame.intersects(ship.frame.insetBy(dx: 4, dy: 4)) {
                hitAsteroid(asteroid)
            }
        }
        asteroids.removeAll { $0.parent == nil }
        if let cargo, !holdingCargo, cargo.frame.intersects(ship.frame) {
            cargo.removeFromParent()
            self.cargo = nil
            holdingCargo = true
            score += 50
            flashText("CARGO SECURED")
        }
        if holdingCargo && ship.frame.intersects(station.frame) {
            holdingCargo = false
            deliveries += 1
            score += 180 + deliveries * 20
            flashText("DELIVERY \(deliveries)/6")
            spawnCargo()
        }
        if deliveries >= 6 {
            showEnd(title: "Route Complete", detail: "Six deliveries landed. Score \(score)")
        } else if shields <= 0 {
            showEnd(title: "Hull Breach", detail: "Deliveries: \(deliveries)/6", color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
        } else if timeLeft <= 0 {
            showEnd(title: "Oxygen Gone", detail: "Deliveries: \(deliveries)/6   Score \(score)", color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
        }
        updateHUD()
    }

    private func moveShip(_ dt: TimeInterval) {
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        if keysDown.contains(0) || keysDown.contains(123) { dx -= 1 }
        if keysDown.contains(2) || keysDown.contains(124) { dx += 1 }
        if keysDown.contains(13) || keysDown.contains(126) { dy += 1 }
        if keysDown.contains(1) || keysDown.contains(125) { dy -= 1 }
        let speed: CGFloat = holdingCargo ? 320 : 390
        ship.position.x = clamp(ship.position.x + dx * speed * CGFloat(dt), 38, size.width - 38)
        ship.position.y = clamp(ship.position.y + dy * speed * CGFloat(dt), 70, size.height - 70)
        if dx != 0 || dy != 0 {
            ship.zRotation = atan2(-dx, dy)
        }
        ship.alpha = invulnerableTimer > 0 ? 0.55 + 0.45 * sin(CGFloat(invulnerableTimer) * 28) : 1
    }

    private func spawnCargo() {
        let node = roundedRect(size: CGSize(width: 30, height: 30), radius: 5, color: .gold, stroke: SKColor.white.withAlphaComponent(0.28), lineWidth: 2)
        node.position = CGPoint(x: CGFloat.random(in: 120...(size.width - 240)), y: CGFloat.random(in: 120...(size.height - 180)))
        node.zRotation = .pi / 4
        addChild(node)
        cargo = node
    }

    private func spawnAsteroid() {
        let asteroid = SKShapeNode(circleOfRadius: CGFloat.random(in: 16...32))
        asteroid.fillColor = SKColor(calibratedRed: 0.33, green: 0.36, blue: 0.40, alpha: 1)
        asteroid.strokeColor = SKColor.white.withAlphaComponent(0.16)
        asteroid.position = CGPoint(x: size.width + 50, y: CGFloat.random(in: 90...(size.height - 90)))
        asteroid.userData = ["vx": CGFloat.random(in: -390 ... -220), "vy": CGFloat.random(in: -80...80)]
        addChild(asteroid)
        asteroids.append(asteroid)
    }

    private func hitAsteroid(_ asteroid: SKShapeNode) {
        shields -= 1
        invulnerableTimer = 1.1
        asteroid.removeFromParent()
        spark(at: ship.position, color: SKColor(calibratedRed: 0.25, green: 0.68, blue: 1.00, alpha: 1))
    }

    private func drawStarfield() {
        for index in 0..<70 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 1...2.4))
            star.fillColor = SKColor.white.withAlphaComponent(CGFloat.random(in: 0.15...0.50))
            star.strokeColor = .clear
            star.position = CGPoint(x: CGFloat.random(in: 20...(size.width - 20)), y: CGFloat.random(in: 70...(size.height - 40)))
            star.name = "starforge"
            addChild(star)
            if index % 7 == 0 {
                star.run(.repeatForever(.sequence([.fadeAlpha(to: 0.12, duration: Double.random(in: 0.5...1.2)), .fadeAlpha(to: 0.55, duration: Double.random(in: 0.5...1.2))])))
            }
        }
    }

    private func updateHUD() {
        hud.text = "Starforge Courier   Deliveries \(deliveries)/6   Shields \(shields)   Cargo \(holdingCargo ? "ONBOARD" : "EMPTY")   Time \(Int(max(0, timeLeft)))   Score \(score)"
    }

    private func restart() {
        children.filter { $0.zPosition >= 1000 || $0.name == "starforge" }.forEach { $0.removeFromParent() }
        asteroids.forEach { $0.removeFromParent() }
        cargo?.removeFromParent()
        asteroids.removeAll()
        isGameOver = false
        deliveries = 0
        shields = 3
        holdingCargo = false
        invulnerableTimer = 0
        lastUpdateTime = 0
        asteroidTimer = 0
        timeLeft = 60
        score = 0
        ship.position = CGPoint(x: 120, y: 120)
        drawStarfield()
        spawnCargo()
        updateHUD()
    }
}

final class RhythmForgeScene: BaseGameScene {
    private struct ForgeNote {
        let lane: Int
        let node: SKShapeNode
    }

    private var notes: [ForgeNote] = []
    private let lanes: [CGFloat] = [-210, -70, 70, 210]
    private var lastUpdateTime: TimeInterval = 0
    private var spawnTimer: TimeInterval = 0.55
    private var spawned = 0
    private var hit = 0
    private var missed = 0
    private var combo = 0
    private var bestCombo = 0
    private var score = 0
    private let targetY: CGFloat = 138
    private let totalNotes = 32

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = SKColor(calibratedRed: 0.05, green: 0.03, blue: 0.08, alpha: 1)
        help.text = "A S D F: strike lanes   R: restart   Esc: menu"
        drawLanes()
        updateHUD()
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
        let laneMap = ["a": 0, "s": 1, "d": 2, "f": 3]
        if let lane = laneMap[key] {
            strike(lane)
            return
        }
        super.keyDown(with: event)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = min(currentTime - lastUpdateTime, 0.033)
        lastUpdateTime = currentTime
        if isGameOver { return }

        spawnTimer -= dt
        if spawned < totalNotes && spawnTimer <= 0 {
            spawnTimer = max(0.30, 0.54 - Double(spawned) * 0.006)
            spawnNote()
        }
        for note in notes {
            note.node.position.y -= 420 * CGFloat(dt)
            note.node.zRotation += 2.2 * CGFloat(dt)
            if note.node.position.y < targetY - 72 {
                note.node.removeFromParent()
                missed += 1
                combo = 0
                flashLane(note.lane, color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
            }
        }
        notes.removeAll { $0.node.parent == nil }
        if spawned >= totalNotes && notes.isEmpty {
            let accuracy = Int((Double(hit) / Double(totalNotes)) * 100)
            showEnd(title: accuracy >= 82 ? "Encore Cleared" : "Set Complete", detail: "Accuracy \(accuracy)%   Best combo \(bestCombo)   Score \(score)", color: accuracy >= 82 ? .gold : SKColor(calibratedRed: 0.72, green: 0.36, blue: 1.00, alpha: 1))
        }
        updateHUD()
    }

    private func drawLanes() {
        for (index, offset) in lanes.enumerated() {
            let x = size.width / 2 + offset
            let lane = roundedRect(size: CGSize(width: 92, height: size.height - 176), radius: 10, color: SKColor.white.withAlphaComponent(0.05), stroke: SKColor(calibratedRed: 0.72, green: 0.36, blue: 1.00, alpha: 0.22), lineWidth: 1)
            lane.position = CGPoint(x: x, y: size.height / 2 - 18)
            lane.name = "rhythm"
            addChild(lane)

            let target = roundedRect(size: CGSize(width: 82, height: 18), radius: 7, color: .gold.withAlphaComponent(0.30), stroke: .gold, lineWidth: 2)
            target.position = CGPoint(x: x, y: targetY)
            target.name = "rhythm"
            addChild(target)

            let key = label(["A", "S", "D", "F"][index], size: 20, color: .bone)
            key.position = CGPoint(x: x, y: 92)
            key.name = "rhythm"
            addChild(key)
        }
    }

    private func spawnNote() {
        let lane = Int.random(in: 0..<lanes.count)
        let note = SKShapeNode(rectOf: CGSize(width: 44, height: 44), cornerRadius: 8)
        note.fillColor = lane % 2 == 0 ? SKColor(calibratedRed: 0.72, green: 0.36, blue: 1.00, alpha: 1) : .gold
        note.strokeColor = SKColor.white.withAlphaComponent(0.24)
        note.lineWidth = 2
        note.position = CGPoint(x: size.width / 2 + lanes[lane], y: size.height - 92)
        note.zRotation = .pi / 4
        addChild(note)
        notes.append(ForgeNote(lane: lane, node: note))
        spawned += 1
    }

    private func strike(_ lane: Int) {
        guard let best = notes.enumerated()
            .filter({ $0.element.lane == lane })
            .min(by: { abs($0.element.node.position.y - targetY) < abs($1.element.node.position.y - targetY) }) else {
            combo = 0
            flashLane(lane, color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
            return
        }
        let distance = abs(best.element.node.position.y - targetY)
        if distance <= 58 {
            let perfect = distance <= 22
            hit += 1
            combo += 1
            bestCombo = max(bestCombo, combo)
            score += perfect ? 120 + combo * 4 : 70 + combo * 2
            flashLane(lane, color: perfect ? .gold : SKColor(calibratedRed: 0.72, green: 0.36, blue: 1.00, alpha: 1))
            spark(at: best.element.node.position, color: perfect ? .gold : SKColor(calibratedRed: 0.72, green: 0.36, blue: 1.00, alpha: 1))
            best.element.node.removeFromParent()
            notes.remove(at: best.offset)
        } else {
            combo = 0
            flashLane(lane, color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
        }
    }

    private func flashLane(_ lane: Int, color: SKColor) {
        let flash = roundedRect(size: CGSize(width: 96, height: size.height - 176), radius: 10, color: color.withAlphaComponent(0.20), stroke: .clear, lineWidth: 0)
        flash.position = CGPoint(x: size.width / 2 + lanes[lane], y: size.height / 2 - 18)
        flash.zPosition = -1
        addChild(flash)
        flash.run(.sequence([.fadeOut(withDuration: 0.18), .removeFromParent()]))
    }

    private func updateHUD() {
        hud.text = "Rhythm Forge   Hits \(hit)/\(totalNotes)   Miss \(missed)   Combo \(combo)   Best \(bestCombo)   Score \(score)"
    }

    private func restart() {
        children.filter { $0.zPosition >= 1000 || $0.name == "rhythm" }.forEach { $0.removeFromParent() }
        notes.forEach { $0.node.removeFromParent() }
        notes.removeAll()
        isGameOver = false
        lastUpdateTime = 0
        spawnTimer = 0.55
        spawned = 0
        hit = 0
        missed = 0
        combo = 0
        bestCombo = 0
        score = 0
        drawLanes()
        updateHUD()
    }
}

final class CampusDashScene: BaseGameScene {
    private let runner = SKShapeNode(circleOfRadius: 20)
    private let goal = SKShapeNode(rectOf: CGSize(width: 250, height: 44), cornerRadius: 8)
    private var bikes: [SKShapeNode] = []
    private var notes: [SKShapeNode] = []
    private var keysDown = Set<UInt16>()
    private var lastUpdateTime: TimeInterval = 0
    private var bikeTimer: TimeInterval = 0
    private var noteTimer: TimeInterval = 0
    private var invulnerableTimer: TimeInterval = 0
    private var timeLeft: TimeInterval = 45
    private var hearts = 3
    private var noteCount = 0
    private var score = 0

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = SKColor(calibratedRed: 0.04, green: 0.08, blue: 0.07, alpha: 1)
        help.text = "WASD/arrows: move   collect 5 notes   R: restart   Esc: menu"

        goal.fillColor = SKColor(calibratedRed: 0.15, green: 0.78, blue: 0.49, alpha: 0.26)
        goal.strokeColor = SKColor(calibratedRed: 0.15, green: 0.78, blue: 0.49, alpha: 1)
        goal.lineWidth = 3
        goal.position = CGPoint(x: size.width / 2, y: size.height - 82)
        addChild(goal)

        let goalLabel = label("CLASS", size: 17, color: SKColor(calibratedRed: 0.15, green: 0.78, blue: 0.49, alpha: 1))
        goalLabel.position = goal.position
        goalLabel.name = "campus"
        addChild(goalLabel)

        for lane in 0..<5 {
            let line = SKShapeNode(rectOf: CGSize(width: size.width - 160, height: 2), cornerRadius: 1)
            line.fillColor = SKColor.bone.withAlphaComponent(0.08)
            line.strokeColor = .clear
            line.position = CGPoint(x: size.width / 2, y: 160 + CGFloat(lane) * 82)
            line.name = "campus"
            addChild(line)
        }

        runner.fillColor = .bone
        runner.strokeColor = SKColor(calibratedRed: 0.98, green: 0.63, blue: 0.12, alpha: 1)
        runner.lineWidth = 4
        runner.position = startPosition()
        addChild(runner)

        for _ in 0..<5 {
            spawnNote()
        }
        updateHUD()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        goal.position = CGPoint(x: size.width / 2, y: size.height - 82)
    }

    override func keyDown(with event: NSEvent) {
        if event.charactersIgnoringModifiers?.lowercased() == "r" {
            restart()
            return
        }
        keysDown.insert(event.keyCode)
        super.keyDown(with: event)
    }

    override func keyUp(with event: NSEvent) {
        keysDown.remove(event.keyCode)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = min(currentTime - lastUpdateTime, 0.033)
        lastUpdateTime = currentTime
        if isGameOver { return }

        timeLeft -= dt
        bikeTimer -= dt
        noteTimer -= dt
        invulnerableTimer -= dt

        moveRunner(dt)
        if bikeTimer <= 0 {
            spawnBike()
            bikeTimer = max(0.32, 0.78 - Double(score) * 0.006)
        }
        if noteTimer <= 0 && notes.count < 7 {
            spawnNote()
            noteTimer = 3.5
        }

        for bike in bikes {
            let vx = bike.userData?["vx"] as? CGFloat ?? 0
            bike.position.x += vx * CGFloat(dt)
            if bike.position.x < -80 || bike.position.x > size.width + 80 {
                bike.removeFromParent()
            } else if invulnerableTimer <= 0 && bike.frame.intersects(runner.frame.insetBy(dx: 4, dy: 4)) {
                hitBike()
            }
        }
        bikes.removeAll { $0.parent == nil }

        for note in notes where note.frame.intersects(runner.frame) {
            note.removeFromParent()
            noteCount += 1
            score += 35
            pulse(at: note.position, color: .gold)
        }
        notes.removeAll { $0.parent == nil }

        if runner.frame.intersects(goal.frame) && noteCount >= 5 {
            showEnd(title: "Made It To Class", detail: "Notes: \(noteCount)   Score: \(score + Int(timeLeft) * 10)")
        } else if timeLeft <= 0 {
            showEnd(title: "Late Again", detail: "You reached \(noteCount)/5 notes.", color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
        }
        updateHUD()
    }

    private func moveRunner(_ dt: TimeInterval) {
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        if keysDown.contains(0) || keysDown.contains(123) { dx -= 1 }
        if keysDown.contains(2) || keysDown.contains(124) { dx += 1 }
        if keysDown.contains(13) || keysDown.contains(126) { dy += 1 }
        if keysDown.contains(1) || keysDown.contains(125) { dy -= 1 }
        let length = max(1, hypot(dx, dy))
        let speed: CGFloat = noteCount >= 5 ? 335 : 300
        runner.position.x = clamped(runner.position.x + dx / length * speed * CGFloat(dt), min: 46, max: size.width - 46)
        runner.position.y = clamped(runner.position.y + dy / length * speed * CGFloat(dt), min: 60, max: size.height - 48)
        runner.alpha = invulnerableTimer > 0 ? 0.55 : 1
    }

    private func spawnBike() {
        let fromLeft = Bool.random()
        let bike = SKShapeNode(rectOf: CGSize(width: 58, height: 24), cornerRadius: 7)
        bike.fillColor = SKColor(calibratedRed: 0.16, green: 0.55, blue: 0.95, alpha: 1)
        bike.strokeColor = .clear
        bike.position = CGPoint(x: fromLeft ? -40 : size.width + 40, y: CGFloat.random(in: 150...(size.height - 150)))
        bike.userData = ["vx": (fromLeft ? CGFloat.random(in: 220...360) : -CGFloat.random(in: 220...360))]
        addChild(bike)
        bikes.append(bike)
    }

    private func spawnNote() {
        let note = SKShapeNode(circleOfRadius: 12)
        note.fillColor = .gold
        note.strokeColor = .clear
        note.position = CGPoint(x: CGFloat.random(in: 96...(size.width - 96)), y: CGFloat.random(in: 150...(size.height - 150)))
        addChild(note)
        notes.append(note)
    }

    private func hitBike() {
        hearts -= 1
        invulnerableTimer = 1.2
        score = max(0, score - 25)
        pulse(at: runner.position, color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
        runner.position = startPosition()
        if hearts <= 0 {
            showEnd(title: "Campus Collision", detail: "Collected \(noteCount)/5 notes.", color: SKColor(calibratedRed: 0.95, green: 0.18, blue: 0.16, alpha: 1))
        }
    }

    private func updateHUD() {
        hud.text = "Campus Dash   Notes \(noteCount)/5   Hearts \(hearts)   Time \(max(0, Int(ceil(timeLeft))))   Score \(score)"
    }

    private func restart() {
        children.filter { $0.zPosition >= 1000 }.forEach { $0.removeFromParent() }
        bikes.forEach { $0.removeFromParent() }
        notes.forEach { $0.removeFromParent() }
        bikes.removeAll()
        notes.removeAll()
        keysDown.removeAll()
        lastUpdateTime = 0
        bikeTimer = 0
        noteTimer = 0
        invulnerableTimer = 0
        timeLeft = 45
        hearts = 3
        noteCount = 0
        score = 0
        isGameOver = false
        runner.position = startPosition()
        for _ in 0..<5 {
            spawnNote()
        }
        updateHUD()
    }

    private func pulse(at point: CGPoint, color: SKColor) {
        let flash = SKShapeNode(circleOfRadius: 20)
        flash.fillColor = color.withAlphaComponent(0.26)
        flash.strokeColor = .clear
        flash.position = point
        addChild(flash)
        flash.run(.sequence([
            .group([.scale(to: 2.6, duration: 0.22), .fadeOut(withDuration: 0.22)]),
            .removeFromParent()
        ]))
    }

    private func startPosition() -> CGPoint {
        CGPoint(x: size.width / 2, y: 72)
    }

    private func clamped(_ value: CGFloat, min minValue: CGFloat, max maxValue: CGFloat) -> CGFloat {
        Swift.max(minValue, Swift.min(maxValue, value))
    }
}
