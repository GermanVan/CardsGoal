import UIKit

class StageNameCell: UITableViewCell {
    let nameTextField = UITextField()
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
        contentView.addSubview(nameTextField)
        contentView.addSubview(deleteButton)

        nameTextField.borderStyle = .roundedRect
        nameTextField.font = UIFont.boldSystemFont(ofSize: 16)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        deleteButton.setTitle("Удалить шаг", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
}

