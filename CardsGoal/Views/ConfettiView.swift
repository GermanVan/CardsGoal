import UIKit

class ConfettiView: UIView {

    private var emitter: CAEmitterLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmitter()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmitter()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
    }


    private func setupEmitter() {
        emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2, y: 0)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        emitter.birthRate = 0

        let blueCell = confettiCell(color: .systemBlue)
        emitter.emitterCells = [blueCell]

        layer.addSublayer(emitter)
    }

    private func createColoredStarImage(color: UIColor, size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let path = UIBezierPath()
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2
            let pointsOnStar = 5

            var angle = -CGFloat.pi / 2
            let angleIncrement = .pi * 2 / CGFloat(pointsOnStar)
            let outerRadius = radius
            let innerRadius = radius * 0.4

            for i in 0..<pointsOnStar * 2 {
                let r = (i % 2 == 0) ? outerRadius : innerRadius
                let point = CGPoint(
                    x: center.x + r * cos(angle),
                    y: center.y + r * sin(angle)
                )
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
                angle += angleIncrement / 2
            }
            path.close()

            color.setFill()
            path.fill()
        }
        return image
    }


    private func confettiCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 10.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = CGFloat.random(in: 180...280)
        cell.velocityRange = 60
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = CGFloat.random(in: 1...5)
        cell.spinRange = 3
        cell.scaleRange = 0.4
        cell.scale = 0.1
        cell.scaleSpeed = -0.02
        cell.contents = createColoredStarImage(color: color, size: CGSize(width: 30, height: 30))?.cgImage
        return cell
    }

    func startConfetti() {
        superview?.bringSubviewToFront(self)
        emitter.birthRate = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.stopConfetti()
        }
    }

    func stopConfetti() {
        emitter.birthRate = 0
    }
}

