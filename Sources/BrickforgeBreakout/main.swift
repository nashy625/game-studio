import AppKit
import Foundation
import SpriteKit

private let appSize = CGSize(width: 1280, height: 720)
private let highScoreKey = "brickforge.breakout.highScore"

@main
final class BrickforgeAppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!
    private var skView: BrickforgeView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)

        skView = BrickforgeView(frame: CGRect(origin: .zero, size: appSize))
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = false

        window = NSWindow(
            contentRect: CGRect(origin: .zero, size: appSize),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Brickforge Breakout"
        window.center()
        window.contentView = skView
        window.makeKeyAndOrderFront(nil)
        presentTitle()
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    private func presentTitle() {
        let scene = BrickforgeTitleScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.onStart = { [weak self] in self?.presentGame() }
        skView.presentScene(scene, transition: .crossFade(withDuration: 0.28))
    }

    private func presentGame() {
        let scene = BrickforgeGameScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.onExit = { [weak self] in self?.presentTitle() }
        skView.presentScene(scene, transition: .push(with: .left, duration: 0.22))
    }
}

final class BrickforgeView: SKView {
    override var acceptsFirstResponder: Bool { true }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.makeFirstResponder(self)
    }
}

extension SKColor {
    static let bfInk = SKColor(calibratedRed: 0.045, green: 0.035, blue: 0.045, alpha: 1)
    static let bfPanel = SKColor(calibratedRed: 0.105, green: 0.075, blue: 0.075, alpha: 1)
    static let bfBone = SKColor(calibratedRed: 0.94, green: 0.89, blue: 0.78, alpha: 1)
    static let bfGold = SKColor(calibratedRed: 1.0, green: 0.72, blue: 0.24, alpha: 1)
    static let bfEmber = SKColor(calibratedRed: 1.0, green: 0.29, blue: 0.14, alpha: 1)
    static let bfBlue = SKColor(calibratedRed: 0.25, green: 0.68, blue: 1.0, alpha: 1)
    static let bfViolet = SKColor(calibratedRed: 0.72, green: 0.36, blue: 1.0, alpha: 1)
}

private func bfLabel(_ text: String, size: CGFloat, color: SKColor = .bfBone, weight: NSFont.Weight = .bold) -> SKLabelNode {
    let node = SKLabelNode(fontNamed: "AvenirNext-\(weight == .bold ? "Bold" : "Medium")")
    node.text = text
    node.fontSize = size
    node.fontColor = color
    node.verticalAlignmentMode = .center
    return node
}

private func bfRect(size: CGSize, radius: CGFloat, color: SKColor, stroke: SKColor? = nil, lineWidth: CGFloat = 2) -> SKShapeNode {
    let rect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
    let node = SKShapeNode(rect: rect, cornerRadius: radius)
    node.fillColor = color
    node.strokeColor = stroke ?? color
    node.lineWidth = lineWidth
    return node
}

private func bfClamp(_ value: CGFloat, _ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
    Swift.max(minValue, Swift.min(maxValue, value))
}

final class BrickforgeTitleScene: SKScene {
    var onStart: (() -> Void)?
    private var startFrame = CGRect.zero

    override func didMove(to view: SKView) {
        backgroundColor = .bfInk
        build()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        removeAllChildren()
        build()
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 36 || event.keyCode == 49 {
            onStart?()
        }
    }

    override func mouseDown(with event: NSEvent) {
        if startFrame.contains(event.location(in: self)) {
            onStart?()
        }
    }

    private func build() {
        drawBackdrop()

        let deck = bfRect(size: CGSize(width: min(1120, size.width - 92), height: min(560, size.height - 110)), radius: 10, color: SKColor.black.withAlphaComponent(0.20), stroke: SKColor.bfBone.withAlphaComponent(0.08), lineWidth: 1)
        deck.position = CGPoint(x: size.width / 2, y: size.height / 2 - 8)
        deck.zPosition = -5
        addChild(deck)

        let eyebrow = bfLabel("STEAM RELEASE CANDIDATE", size: 14, color: .bfGold, weight: .regular)
        eyebrow.position = CGPoint(x: size.width / 2, y: size.height - 94)
        addChild(eyebrow)

        let title = bfLabel("Brickforge Breakout", size: 64, color: .bfBone)
        title.position = CGPoint(x: size.width / 2, y: size.height - 152)
        addChild(title)

        let subtitle = bfLabel("A forge-hot brick breaker with staged clears, heat splits, powerups, and score-chasing runs.", size: 18, color: SKColor.bfBone.withAlphaComponent(0.72), weight: .regular)
        subtitle.position = CGPoint(x: size.width / 2, y: size.height - 200)
        addChild(subtitle)

        let highScore = UserDefaults.standard.integer(forKey: highScoreKey)
        if highScore > 0 {
            let best = bfLabel("Best score \(highScore)", size: 16, color: SKColor.bfGold.withAlphaComponent(0.82), weight: .regular)
            best.position = CGPoint(x: size.width / 2, y: size.height - 232)
            addChild(best)
        }

        drawHeroCapsule()
        drawFeatureStrip()

        let start = bfRect(size: CGSize(width: 246, height: 54), radius: 8, color: .bfEmber, stroke: .bfGold, lineWidth: 2)
        start.position = CGPoint(x: size.width / 2, y: 112)
        startFrame = CGRect(x: start.position.x - 123, y: start.position.y - 27, width: 246, height: 54)
        addChild(start)

        let startText = bfLabel("START RUN", size: 18, color: .bfInk)
        startText.position = start.position
        addChild(startText)

        let controls = bfLabel("A/D or arrows move   Space spends heat   P pauses   R restarts   Esc returns here", size: 15, color: SKColor.bfBone.withAlphaComponent(0.58), weight: .regular)
        controls.position = CGPoint(x: size.width / 2, y: 58)
        addChild(controls)
    }

    private func drawBackdrop() {
        for index in 0..<44 {
            let spark = SKShapeNode(circleOfRadius: CGFloat.random(in: 1.4...3.4))
            spark.fillColor = (index % 4 == 0 ? SKColor.bfEmber : SKColor.bfGold).withAlphaComponent(CGFloat.random(in: 0.10...0.34))
            spark.strokeColor = .clear
            spark.position = CGPoint(x: CGFloat.random(in: 36...(size.width - 36)), y: CGFloat.random(in: 44...(size.height - 36)))
            spark.zPosition = -9
            addChild(spark)
            spark.run(.repeatForever(.sequence([
                .fadeAlpha(to: 0.06, duration: Double.random(in: 0.7...1.4)),
                .fadeAlpha(to: 0.32, duration: Double.random(in: 0.7...1.4))
            ])))
        }
    }

    private func drawHeroCapsule() {
        let capsule = bfRect(size: CGSize(width: 560, height: 260), radius: 12, color: SKColor.bfPanel, stroke: SKColor.bfEmber.withAlphaComponent(0.72), lineWidth: 2)
        capsule.position = CGPoint(x: size.width / 2, y: size.height / 2 + 12)
        addChild(capsule)

        for row in 0..<5 {
            for col in 0..<9 {
                let color: SKColor = row % 2 == 0 ? .bfEmber : .bfGold
                let brick = bfRect(size: CGSize(width: 44, height: 20), radius: 4, color: color.withAlphaComponent(0.76), stroke: SKColor.white.withAlphaComponent(0.10), lineWidth: 1)
                brick.position = CGPoint(x: capsule.position.x - 198 + CGFloat(col) * 50, y: capsule.position.y + 82 - CGFloat(row) * 28)
                addChild(brick)
            }
        }

        let paddle = bfRect(size: CGSize(width: 164, height: 18), radius: 8, color: .bfBone, stroke: .bfEmber, lineWidth: 3)
        paddle.position = CGPoint(x: capsule.position.x, y: capsule.position.y - 94)
        addChild(paddle)

        for offset in [-82, 0, 82] {
            let ball = SKShapeNode(circleOfRadius: 13)
            ball.fillColor = offset == 0 ? .bfBone : .bfGold
            ball.strokeColor = .bfEmber
            ball.lineWidth = 2
            ball.position = CGPoint(x: capsule.position.x + CGFloat(offset), y: capsule.position.y - 36 + CGFloat(abs(offset) / 4))
            addChild(ball)
        }
    }

    private func drawFeatureStrip() {
        let features = [
            ("10 stages", "progressive layouts"),
            ("Powerups", "wide, shield, slow, split"),
            ("Run score", "combo and perfect clears"),
            ("Steam prep", "standalone app bundle")
        ]
        let totalWidth: CGFloat = min(900, size.width - 96)
        let itemWidth = totalWidth / CGFloat(features.count)
        let y: CGFloat = 178
        for (index, feature) in features.enumerated() {
            let x = size.width / 2 - totalWidth / 2 + itemWidth / 2 + CGFloat(index) * itemWidth
            let box = bfRect(size: CGSize(width: itemWidth - 18, height: 72), radius: 8, color: SKColor.white.withAlphaComponent(0.045), stroke: SKColor.bfBone.withAlphaComponent(0.10), lineWidth: 1)
            box.position = CGPoint(x: x, y: y)
            addChild(box)

            let top = bfLabel(feature.0.uppercased(), size: 13, color: .bfGold)
            top.position = CGPoint(x: x, y: y + 14)
            addChild(top)

            let bottom = bfLabel(feature.1, size: 12, color: SKColor.bfBone.withAlphaComponent(0.60), weight: .regular)
            bottom.position = CGPoint(x: x, y: y - 12)
            addChild(bottom)
        }
    }
}

private enum BrickPower: CaseIterable {
    case heat, wide, shield, slow, multiball

    var label: String {
        switch self {
        case .heat: return "HEAT"
        case .wide: return "WIDE"
        case .shield: return "SHIELD"
        case .slow: return "SLOW"
        case .multiball: return "SPLIT"
        }
    }

    var color: SKColor {
        switch self {
        case .heat: return .bfEmber
        case .wide: return .bfGold
        case .shield: return .bfBlue
        case .slow: return .bfViolet
        case .multiball: return .bfBone
        }
    }
}

final class BrickforgeGameScene: SKScene {
    var onExit: (() -> Void)?

    private let hud = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let help = SKLabelNode(fontNamed: "AvenirNext-Medium")
    private let paddle = SKShapeNode(rectOf: CGSize(width: 142, height: 18), cornerRadius: 8)
    private let shieldLine = SKShapeNode(rectOf: CGSize(width: 860, height: 8), cornerRadius: 4)
    private var balls: [SKShapeNode] = []
    private var bricks: [SKShapeNode] = []
    private var powerups: [SKShapeNode] = []
    private var keysDown = Set<UInt16>()
    private var lastUpdateTime: TimeInterval = 0
    private var stage = 1
    private var lives = 4
    private var score = 0
    private var combo = 0
    private var bestCombo = 0
    private var highScore = UserDefaults.standard.integer(forKey: highScoreKey)
    private var heat = 0
    private var shields = 1
    private var slowTimer: TimeInterval = 0
    private var wideTimer: TimeInterval = 0
    private var runPaused = false
    private var isGameOver = false

    override func didMove(to view: SKView) {
        backgroundColor = .bfInk
        setupScene()
        startStage()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        hud.position = CGPoint(x: 26, y: size.height - 32)
        help.position = CGPoint(x: size.width - 26, y: size.height - 32)
    }

    override func keyDown(with event: NSEvent) {
        let key = event.charactersIgnoringModifiers?.lowercased() ?? ""
        if event.keyCode == 53 {
            onExit?()
            return
        }
        if key == "r" {
            restart()
            return
        }
        if key == "p" {
            togglePause()
            return
        }
        if isGameOver || runPaused { return }
        keysDown.insert(event.keyCode)
        if event.keyCode == 49 {
            spendHeat()
        }
    }

    override func keyUp(with event: NSEvent) {
        keysDown.remove(event.keyCode)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let rawDt = min(currentTime - lastUpdateTime, 0.033)
        lastUpdateTime = currentTime
        if isGameOver || runPaused { return }

        let dt = rawDt * (slowTimer > 0 ? 0.58 : 1.0)
        slowTimer -= rawDt
        wideTimer -= rawDt
        if wideTimer <= 0 {
            paddle.xScale = 1
        }

        movePaddle(dt)
        moveBalls(dt)
        movePowerups(dt)
        if bricks.isEmpty {
            finishStage()
        }
        updateHUD()
    }

    private func setupScene() {
        drawBackdrop()

        hud.fontSize = 20
        hud.fontColor = .bfBone
        hud.horizontalAlignmentMode = .left
        hud.verticalAlignmentMode = .center
        hud.position = CGPoint(x: 26, y: size.height - 32)
        addChild(hud)

        help.fontSize = 14
        help.fontColor = SKColor.bfBone.withAlphaComponent(0.64)
        help.horizontalAlignmentMode = .right
        help.verticalAlignmentMode = .center
        help.position = CGPoint(x: size.width - 26, y: size.height - 32)
        help.text = "A/D or arrows move   Space spends heat   P pause   R restart   Esc title"
        addChild(help)

        paddle.fillColor = .bfBone
        paddle.strokeColor = .bfEmber
        paddle.lineWidth = 4
        paddle.position = CGPoint(x: size.width / 2, y: 82)
        addChild(paddle)

        shieldLine.fillColor = .bfBlue.withAlphaComponent(0.26)
        shieldLine.strokeColor = .bfBlue
        shieldLine.lineWidth = 2
        shieldLine.position = CGPoint(x: size.width / 2, y: 48)
        shieldLine.alpha = 0
        addChild(shieldLine)
    }

    private func drawBackdrop() {
        let arena = bfRect(size: CGSize(width: size.width - 86, height: size.height - 120), radius: 12, color: SKColor.black.withAlphaComponent(0.18), stroke: SKColor.bfBone.withAlphaComponent(0.08), lineWidth: 1)
        arena.position = CGPoint(x: size.width / 2, y: size.height / 2 - 18)
        arena.zPosition = -10
        arena.name = "arena"
        addChild(arena)

        for row in 0..<9 {
            let line = SKShapeNode(rectOf: CGSize(width: size.width - 150, height: 1), cornerRadius: 1)
            line.fillColor = SKColor.bfBone.withAlphaComponent(0.035)
            line.strokeColor = .clear
            line.position = CGPoint(x: size.width / 2, y: 120 + CGFloat(row) * 58)
            line.zPosition = -9
            line.name = "arena"
            addChild(line)
        }
    }

    private func startStage() {
        children.filter { $0.name == "brick" || $0.name == "ball" || $0.name == "powerup" }.forEach { $0.removeFromParent() }
        balls.removeAll()
        bricks.removeAll()
        powerups.removeAll()
        combo = 0
        slowTimer = 0
        wideTimer = 0
        paddle.xScale = 1
        paddle.position = CGPoint(x: size.width / 2, y: 82)

        let cols = 10
        let rows = 4 + min(stage, 6)
        let brickW: CGFloat = min(94, (size.width - 190) / CGFloat(cols))
        let brickH: CGFloat = 24
        let gap: CGFloat = 8
        let totalW = CGFloat(cols) * brickW + CGFloat(cols - 1) * gap
        let startX = size.width / 2 - totalW / 2 + brickW / 2
        let startY = size.height - 126

        for row in 0..<rows {
            for col in 0..<cols {
                if stage >= 4 && row % 3 == 1 && col % 4 == 0 { continue }
                if stage >= 7 && row % 4 == 2 && col % 3 == 1 { continue }
                let durability = 1 + (stage >= 5 && row < 2 ? 1 : 0) + (stage >= 9 && col % 5 == 0 ? 1 : 0)
                let brick = bfRect(size: CGSize(width: brickW, height: brickH), radius: 5, color: brickColor(row: row, durability: durability), stroke: SKColor.white.withAlphaComponent(0.12), lineWidth: 1)
                brick.position = CGPoint(x: startX + CGFloat(col) * (brickW + gap), y: startY - CGFloat(row) * (brickH + 9))
                brick.name = "brick"
                brick.userData = [
                    "hp": durability,
                    "maxHP": durability,
                    "power": shouldDropPower(row: row, col: col) ? BrickPower.allCases.randomElement()!.label : ""
                ]
                addChild(brick)
                bricks.append(brick)
            }
        }

        spawnBall()
        flash("STAGE \(stage)", color: .bfGold)
        updateHUD()
    }

    private func brickColor(row: Int, durability: Int) -> SKColor {
        if durability >= 3 { return .bfViolet }
        if durability == 2 { return .bfGold }
        return row % 2 == 0 ? .bfEmber : SKColor(calibratedRed: 1.0, green: 0.47, blue: 0.18, alpha: 1)
    }

    private func shouldDropPower(row: Int, col: Int) -> Bool {
        ((row * 7 + col * 5 + stage) % 13 == 0) || Int.random(in: 0..<100) < 5
    }

    private func movePaddle(_ dt: TimeInterval) {
        let left = keysDown.contains(0) || keysDown.contains(123)
        let right = keysDown.contains(2) || keysDown.contains(124)
        let direction: CGFloat = (left ? -1 : 0) + (right ? 1 : 0)
        let halfWidth = 71 * paddle.xScale
        paddle.position.x = bfClamp(paddle.position.x + direction * 700 * CGFloat(dt), halfWidth + 32, size.width - halfWidth - 32)
    }

    private func moveBalls(_ dt: TimeInterval) {
        for ball in balls {
            guard ball.parent != nil else { continue }
            var vx = ball.userData?["vx"] as? CGFloat ?? 0
            var vy = ball.userData?["vy"] as? CGFloat ?? 0
            ball.position.x += vx * CGFloat(dt)
            ball.position.y += vy * CGFloat(dt)

            if ball.position.x < 26 || ball.position.x > size.width - 26 {
                vx *= -1
                ball.position.x = bfClamp(ball.position.x, 26, size.width - 26)
                ball.userData?["vx"] = vx
                spark(at: ball.position, color: .bfBone)
            }
            if ball.position.y > size.height - 68 {
                vy = -abs(vy)
                ball.userData?["vy"] = vy
                spark(at: ball.position, color: .bfBone)
            }
            if ball.frame.intersects(paddle.frame), vy < 0 {
                let offset = (ball.position.x - paddle.position.x) / max(42, 71 * paddle.xScale)
                vx = bfClamp(offset, -1.25, 1.25) * 420
                vy = min(740, abs(vy) + 18 + CGFloat(stage * 3))
                ball.userData?["vx"] = vx
                ball.userData?["vy"] = vy
                spark(at: ball.position, color: .bfGold)
                playTick()
            }
            if shields > 0 && ball.position.y < 56 && ball.position.y > 42 {
                shields -= 1
                shieldLine.alpha = shields > 0 ? 1 : 0
                ball.position.y = 60
                vy = abs(vy)
                ball.userData?["vy"] = vy
                spark(at: ball.position, color: .bfBlue)
            } else if ball.position.y < -28 {
                ball.removeFromParent()
            }
        }
        balls.removeAll { $0.parent == nil }
        if balls.isEmpty {
            loseLife()
        }
        collideBricks()
    }

    private func collideBricks() {
        for brick in bricks where brick.parent != nil {
            for ball in balls where ball.parent != nil && ball.frame.intersects(brick.frame) {
                ball.userData?["vy"] = -(ball.userData?["vy"] as? CGFloat ?? 0)
                hitBrick(brick)
                break
            }
        }
        bricks.removeAll { $0.parent == nil }
    }

    private func hitBrick(_ brick: SKShapeNode) {
        let hp = (brick.userData?["hp"] as? Int ?? 1) - 1
        combo += 1
        bestCombo = max(bestCombo, combo)
        score += 25 * stage + combo * 2
        heat = min(5, heat + 1)
        if hp > 0 {
            brick.userData?["hp"] = hp
            brick.fillColor = .bfEmber
            addCrack(to: brick, hp: hp)
            brick.run(.sequence([.scale(to: 1.08, duration: 0.04), .scale(to: 1.0, duration: 0.08)]))
        } else {
            let powerName = brick.userData?["power"] as? String ?? ""
            if let power = BrickPower.allCases.first(where: { $0.label == powerName }) {
                spawnPowerup(power, at: brick.position)
            }
            spark(at: brick.position, color: brick.fillColor)
            if combo % 8 == 0 {
                shakeArena(strength: 8)
            }
            brick.removeFromParent()
        }
        playTick()
    }

    private func movePowerups(_ dt: TimeInterval) {
        for node in powerups {
            node.position.y -= 160 * CGFloat(dt)
            if node.position.y < -30 {
                node.removeFromParent()
            } else if node.frame.intersects(paddle.frame) {
                let label = node.userData?["power"] as? String ?? ""
                if let power = BrickPower.allCases.first(where: { $0.label == label }) {
                    apply(power)
                }
                node.removeFromParent()
            }
        }
        powerups.removeAll { $0.parent == nil }
    }

    private func spawnPowerup(_ power: BrickPower, at point: CGPoint) {
        let node = bfRect(size: CGSize(width: 72, height: 24), radius: 7, color: power.color.withAlphaComponent(0.86), stroke: SKColor.white.withAlphaComponent(0.20), lineWidth: 1)
        node.position = point
        node.name = "powerup"
        node.userData = ["power": power.label]
        addChild(node)

        let text = bfLabel(power.label, size: 10, color: .bfInk)
        text.position = .zero
        node.addChild(text)
        powerups.append(node)
    }

    private func apply(_ power: BrickPower) {
        switch power {
        case .heat:
            heat = min(5, heat + 3)
            flash("+HEAT", color: .bfEmber)
        case .wide:
            wideTimer = 10
            paddle.xScale = 1.55
            flash("WIDE PADDLE", color: .bfGold)
        case .shield:
            shields = min(3, shields + 1)
            shieldLine.alpha = 1
            flash("SHIELD READY", color: .bfBlue)
        case .slow:
            slowTimer = 8
            flash("TIME TEMPERED", color: .bfViolet)
        case .multiball:
            splitBalls(count: 2)
            flash("MULTIBALL", color: .bfBone)
        }
        playTick()
        updateHUD()
    }

    private func spendHeat() {
        guard heat >= 5 else {
            flash("NEED FULL HEAT", color: SKColor.bfBone.withAlphaComponent(0.72))
            return
        }
        heat = 0
        splitBalls(count: 3)
        score += 75
        shakeArena(strength: 13)
        flash("FORGE SPLIT", color: .bfEmber)
    }

    private func splitBalls(count: Int) {
        guard let source = balls.first(where: { $0.parent != nil }) else { return }
        for index in 0..<count {
            let ball = makeBall(at: source.position)
            let spread = CGFloat(index - count / 2) * 170
            ball.userData = ["vx": spread == 0 ? CGFloat.random(in: -120...120) : spread, "vy": CGFloat.random(in: 410...520)]
            addChild(ball)
            balls.append(ball)
        }
    }

    private func spawnBall() {
        let ball = makeBall(at: CGPoint(x: paddle.position.x, y: paddle.position.y + 46))
        ball.userData = ["vx": CGFloat.random(in: -210...210), "vy": CGFloat(440 + stage * 18)]
        addChild(ball)
        balls.append(ball)
    }

    private func makeBall(at point: CGPoint) -> SKShapeNode {
        let ball = SKShapeNode(circleOfRadius: 12)
        ball.fillColor = .bfBone
        ball.strokeColor = .bfGold
        ball.lineWidth = 3
        ball.position = point
        ball.name = "ball"
        return ball
    }

    private func loseLife() {
        lives -= 1
        combo = 0
        if lives <= 0 {
            endRun(title: "Forge Cooled", color: .bfEmber)
            return
        }
        shakeArena(strength: 16)
        flash("LIFE LOST", color: .bfEmber)
        spawnBall()
    }

    private func finishStage() {
        score += 300 + stage * 100 + lives * 50
        if stage >= 10 {
            endRun(title: "Forge Mastered", color: .bfGold)
            return
        }
        stage += 1
        startStage()
    }

    private func endRun(title: String, color: SKColor) {
        isGameOver = true
        let isNewBest = score > highScore
        if isNewBest {
            highScore = score
            UserDefaults.standard.set(score, forKey: highScoreKey)
        }
        let panel = bfRect(size: CGSize(width: 560, height: 230), radius: 10, color: .bfPanel, stroke: color, lineWidth: 3)
        panel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        panel.zPosition = 1000
        addChild(panel)

        let titleNode = bfLabel(title, size: 38, color: color)
        titleNode.position = CGPoint(x: size.width / 2, y: size.height / 2 + 62)
        titleNode.zPosition = 1001
        addChild(titleNode)

        let detailText = isNewBest ? "NEW BEST \(score)   Stage \(stage)/10   Best combo \(bestCombo)" : "Score \(score)   Best \(highScore)   Best combo \(bestCombo)"
        let detail = bfLabel(detailText, size: 18, color: .bfBone, weight: .regular)
        detail.position = CGPoint(x: size.width / 2, y: size.height / 2 + 12)
        detail.zPosition = 1001
        addChild(detail)

        let prompt = bfLabel("Press R to restart or Esc for title", size: 16, color: SKColor.bfBone.withAlphaComponent(0.68), weight: .regular)
        prompt.position = CGPoint(x: size.width / 2, y: size.height / 2 - 52)
        prompt.zPosition = 1001
        addChild(prompt)
    }

    private func togglePause() {
        runPaused.toggle()
        children.filter { $0.name == "pause" }.forEach { $0.removeFromParent() }
        if runPaused {
            let panel = bfRect(size: CGSize(width: 420, height: 132), radius: 10, color: .bfPanel, stroke: .bfGold, lineWidth: 2)
            panel.name = "pause"
            panel.zPosition = 950
            panel.position = CGPoint(x: size.width / 2, y: size.height / 2)
            addChild(panel)

            let paused = bfLabel("PAUSED", size: 32, color: .bfGold)
            paused.name = "pause"
            paused.zPosition = 951
            paused.position = CGPoint(x: size.width / 2, y: size.height / 2 + 22)
            addChild(paused)

            let prompt = bfLabel("Press P to resume", size: 16, color: SKColor.bfBone.withAlphaComponent(0.70), weight: .regular)
            prompt.name = "pause"
            prompt.zPosition = 951
            prompt.position = CGPoint(x: size.width / 2, y: size.height / 2 - 24)
            addChild(prompt)
        }
    }

    private func restart() {
        children.filter { $0.zPosition >= 900 || $0.name == "brick" || $0.name == "ball" || $0.name == "powerup" || $0.name == "pause" }.forEach { $0.removeFromParent() }
        balls.removeAll()
        bricks.removeAll()
        powerups.removeAll()
        keysDown.removeAll()
        lastUpdateTime = 0
        stage = 1
        lives = 4
        score = 0
        combo = 0
        bestCombo = 0
        heat = 0
        shields = 1
        highScore = UserDefaults.standard.integer(forKey: highScoreKey)
        shieldLine.alpha = 1
        runPaused = false
        isGameOver = false
        startStage()
    }

    private func updateHUD() {
        let heatText = String(repeating: "|", count: heat).padding(toLength: 5, withPad: ".", startingAt: 0)
        hud.text = "Brickforge Breakout   Stage \(stage)/10   Lives \(lives)   Shields \(shields)   Score \(score)   Best \(max(score, highScore))   Combo \(combo)   Heat \(heatText)"
        shieldLine.alpha = shields > 0 ? 1 : 0
    }

    private func addCrack(to brick: SKShapeNode, hp: Int) {
        brick.children.filter { $0.name == "crack" }.forEach { $0.removeFromParent() }
        for index in 0..<(4 - min(3, hp)) {
            let crack = SKShapeNode()
            crack.name = "crack"
            let path = CGMutablePath()
            let startX = CGFloat.random(in: -32...18)
            path.move(to: CGPoint(x: startX, y: CGFloat.random(in: -6...8)))
            path.addLine(to: CGPoint(x: startX + CGFloat.random(in: 16...38), y: CGFloat.random(in: -8...9)))
            crack.path = path
            crack.strokeColor = SKColor.bfInk.withAlphaComponent(0.42)
            crack.lineWidth = CGFloat(index + 1)
            crack.zPosition = 2
            brick.addChild(crack)
        }
    }

    private func shakeArena(strength: CGFloat) {
        let original = CGPoint(x: size.width / 2, y: size.height / 2)
        let shake = SKAction.sequence([
            .moveBy(x: -strength, y: strength * 0.35, duration: 0.025),
            .moveBy(x: strength * 1.65, y: -strength * 0.45, duration: 0.025),
            .moveBy(x: -strength * 0.65, y: strength * 0.10, duration: 0.025)
        ])
        let restore = SKAction.run { [weak self] in
            guard let self else { return }
            self.position = CGPoint(x: original.x - self.size.width / 2, y: original.y - self.size.height / 2)
        }
        run(.sequence([shake, restore]), withKey: "arenaShake")
    }

    private func flash(_ text: String, color: SKColor) {
        let node = bfLabel(text, size: 26, color: color)
        node.position = CGPoint(x: size.width / 2, y: size.height - 92)
        node.zPosition = 900
        addChild(node)
        node.run(.sequence([
            .group([.moveBy(x: 0, y: 18, duration: 0.55), .fadeOut(withDuration: 0.55)]),
            .removeFromParent()
        ]))
    }

    private func spark(at point: CGPoint, color: SKColor) {
        for _ in 0..<12 {
            let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 2.5...6.5))
            dot.fillColor = color
            dot.strokeColor = .clear
            dot.position = point
            dot.zPosition = 700
            addChild(dot)
            dot.run(.sequence([
                .group([
                    .moveBy(x: CGFloat.random(in: -48...48), y: CGFloat.random(in: -48...48), duration: 0.30),
                    .fadeOut(withDuration: 0.30),
                    .scale(to: 0.22, duration: 0.30)
                ]),
                .removeFromParent()
            ]))
        }
    }

    private func playTick() {
        if score % 5 == 0 {
            NSSound.beep()
        }
    }
}
