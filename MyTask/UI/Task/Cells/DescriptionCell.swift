//
//  DescriptionCell.swift
//  SiliciumCalendar
//
//  Created by Nikolai Eremenko on 18.12.2024.
//

import UIKit

protocol DescriptionCellDelegate: AnyObject {
    func descriptionChanged(text: String)
}

class DescriptionCell: UITableViewCell {
    // MARK: - Properties
    weak var delegate: DescriptionCellDelegate?
    
    // MARK: - UI Components
    private lazy var descriptionTextField: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textColor = .black
        view.text = "Description"
        view.textColor = .lightGray
        view.contentInsetAdjustmentBehavior = .automatic
        view.returnKeyType = .done
        view.isSelectable = true
        view.isEditable = true
        view.delegate = self
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
        
        descriptionTextField.text = title
    }
    
    // MARK: - Constraints
    func setupViews() {
        contentView.addSubview(descriptionTextField)
        
        NSLayoutConstraint.activate([
            descriptionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            descriptionTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension DescriptionCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextField.textColor == .lightGray && descriptionTextField.isFirstResponder {
            descriptionTextField.text = nil
            descriptionTextField.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextField.text.isEmpty {
            descriptionTextField.textColor = .lightGray
            descriptionTextField.text = "Description"
        }
        
        delegate?.descriptionChanged(text: descriptionTextField.text)
    }
}
