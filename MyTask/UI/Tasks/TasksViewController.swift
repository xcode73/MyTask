//
//  TasksViewController.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import UIKit

protocol TasksViewControllerProtocol: AnyObject {
    var presenter: TasksViewPresenterProtocol? { get set }
    func presentTaskViewController(task: Task?, date: Date?)
}

final class TasksViewController: UIViewController, TasksViewControllerProtocol {
    var presenter: TasksViewPresenterProtocol?
    
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
        
        setupView()
        setupNavigationBar()
        setupTableView()
        
        presenter?.viewDidLoad(date: datePicker.date)
    }
    
    func presentTaskViewController(task: Task? = nil, date: Date? = nil) {
        guard let taskDataStore = presenter?.taskDataStore, let navigationController else { return }
        
        let viewController = TaskViewController(taskDataStore: taskDataStore, task: task, date: date)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Setup UI
    private func setupView() {
        presenter = TasksViewPresenter(view: self)
        title = "Tasks"
        view.backgroundColor = .white
    }
    
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
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = presenter
        tableView.register(TasksCell.nib(), forCellReuseIdentifier: TasksCell.reuseIdentifier)
    }
    
    // MARK: - Actions
    @objc
    private func didSelectDate(_ sender: UIDatePicker) {
        presenter?.createHourlyDates(for: sender.date)
        tableView.reloadData()
        self.dismiss(animated: true)
    }
    
    @objc
    private func didTapAddButton() {
        presentTaskViewController(date: datePicker.date.truncated)
    }
}

// MARK: - UITableViewDelegate
extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        guard 
            let cellDate = presenter?.dateForRow(at: indexPath),
            indexPath.row != 0
        else {
            return
        }
        
        presentTaskViewController(date: cellDate)
    }
    
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
    func dismissTaskViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
