//
//  TaskCell.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import UIKit

final class TaskCell: UICollectionViewCell {
    // MARK: - UI Components
    private lazy var taskHStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5
        view.distribution = .fill
        view.alignment = .center
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var taskColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var taskDetailVStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var taskTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task, color: UIColor) {
        taskTitleLabel.text = task.name
        taskHStack.backgroundColor = color.withAlphaComponent(0.3)
        taskColorView.backgroundColor = color
        
        let start = DateFormatter.shortTimeFormatter.string(from: task.dateStart)
        let end = DateFormatter.shortTimeFormatter.string(from: task.dateFinish)
        
        taskTimeLabel.text = start + " - " + end
    }
    
    private func setupViews() {
        contentView.addSubview(taskHStack)
        
        taskHStack.addArrangedSubview(taskColorView)
        taskHStack.addArrangedSubview(taskDetailVStack)
        
        taskDetailVStack.addArrangedSubview(taskTitleLabel)
        taskDetailVStack.addArrangedSubview(taskTimeLabel)
        
        
        NSLayoutConstraint.activate([
            taskHStack.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            taskHStack.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            taskColorView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            taskColorView.widthAnchor.constraint(equalToConstant: 6),
        ])
    }
}
