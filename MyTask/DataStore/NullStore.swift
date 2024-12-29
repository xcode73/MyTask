//
//  NullStore.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 26.12.2024.
//

import RealmSwift

final class NullStore {}

extension NullStore: TaskDataStore {
    func delete(objectId: Int) throws {}
    func add(_ object: TaskRealm) throws {}
    func update(task: Task) throws {}
    func objects(for date: Date) -> RealmSwift.Results<TaskRealm>? { nil }
}
