//
//  DateCell.swift
//  SiliciumCalendar
//
//  Created by Nikolai Eremenko on 18.12.2024.
//

import UIKit

protocol DateCellDelegate: AnyObject {
    func didSelectDate(date: Date, indexPath: IndexPath)
}

class DateCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: DateCellDelegate?
    private var indexPath: IndexPath?
    
    // MARK: - UI Components
    private lazy var cellHStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .dateAndTime
        view.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textColor = .black
        
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
    func configure(with date: Date?, indexPath: IndexPath) {
        
        if let date {
            datePicker.date = date
        }
        
        self.indexPath = indexPath
        
        let title = indexPath.row == 0 ? "Starts" : "Ends"
        titleLabel.text = title
    }
    
    // MARK: - Actions
    @objc
    private func didSelectDate(_ sender: UIDatePicker) {
        guard let indexPath else { return }
        
        delegate?.didSelectDate(date: sender.date, indexPath: indexPath)
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(cellHStack)
        cellHStack.addArrangedSubview(titleLabel)
        cellHStack.addArrangedSubview(datePicker)
        
        NSLayoutConstraint.activate([
            cellHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellHStack.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
}
