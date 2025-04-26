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
    
    private func setupEmitter() {
        emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2, y: 0)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        
        for color in [UIColor.systemRed, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemYellow, UIColor.systemPurple] {
            cells.append(confettiCell(color: color))
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
    }
    
    private func confettiCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 5
        cell.lifetime = 10
        cell.velocity = 150
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.spin = 3.5
        cell.spinRange = 1
        cell.color = color.cgColor
        cell.contents = UIImage(systemName: "star.fill")?.cgImage
        cell.scaleRange = 0.3
        cell.scale = 0.1
        
        return cell
    }
    
    func startConfetti() {
        emitter.birthRate = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.stopConfetti()
        }
    }
    
    func stopConfetti() {
        emitter.birthRate = 0
    }
}

