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
    func update(_ object: TaskRealm, task: Task) throws
    func delete(_ object: TaskRealm) throws
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
            realm = try Realm()
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
    
    func update(_ object: TaskRealm, task: Task) throws {
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
    
    func delete(_ object: TaskRealm) throws {
        realm.beginWrite()
        realm.delete(object)
        
        do {
            try realm.commitWrite()
        } catch {
            throw StoreError.failedToDeleteRealm(error)
        }
    }
}
