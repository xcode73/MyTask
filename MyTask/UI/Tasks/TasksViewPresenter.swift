//
//  TasksViewPresenter.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 02.01.2025.
//

import UIKit

protocol TasksViewPresenterProtocol: NSObject, UITableViewDataSource {
    var view: TasksViewControllerProtocol? { get set }
    var taskDataStore: TaskDataStore? { get }
    func viewDidLoad(date: Date)
    func createHourlyDates(for date: Date)
    func dateForRow(at indexPath: IndexPath) -> Date?
    
}

final class TasksViewPresenter: NSObject, TasksViewPresenterProtocol {
    weak var view: TasksViewControllerProtocol?
    var taskDataStore: TaskDataStore?
    
    private var hourlyDates: [Date] = []
    
    init(
        view: TasksViewControllerProtocol
    ) {
        self.view = view
    }
    
    func viewDidLoad(date: Date) {
        createHourlyDates(for: date)
        taskDataStore = appDelegate().taskDataStore
    }
    
    func createHourlyDates(for date: Date) {
        var dates: [Date] = []
        let calendar = Calendar.current
        
        let startOfDay = calendar.startOfDay(for: date)

        for hour in 0..<25 {
            if let hourlyDate = calendar.date(byAdding: .hour, value: hour, to: startOfDay) {
                dates.append(hourlyDate)
            }
        }
        
        hourlyDates = dates
    }
    
    func dateForRow(at indexPath: IndexPath) -> Date? {
        guard let date = hourlyDates[safe: indexPath.row] else { return nil }
        
        return date.minusOneHour
    }
    
    private func appDelegate() -> AppDelegate {
       guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
           fatalError("could not get app delegate ")
       }
        
       return delegate
    }
}

// MARK: - UITableViewDataSource
extension TasksViewPresenter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        hourlyDates.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TasksCell.reuseIdentifier, for: indexPath) as? TasksCell,
            let cellDate = hourlyDates[safe: indexPath.row],
            let taskDataStore
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.configure(with: taskDataStore, cellDate: cellDate)
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - TasksCellDelegate
extension TasksViewPresenter: TasksCellDelegate {
    func didTapTask(task: Task) {
        view?.presentTaskViewController(task: task, date: nil)
    }
}
