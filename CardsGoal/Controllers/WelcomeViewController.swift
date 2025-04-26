import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    private let titleLabel = UILabel()
    private let goalTextField = UITextField()
    private let startButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        titleLabel.text = "Cards Goal"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        goalTextField.placeholder = "Введите Вашу заветную цель"
        goalTextField.borderStyle = .roundedRect
        goalTextField.font = UIFont.systemFont(ofSize: 17)
        goalTextField.translatesAutoresizingMaskIntoConstraints = false
        goalTextField.delegate = self
        view.addSubview(goalTextField)
        startButton.setTitle("Начать", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 12
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            goalTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            goalTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            goalTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            goalTextField.heightAnchor.constraint(equalToConstant: 50),
            startButton.topAnchor.constraint(equalTo: goalTextField.bottomAnchor, constant: 30),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            startButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    @objc private func startButtonTapped() {
        guard let goalText = goalTextField.text, !goalText.isEmpty else {
            let alert = UIAlertController(title: "Внимание", message: "Пожалуйста, введите Вашу глобальную цель", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let globalTask = Task(title: goalText, level: .global)
        GameManager.shared.goal = globalTask
        let themeVC = ThemeSelectionViewController()
        navigationController?.pushViewController(themeVC, animated: true)
    }
}
