import UIKit

class TaskCell: UITableViewCell {
    let taskTextField = UITextField()
    let deleteButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(taskTextField)
        contentView.addSubview(deleteButton)

        taskTextField.borderStyle = .roundedRect
        taskTextField.font = UIFont.systemFont(ofSize: 15)
        taskTextField.translatesAutoresizingMaskIntoConstraints = false

        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            taskTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            taskTextField.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            taskTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            taskTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}

