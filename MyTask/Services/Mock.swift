//
//  Mock.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import Foundation

enum Mock {
    static let tasks: [Task] = [
        // 25.12.2024
        Task(
            id: UUID(),
            name: "Foo",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 0))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 1))!,
            description: "Quux"
        ),
        Task(
            id: UUID(),
            name: "Baz",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 1))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 2))!,
            description: "Quuuux"
        ),
        Task(
            id: UUID(),
            name: "Bar",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 3))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 4))!,
            description: "Quuux"
        ),
        Task(
            id: UUID(),
            name: "Quux",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 3))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 4))!,
            description: "Quux"
        ),
        Task(
            id: UUID(),
            name: "Quuux",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 3))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 4))!,
            description: nil
        ),
        // 26.12.2024
        Task(
            id: UUID(),
            name: "Foo",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 0))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 1))!,
            description: "Quux"
        ),
        Task(
            id: UUID(),
            name: "Baz",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 1))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 2))!,
            description: "Quuuux"
        ),
        Task(
            id: UUID(),
            name: "Bar",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 3))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 4))!,
            description: "Quuux"
        ),
        Task(
            id: UUID(),
            name: "Quux",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 3))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 4))!,
            description: "Quux"
        ),
        Task(
            id: UUID(),
            name: "Quuux",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 3))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 4))!,
            description: nil
        ),
        Task(
            id: UUID(),
            name: "Quuuuux",
            dateStart: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 3))!,
            dateFinish: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 26, hour: 4))!,
            description: "Quuuuuuux"
        ),
    ]
}
