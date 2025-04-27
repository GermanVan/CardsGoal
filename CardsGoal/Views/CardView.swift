import UIKit

protocol CardViewDelegate: AnyObject {
    func cardWasFlipped(_ card: CardView)
    func cardWasUnflipped(_ card: CardView)
    func mediumCardTapped(_ card: CardView)
    func cardPositionChanged(_ card: CardView, position: CGPoint)
    func canInteractWithSmallCard() -> Bool
}

class CardView: UIView {
    weak var delegate: CardViewDelegate?
    var taskId: UUID!
    var taskTitle: String = ""
    var taskLevel: TaskLevel = .small
    var isCompleted: Bool = false {
        didSet { updateAppearance() }
    }
    private let frontView = UIView()
    private let backView = UIView()
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    private var isFaceUp = true
    private var originalPosition: CGPoint = .zero

    init(task: Task, theme: ColorTheme) {
        super.init(frame: .zero)
        self.taskId = task.id
        self.taskTitle = task.title
        self.taskLevel = task.level
        self.isCompleted = task.isCompleted
        setupViews(with: theme)
        setupGestures()
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    private func setupViews(with theme: ColorTheme) {
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        let cardColor: UIColor
        switch taskLevel {
        case .small:
            cardColor = theme.smallTaskColor
            frame.size = CGSize(width: 140, height: 100)
        case .medium:
            cardColor = theme.mediumTaskColor
            frame.size = CGSize(width: 180, height: 120)
        case .global:
            cardColor = theme.globalTaskColor
            frame.size = CGSize(width: 220, height: 140)
        }
        frontView.frame = bounds
        frontView.backgroundColor = cardColor
        frontView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(frontView)
        backView.frame = bounds
        backView.backgroundColor = cardColor.withAlphaComponent(0.8)
        backView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backView.isHidden = true
        addSubview(backView)
        titleLabel.frame = frontView.bounds.insetBy(dx: 10, dy: 10)
        titleLabel.text = taskTitle
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        frontView.addSubview(titleLabel)
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkImageView.tintColor = .white
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.frame = CGRect(x: backView.bounds.width - 40, y: backView.bounds.height - 40, width: 30, height: 30)
        checkmarkImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        backView.addSubview(checkmarkImageView)
        updateAppearance()
    }

    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    private func updateAppearance() {
        if isCompleted {
            if isFaceUp { flipCard() }
        } else {
            if !isFaceUp { flipCard() }
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        switch gesture.state {
        case .began:
            originalPosition = center
            superview?.bringSubviewToFront(self)
        case .changed:
            center = CGPoint(x: originalPosition.x + translation.x, y: originalPosition.y + translation.y)
        case .ended, .cancelled:
            delegate?.cardPositionChanged(self, position: center)
        default:
            break
        }
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        switch taskLevel {
        case .small:
            guard delegate?.canInteractWithSmallCard() ?? false
            else {
                return
            }
            isCompleted = !isCompleted
            if isCompleted {
                delegate?.cardWasFlipped(self)
            } else {
                delegate?.cardWasUnflipped(self)
            }
        case .medium, .global:
            guard !isCompleted else {
                 return
            }
            delegate?.mediumCardTapped(self)
        }
    }

    func flipCard() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        UIView.transition(with: self, duration: 0.5, options: transitionOptions, animations: {
            self.frontView.isHidden = self.isFaceUp
            self.backView.isHidden = !self.isFaceUp
        }, completion: { _ in
            self.isFaceUp = !self.isFaceUp
        })
    }
}

