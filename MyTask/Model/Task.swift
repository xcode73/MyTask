//
//  Task.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import Foundation

struct Task: Equatable, Identifiable {
    let id: Int
    let name: String
    let dateStart: Date
    let dateFinish: Date
    let description: String?
}
