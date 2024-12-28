//
//  TitleCell.swift
//  SiliciumCalendar
//
//  Created by Nikolai Eremenko on 18.12.2024.
//

import UIKit

protocol TitleCellDelegate: AnyObject {
    func didTapDoneButton(title: String)
}

class TitleCell: UITableViewCell {
    // MARK: - Properties
    weak var delegate: TitleCellDelegate?
    
    // MARK: - UI Components
    private lazy var titleTextField: UITextField = {
        let view = UITextField()
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.returnKeyType = .done
        view.clearButtonMode = .whileEditing
        view.placeholder = "Title"
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config
    func configure(with title: String?) {
        guard let title else { return }
        
        titleTextField.text = title
    }
    
    // MARK: - Actions
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        delegate?.didTapDoneButton(title: text)
    }
    
    // MARK: - Constraints
    func setupViews() {
        contentView.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension TitleCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        delegate?.didTapDoneButton(title: text)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text else { return }
        
        delegate?.didTapDoneButton(title: text)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
