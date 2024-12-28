//
//  TaskStore.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 26.12.2024.
//

import RealmSwift

protocol TaskStoreProtocol {
    func numberOfItemsInSection() -> Int?
    func taskObject(at indexPath: IndexPath) -> Task?
    func add(task: Task) throws
    func update(task: Task) throws
    func delete(task: Task) throws
}

protocol TaskStoreDelegate: AnyObject {
    func didUpdate(_ update: [TaskStoreUpdate])
}

enum TaskStoreUpdate: Hashable {
    case inserted(indexPath: IndexPath)
    case deleted(from: IndexPath)
    case updated(indexPath: IndexPath)
    case moved(from: IndexPath, toIndexPath: IndexPath)
}

final class TaskStore {
    weak var delegate: TaskStoreDelegate?
    var inProgressChanges: [TaskStoreUpdate] = []
    
    private let dataStore: TaskDataStore?
    private var date: Date?
    private var notificationToken: NotificationToken?
    
    enum TrackerDataProviderError: Error {
        case failedToOpenRealmFile
    }
    
    private lazy var results: Results<TaskRealm>? = {
        guard let date, let dataStore else { return nil }
        
        let objects = dataStore.objects(for: date)
        
        return objects
    }()
    
    init(
        _ dataStore: TaskDataStore,
        delegate: TaskStoreDelegate? = nil,
        date: Date? = nil
    ) throws {
        self.dataStore = dataStore
        self.delegate = delegate
        self.date = date
        
        setupNotificationToken()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func setupNotificationToken() {
        self.notificationToken = results?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self else { return }
            
            switch changes {
            case .initial:
                self.inProgressChanges.removeAll()
            case .update(_, let deletions, let insertions, let modifications):
                self.inProgressChanges.append(contentsOf: deletions.map { TaskStoreUpdate.deleted(from: IndexPath(row: $0, section: 0)) })
                self.inProgressChanges.append(contentsOf: insertions.map { TaskStoreUpdate.inserted(indexPath: IndexPath(row: $0, section: 0)) })
                self.inProgressChanges.append(contentsOf: modifications.map { TaskStoreUpdate.updated(indexPath: IndexPath(row: $0, section: 0)) })
                
                self.delegate?.didUpdate(self.inProgressChanges)
                self.inProgressChanges.removeAll()
            case .error(let err):
                fatalError("\(err)")
            }
        }
    }
}

// MARK: - TaskStoreProtocol
extension TaskStore: TaskStoreProtocol {
    func numberOfItemsInSection() -> Int? {
        return results?.count
    }
    
    func taskObject(at indexPath: IndexPath) -> Task? {
        guard let storedTask = results?[indexPath.row] else { return nil }
        
        return Task(id: storedTask.id,
                    name: storedTask.name,
                    dateStart: storedTask.dateStart,
                    dateFinish: storedTask.dateFinish,
                    description: storedTask.about)
    }
    
    func add(task: Task) throws {
        let object = TaskRealm()
        object.id = task.id
        object.name = task.name
        object.dateStart = task.dateStart
        object.dateFinish = task.dateFinish
        object.about = task.description
        
        try? dataStore?.add(object)
    }
    
    func update(task: Task) throws {
        try? dataStore?.update(task: task)
    }
    
    func delete(task: Task) throws {
        try? dataStore?.delete(objectId: task.id)
    }
}
