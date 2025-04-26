import UIKit

class StageSetupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let startGameButton = UIButton(type: .system)
    private let addStageButton = UIButton(type: .system)
    private var stageNames: [String] = [""]
    private var stageTasks: [[String]] = [[""]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройка шагов"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StageNameCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddTaskCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        startGameButton.setTitle("Начать игру", for: .normal)
        startGameButton.backgroundColor = .systemBlue
        startGameButton.setTitleColor(.white, for: .normal)
        startGameButton.layer.cornerRadius = 12
        startGameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
        view.addSubview(startGameButton)
        addStageButton.setTitle("Добавить шаг", for: .normal)
        addStageButton.backgroundColor = .systemGreen
        addStageButton.setTitleColor(.white, for: .normal)
        addStageButton.layer.cornerRadius = 12
        addStageButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addStageButton.translatesAutoresizingMaskIntoConstraints = false
        addStageButton.addTarget(self, action: #selector(addStageButtonTapped), for: .touchUpInside)
        view.addSubview(addStageButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addStageButton.topAnchor, constant: -10),
            addStageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addStageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addStageButton.bottomAnchor.constraint(equalTo: startGameButton.topAnchor, constant: -10),
            addStageButton.heightAnchor.constraint(equalToConstant: 44),
            startGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            startGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            startGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func addStageButtonTapped() {
        stageNames.append("")
        stageTasks.append([""])
        tableView.reloadData()
    }
    
    @objc func startGameButtonTapped() {
        while !stageNames.isEmpty && stageNames.last?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            stageNames.removeLast()
            stageTasks.removeLast()
        }
        guard !stageNames.isEmpty else {
            showAlert(message: "Пожалуйста, добавьте хотя бы один шаг")
            return
        }
        guard !stageNames.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) else {
            showAlert(message: "Пожалуйста, заполните названия всех шагов")
            return
        }
        
        for (index, tasks) in stageTasks.enumerated() {
            let currentTasks = tasks.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            if currentTasks.isEmpty {
                showAlert(message: "Пожалуйста, добавьте и заполните хотя бы одну задачу для шага \(index + 1)")
                return
            }
            let existingTaskFields = tasks
            if currentTasks.count < existingTaskFields.count {
                showAlert(message: "Пожалуйста, заполните названия всех задач для шага \(index + 1)")
                return
            }
        }
        createStages()
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }

    private func createStages() {
        GameManager.shared.stages = []
        for (index, stageName) in stageNames.enumerated() {
            var tasks: [Task] = []
            let smallTasks = stageTasks[index].filter { !$0.isEmpty }
            for taskTitle in smallTasks {
                let task = Task(title: taskTitle, level: .small)
                tasks.append(task)
            }
            let mediumTask = Task(title: stageName, level: .medium)
            tasks.append(mediumTask)
            let stage = Stage(title: stageName, tasks: tasks)
            GameManager.shared.stages.append(stage)
        }
        if let goal = GameManager.shared.goal {
            var lastStage = GameManager.shared.stages.last!
            lastStage.tasks.append(goal)
            GameManager.shared.stages[GameManager.shared.stages.count - 1] = lastStage
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return stageNames.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + stageTasks[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StageNameCell", for: indexPath)
            var textField: UITextField! = cell.contentView.subviews.compactMap { $0 as? UITextField }.first
            if textField == nil {
                textField = UITextField()
                textField.borderStyle = .roundedRect
                textField.font = UIFont.boldSystemFont(ofSize: 16)
                textField.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(textField)
                NSLayoutConstraint.activate([
                    textField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    textField.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    textField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
                ])
            }
            textField.text = stageNames[section]
            textField.placeholder = "Название шага \(section + 1)"
            textField.tag = section
            textField.delegate = self
            return cell
        } else if indexPath.row <= stageTasks[section].count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
            let taskIndex = indexPath.row - 1
            var textField: UITextField! = cell.contentView.subviews.compactMap { $0 as? UITextField }.first
            if textField == nil {
                textField = UITextField()
                textField.borderStyle = .roundedRect
                textField.font = UIFont.systemFont(ofSize: 15)
                textField.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(textField)
                NSLayoutConstraint.activate([
                    textField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 32),
                    textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    textField.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    textField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
                ])
            }
            textField.text = stageTasks[section][taskIndex]
            textField.placeholder = "Задача \(taskIndex + 1)"
            textField.tag = 1000 + section * 100 + taskIndex
            textField.delegate = self
            
            var deleteButton: UIButton! = cell.contentView.subviews.compactMap { $0 as? UIButton }.first
                if deleteButton == nil {
                    deleteButton = UIButton(type: .system)
                    deleteButton.setTitle("Удалить", for: .normal)
                    deleteButton.setTitleColor(.systemRed, for: .normal)
                    deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    deleteButton.translatesAutoresizingMaskIntoConstraints = false
                    cell.contentView.addSubview(deleteButton)
                    NSLayoutConstraint.activate([
                        deleteButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                        deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                        deleteButton.widthAnchor.constraint(equalToConstant: 60),
                        deleteButton.heightAnchor.constraint(equalToConstant: 30)
                    ])
                }
                deleteButton.tag = section * 1000 + taskIndex
                deleteButton.addTarget(self, action: #selector(deleteTaskButtonTapped(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskCell", for: indexPath)
            var button: UIButton! = cell.contentView.subviews.compactMap { $0 as? UIButton }.first
            if button == nil {
                button = UIButton(type: .system)
                button.setTitle("Добавить задачу", for: .normal)
                button.backgroundColor = .systemGray5
                button.setTitleColor(.systemBlue, for: .normal)
                button.layer.cornerRadius = 8
                button.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(button)
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    button.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    button.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                    button.heightAnchor.constraint(equalToConstant: 36)
                ])
            }
            button.isHidden = stageTasks[section].count >= 8
            button.tag = section
            button.addTarget(self, action: #selector(addTaskButtonTapped(_:)), for: .touchUpInside)
            return cell
        }
    }

    @objc func addTaskButtonTapped(_ sender: UIButton) {
        let stageIndex = sender.tag
        guard stageIndex < stageTasks.count else { return }
        if stageTasks[stageIndex].count < 8 {
            stageTasks[stageIndex].append("")
            tableView.reloadData()
        }
    }
    
    @objc func deleteTaskButtonTapped(_ sender: UIButton) {
        let section = sender.tag / 1000
        let taskIndex = sender.tag % 1000
        guard section < stageTasks.count, taskIndex < stageTasks[section].count else { return }
        if stageTasks[section].count <= 1 {
            let alert = UIAlertController(title: "Ошибка", message: "В каждом шаге должна быть как минимум одна задача.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        stageTasks[section].remove(at: taskIndex)
        tableView.reloadData()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        if tag < 1000 {
            let stageIndex = tag
            if stageIndex < stageNames.count {
                stageNames[stageIndex] = textField.text ?? ""
            }
        } else {
            let adjustedTag = tag - 1000
            let stageIndex = adjustedTag / 100
            let taskIndex = adjustedTag % 100
            if stageIndex < stageTasks.count && taskIndex < stageTasks[stageIndex].count {
                stageTasks[stageIndex][taskIndex] = textField.text ?? ""
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
