//
//  TasksCell.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import UIKit

final class TasksCell: UITableViewCell {
    // MARK: - Properties
    private var tasks: [Task]?
    
    private let params = GeometricParams(
        topInset: 2,
        bottomInset: 2,
        leftInset: 0,
        rightInset: 3,
        cellSpacing: 3
    )

    // MARK: - UI Components
    private lazy var tasksHStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .bottom
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(TaskCell.self,
                      forCellWithReuseIdentifier: TaskCell.reuseIdentifier)
        view.allowsMultipleSelection = false
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Config
    func configure(with tasks: [Task]?, cellDate: Date) {
        timeLabel.text = DateFormatter.shortTimeFormatter.string(from: cellDate)
        
        self.tasks = tasks
        collectionView.reloadData()
    }
    
    private func setupViews() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 40),

            collectionView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
}

// MARK: - Collection DataSource
extension TasksCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return tasks?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TaskCell.reuseIdentifier,
                for: indexPath
            ) as? TaskCell,
            let task = tasks?[indexPath.row]
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: task, color: .cyan)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TasksCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellCount = tasks?.count ?? 0
        let paddingWidth = params.leftInset + params.rightInset + CGFloat(cellCount - 1) * params.cellSpacing
        let availableSpace = collectionView.frame.width - paddingWidth
        let cellWidth = availableSpace / CGFloat(cellCount)
        let cellHeight = collectionView.frame.height - params.topInset - params.bottomInset

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        let insets = UIEdgeInsets(
            top: params.topInset,
            left: params.leftInset,
            bottom: params.bottomInset,
            right: params.rightInset
        )

        return insets
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {

        return params.cellSpacing
    }
}
