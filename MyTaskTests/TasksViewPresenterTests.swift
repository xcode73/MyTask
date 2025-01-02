//
//  TasksViewPresenterTests.swift
//  MyTaskTests
//
//  Created by Nikolai Eremenko on 02.01.2025.
//

import XCTest
@testable import MyTask

final class TasksViewControllerMock: TasksViewControllerProtocol {
    var presenter: (TasksViewPresenterProtocol)?
    
    func presentTaskViewController(task: Task?, date: Date?) {}
}

final class TasksViewPresenterTests: XCTestCase {
    func testViewDidLoad() {
        let presenter = TasksViewPresenter(view: TasksViewControllerMock())
        presenter.viewDidLoad(date: Date())
        XCTAssertNotNil(presenter.taskDataStore)
    }
    
    func testPresenterDateForRow() {
        let presenter = TasksViewPresenter(view: TasksViewControllerMock())
        let date = Date()
        presenter.createHourlyDates(for: date)
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let hourlyDate = calendar.date(byAdding: .hour, value: 1, to: startOfDay)
        
        let presenterDate = presenter.dateForRow(at: IndexPath(row: 2, section: 0))
        XCTAssertEqual(presenterDate, hourlyDate)
    }
}
