//
//  Task.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import Foundation

struct Task: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    let dateStart: Date
    let dateFinish: Date
    let description: String?
}
