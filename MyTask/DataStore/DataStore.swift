//
//  DataStore.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 26.12.2024.
//

import RealmSwift

protocol TaskDataStore {
    func objects(for date: Date) -> Results<TaskRealm>?
    func add(_ object: TaskRealm) throws
    func update(task: Task) throws
    func delete(objectId: Int) throws
}

final class DataStore {
    private let realm: Realm
    
    enum StoreError: Error {
        case failedToLoadRealm(Error)
        case failedToSaveRealm(Error)
        case failedToUpdateRealm(Error)
        case failedToDeleteRealm(Error)
    }
    
    init() throws {
        do {
            let fileUrl = URL(fileURLWithPath: #file)
            let projectSubUrl = fileUrl.deletingLastPathComponent()
            let projectUrl = projectSubUrl.deletingLastPathComponent()
            let realmURL = projectUrl.appendingPathComponent("MyTask.realm")

            var config = Realm.Configuration.defaultConfiguration
            config.fileURL = realmURL
            realm = try Realm.init(configuration: config)
        } catch {
            throw StoreError.failedToLoadRealm(error)
        }
    }
}

// MARK: - TrackerDataStore
extension DataStore: TaskDataStore {
    func objects(for date: Date) -> Results<TaskRealm>? {
        let predicate = NSPredicate(format: "dateFinish == %@", date as NSDate)
        return realm.objects(TaskRealm.self).filter(predicate)
    }
    
    func add(_ item: TaskRealm) throws {
        realm.beginWrite()
        realm.add(item)
        
        do {
            try realm.commitWrite()
        } catch {
            throw StoreError.failedToSaveRealm(error)
        }
    }
    
    func update(task: Task) throws {
        guard let object = realm.object(ofType: TaskRealm.self, forPrimaryKey: task.id) else { return }
        realm.beginWrite()
        
        object.name = task.name
        object.dateStart = task.dateStart
        object.dateFinish = task.dateFinish
        object.about = task.description
        
        do {
            try realm.commitWrite()
        } catch {
            throw StoreError.failedToUpdateRealm(error)
        }
    }
    
    func delete(objectId: Int) throws {
        guard let task = realm.object(ofType: TaskRealm.self, forPrimaryKey: objectId) else { return }
        
        realm.beginWrite()
        realm.delete(task)
        
        do {
            try realm.commitWrite()
        } catch {
            throw StoreError.failedToDeleteRealm(error)
        }
    }
}
