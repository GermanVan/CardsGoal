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
        setupUI()
        createCards()
        updateUI()
    }

    private func setupUI() {
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
    }


    private func createCards() {
        for cardView in cardViews { cardView.removeFromSuperview() }
        cardViews.removeAll()
        guard let currentStage = gameManager.currentStage else { return }
        let lastStage = gameManager.stages.last

        for task in currentStage.tasks {
            if (task.level == .medium || task.level == .global) && task.isCompleted { continue }
            if task.level == .global && currentStage != lastStage { continue }

            let cardView = CardView(task: task, theme: gameManager.selectedTheme)
            cardView.delegate = self
            if let position = task.position {
                cardView.center = position
            } else {
                let centerX = view.bounds.width / 2
                let centerY = view.bounds.height / 2
                let availableWidth = view.bounds.width - cardView.frame.width - 40
                let availableHeight = view.bounds.height - cardView.frame.height - 150
                let randomX = CGFloat.random(in: (cardView.frame.width / 2 + 20)...(view.bounds.width - cardView.frame.width / 2 - 20))
                let randomY = CGFloat.random(in: (cardView.frame.height / 2 + 80)...(view.bounds.height - cardView.frame.height / 2 - 70))

                cardView.center = CGPoint(x: randomX, y: randomY)
            }
            view.addSubview(cardView)
            cardViews.append(cardView)
            view.bringSubviewToFront(nextStageButton)
        }
    }

    private func updateUI() {
        scoreLabel.text = "Очки: \(gameManager.score)"
        let allSmallDone = gameManager.areAllSmallTasksCompleted()
        let canAfford = gameManager.score >= (gameManager.currentStage?.requiredPointsForCompletion ?? 0)
        
        nextStageButton.isHidden = !allSmallDone
        if allSmallDone {
            nextStageButton.isEnabled = canAfford
            nextStageButton.backgroundColor = canAfford ? .systemGreen : .systemGray
        } else {
            nextStageButton.isEnabled = false
            nextStageButton.backgroundColor = .systemGray
        }
    }

    @objc private func nextStageButtonTapped() {
        if gameManager.canCompleteCurrentMediumTask() {
            gameManager.completeMediumTask()
            title = gameManager.currentStage?.title ?? "Шаг"
            createCards()
            updateUI()
            let lastStageIndex = gameManager.stages.count - 1
             if gameManager.stages.indices.contains(lastStageIndex) &&
                 gameManager.currentStageIndex == lastStageIndex &&
                 gameManager.stages[lastStageIndex].isCompleted {
                  showCongratulations()
             }
        }
    }

    func cardWasFlipped(_ card: CardView) {
        _ = gameManager.completeTask(card.taskId)
        updateUI()
    }

    func cardWasUnflipped(_ card: CardView) {
        _ = gameManager.uncompleteTask(card.taskId)
        updateUI()
    }

    func mediumCardTapped(_ card: CardView) {
        if gameManager.canCompleteCurrentMediumTask() {
            gameManager.completeMediumTask()
            card.isCompleted = true
            title = gameManager.currentStage?.title ?? "Шаг"
            createCards()
            updateUI()
            let lastStageIndex = gameManager.stages.count - 1
             if gameManager.stages.indices.contains(lastStageIndex) &&
                gameManager.currentStageIndex == lastStageIndex &&
                gameManager.stages[lastStageIndex].isCompleted {
                 showCongratulations()
            }
        } else if gameManager.areAllSmallTasksCompleted() {
            showAlert(message: "Недостаточно очков для завершения шага. Необходимо: \(gameManager.currentStage?.requiredPointsForCompletion ?? 0)")
        } else {
             showAlert(message: "Сначала выполните все задачи этого шага.")
        }
    }

    func cardPositionChanged(_ card: CardView, position: CGPoint) {
        gameManager.updateTaskPosition(taskId: card.taskId, position: position)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showCongratulations() {
         let alert = UIAlertController(
             title: "Поздравляем! 🎉",
             message: "Вы выполнили все шаги и достигли своей цели!",
             preferredStyle: .alert
         )
         alert.addAction(UIAlertAction(title: "Начать заново", style: .default) { _ in
             self.gameManager.reset()
             self.navigationController?.popToRootViewController(animated: true)
         })
         present(alert, animated: true)
     }
}
