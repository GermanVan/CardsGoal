import UIKit

class GameViewController: UIViewController, CardViewDelegate {
    private let scoreLabel = UILabel()
    private let nextStageButton = UIButton(type: .system)
    private let gameManager = GameManager.shared
    private var cardViews: [CardView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = gameManager.currentStage?.title ?? "Шаг"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 18)
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        nextStageButton.setTitle("Перейти к следующему шагу", for: .normal)
        nextStageButton.backgroundColor = .systemGreen
        nextStageButton.setTitleColor(.white, for: .normal)
        nextStageButton.layer.cornerRadius = 12
        nextStageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        nextStageButton.translatesAutoresizingMaskIntoConstraints = false
        nextStageButton.addTarget(self, action: #selector(nextStageButtonTapped), for: .touchUpInside)
        view.addSubview(nextStageButton)
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextStageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nextStageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nextStageButton.heightAnchor.constraint(equalToConstant: 50),
            nextStageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        createCards()
        updateUI()
    }

    private func createCards() {
        for cardView in cardViews { cardView.removeFromSuperview() }
        cardViews.removeAll()
        guard let currentStage = gameManager.currentStage else { return }
        for task in currentStage.tasks {
            let cardView = CardView(task: task, theme: gameManager.selectedTheme)
            cardView.delegate = self
            if let position = task.position {
                cardView.center = position
            } else {
                let centerX = view.bounds.width / 2
                let centerY = view.bounds.height / 2
                let randomOffsetX = CGFloat.random(in: -100...100)
                let randomOffsetY = CGFloat.random(in: -100...100)
                cardView.center = CGPoint(x: centerX + randomOffsetX, y: centerY + randomOffsetY)
            }
            view.addSubview(cardView)
            cardViews.append(cardView)
        }
    }

    private func updateUI() {
        scoreLabel.text = "Очки: \(gameManager.score)"
        if let stage = gameManager.currentStage,
           let mediumTask = stage.mediumTask,
           stage.canCompleteMediumTask && !mediumTask.isCompleted {
            nextStageButton.isHidden = false
        } else {
            nextStageButton.isHidden = true
        }
    }

    @objc private func nextStageButtonTapped() {
        gameManager.completeMediumTask()
        title = gameManager.currentStage?.title ?? "Шаг"
        createCards()
        updateUI()
    }

    func cardWasFlipped(_ card: CardView) {
        _ = gameManager.completeTask(card.taskId)
        updateUI()
    }

    func cardWasUnflipped(_ card: CardView) {
        _ = gameManager.uncompleteTask(card.taskId)
        updateUI()
    }

    func cardPositionChanged(_ card: CardView, position: CGPoint) {
        gameManager.updateTaskPosition(taskId: card.taskId, position: position)
    }
}
