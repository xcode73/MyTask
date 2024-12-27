//
//  TasksCell.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import UIKit

final class TasksCell: UITableViewCell  {
    // MARK: - Properties
    private var date = Date()
    private var taskStore: TaskStoreProtocol?
    
    private let params = GeometricParams(
        topInset: 2,
        bottomInset: 2,
        leftInset: 0,
        rightInset: 3,
        cellSpacing: 3
    )

    // MARK: - UI Components
    @IBOutlet 
    weak var timeLabel: UILabel!
    
    @IBOutlet 
    weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TaskCell.nib(), forCellWithReuseIdentifier: TaskCell.reuseIdentifier)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: TasksCell.reuseIdentifier, bundle: nil)
    }
    
    // MARK: - Cell Config
    func configure(with taskDataStore: TaskDataStore, cellDate: Date) {
        timeLabel.text = DateFormatter.shortTimeFormatter.string(from: cellDate)
        date = cellDate
        taskStore = setupTaskStore(taskDataStore: taskDataStore)
        collectionView.reloadData()
    }
    
    private func setupTaskStore(taskDataStore: TaskDataStore) -> TaskStore? {
        do {
            let taskStore = try TaskStore(taskDataStore,
                                 delegate: self,
                                 date: date)
            return taskStore
        } catch {
            return nil
        }
    }
}

// MARK: - Collection DataSource
extension TasksCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return taskStore?.numberOfItemsInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.reuseIdentifier,
                                                          for: indexPath) as? TaskCell,
            let task = taskStore?.taskObject(at: indexPath)
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

        let cellCount = taskStore?.numberOfItemsInSection() ?? 0
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

// MARK: - TaskStoreDelegate
extension TasksCell: TaskStoreDelegate {
    func didUpdate(_ updates: [TaskStoreUpdate]) {
        var movedToIndexPaths = [IndexPath]()
        
        collectionView.performBatchUpdates({
            for update in updates {
                switch update {
                case let .deleted(from: indexPath):
                    collectionView.deleteItems(at: [indexPath])
                case let .inserted(at: indexPath):
                    collectionView.insertItems(at: [indexPath])
                case let .updated(at: indexPath):
                    collectionView.reloadItems(at: [indexPath])
                case let .moved(from: source, to: target):
                    collectionView.moveItem(at: source, to: target)
                    movedToIndexPaths.append(target)
                }
            }
        }, completion: { done in
            self.collectionView.reloadItems(at: movedToIndexPaths)
        })
    }
}
