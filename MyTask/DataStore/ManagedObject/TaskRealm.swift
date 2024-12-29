//
//  TaskRealm.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import RealmSwift

final class TaskRealm: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name: String = ""
    @Persisted var dateStart: Date = Date()
    @Persisted var dateFinish: Date = Date()
    @Persisted var about: String?
}
