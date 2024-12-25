//
//  TaskStore.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import Foundation

protocol TaskStoreProtocol {
    func getTasks(for date: Date) -> [Task]?
}

final class TaskStore: TaskStoreProtocol {
    private var tasks: [Task]?
    
    init() {
        addMockData()
        tasks = loadTasks()
    }
    
    private func loadTasks() -> [Task]? {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("tasks.json")
        
        guard let data = try? Data(contentsOf: documentURL) else { return [] }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            return try jsonDecoder.decode(Array<Task>.self, from: data)
        } catch {
            print("WARNING: Could not load Task data \(error.localizedDescription)")
            return nil
        }
    }
    
    private func saveTasks() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("tasks.json")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        
        let data = try? jsonEncoder.encode(tasks)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("ERROR: Could not save Categories data \(error.localizedDescription)")
        }
    }
    
    private func addMockData() {
        tasks = Mock.tasks
        saveTasks()
    }
    
    func getTasks(for date: Date) -> [Task]? {
        return tasks?.filter { $0.dateFinish == date }
    }
}
