//
//  TasksViewController.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import UIKit

final class TasksViewController: UIViewController {
    // MARK: - Properties
    private var hourlyDates: [Date] = []
    private let taskDataStore  = (UIApplication.shared.delegate as! AppDelegate).taskDataStore
    
    // MARK: - UI Components
    @IBOutlet var tableView: UITableView!
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.image = UIImage(named: "ic.plus")
        view.tintColor = .systemGray
        view.target = self
        view.action = #selector(didTapAddButton)
        
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tasks"
        view.backgroundColor = .white
        hourlyDates = createHourlyDates(for: datePicker.date)
        
        setupNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TasksCell.nib(), forCellReuseIdentifier: TasksCell.reuseIdentifier)
    }
    
    private func createHourlyDates(for date: Date) -> [Date] {
        var hourlyDates: [Date] = []
        let calendar = Calendar.current
        
        let startOfDay = calendar.startOfDay(for: date)

        for hour in 0..<25 {
            if let hourlyDate = calendar.date(byAdding: .hour, value: hour, to: startOfDay) {
                hourlyDates.append(hourlyDate)
            }
        }
        
        return hourlyDates
    }
    
    private func presentTaskView(task: Task? = nil, date: Date? = nil) {
        let vc = TaskViewController(taskDataStore: taskDataStore, task: task, date: date)
        vc.delegate = self
        let navigationController = UINavigationController( rootViewController: vc )
        navigationController.modalPresentationStyle = .pageSheet
        
        present(navigationController, animated: true)
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            if let navBar = self.navigationController?.navigationBar {
                navBar.layer.backgroundColor = UIColor.systemBackground.cgColor
                navBar.backgroundColor = .systemBackground
                
                let standardAppearance = UINavigationBarAppearance()
                standardAppearance.configureWithOpaqueBackground()
                standardAppearance.backgroundColor = .systemBackground
                
                let compactAppearance = standardAppearance.copy()
                
                navBar.standardAppearance = standardAppearance
                navBar.scrollEdgeAppearance = standardAppearance
                navBar.compactAppearance = compactAppearance
            }
        } else {
            UINavigationBar.appearance().barTintColor = .white
        }
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    // MARK: - Actions
    @objc
    private func didSelectDate(_ sender: UIDatePicker) {
        hourlyDates = createHourlyDates(for: sender.date)
        tableView.reloadData()
        self.dismiss(animated: true)
    }
    
    @objc
    private func didTapAddButton() {
        presentTaskView(date: datePicker.date.truncated)
    }
}

// MARK: - UITableViewDataSource
extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        hourlyDates.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TasksCell.reuseIdentifier, for: indexPath) as? TasksCell
        else {
            return UITableViewCell()
        }
        
        let cellDate = hourlyDates[indexPath.row]
        
        cell.configure(with: taskDataStore, cellDate: cellDate)
        cell.selectionStyle = .none

        return cell
    }
}


// MARK: - UITableViewDelegate
extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 20
        }
        return 50
    }
}

// MARK: - TaskDelegate
extension TasksViewController: TaskViewControllerDelegate {
    func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    func deleteButtonTapped() {
        dismiss(animated: true)
    }
    
    func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
