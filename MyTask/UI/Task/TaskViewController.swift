//
//  TaskTableViewController.swift
//  TaskManager
//
//  Created by Nikolai Eremenko on 21.12.2024.
//

import UIKit

protocol TaskViewControllerDelegate: AnyObject {
    func dismissTaskViewController()
}

final class TaskViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: TaskViewControllerDelegate?
    
    private var taskDataStore: TaskDataStore
    
    private lazy var taskStore: TaskStoreProtocol? = {
        do {
            try taskStore = TaskStore(taskDataStore)
            
            return taskStore
        } catch {
            return nil
        }
    }()
    
    private var task: Task?
    
    private var selectedName: String?
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    private var selectedDescription: String?
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.style = .done
        view.tintColor = .systemGray
        view.isEnabled = false
        view.target = self
        view.action = #selector(doneButtonTapped)
        
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        view.setTitleColor(.systemRed, for: .normal)
        view.addTarget(self, action: #selector(didTapDeleteTaskButton), for: .touchUpInside)
        view.setTitle("Delete Task", for: .normal)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: .cancel,
                                   target: self,
                                   action: #selector(didTapCancelButton))
        view.tintColor = .systemRed
        
        return view
    }()
    
    private lazy var tap: UITapGestureRecognizer = {
        let view = UITapGestureRecognizer()
        view.addTarget(self, action: #selector(hideKeyboard))
        
        return view
    }()
    
    // MARK: - Init
    init(
        taskDataStore: TaskDataStore,
        task: Task? = nil,
        date: Date? = nil
    ) {
        self.taskDataStore = taskDataStore
        self.task = task
        
        if let task {
            selectedName = task.name
            selectedStartDate = task.dateStart
            selectedEndDate = task.dateFinish
            selectedDescription = task.description
        }
        
        if let date {
            selectedStartDate = date
            selectedEndDate = date.plusOneHour
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Task"
        setupNavigationBar()
        setupViews()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func updateAddButtonState() {
        if selectedName != nil {
            doneButton.isEnabled = true
            doneButton.tintColor = .systemRed
        } else {
            doneButton.isEnabled = false
            doneButton.tintColor = .systemGray
        }
    }
    
    // MARK: - Actions
    @objc
    private func doneButtonTapped() {
        guard let selectedName,
              let selectedStartDate,
              let selectedEndDate
        else {
            return
        }
        
        if let task {
            if selectedName != task.name ||
                selectedStartDate != task.dateStart ||
                selectedEndDate != task.dateFinish ||
                selectedDescription != task.description {
                
                let updatedTask = Task(id: task.id,
                                       name: selectedName,
                                       dateStart: selectedStartDate,
                                       dateFinish: selectedEndDate,
                                       description: selectedDescription)
                
                try? taskStore?.update(task: updatedTask)
            }
        } else {
            let newTask = Task(id: UUID().hashValue,
                               name: selectedName,
                               dateStart: selectedStartDate,
                               dateFinish: selectedEndDate,
                               description: selectedDescription)
            
            try? taskStore?.add(task: newTask)
        }
        
        delegate?.dismissTaskViewController()
    }

    @objc
    private func didTapCancelButton() {
        delegate?.dismissTaskViewController()
    }
    
    @objc
    private func didTapDeleteTaskButton() {
        guard let task else { return }
        
        try? taskStore?.delete(task: task)
        delegate?.dismissTaskViewController()
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Constraints
    func setupViews() {
        if task != nil {
            doneButton.title = "Save"
            deleteButton.isHidden = false
        } else {
            doneButton.title = "Add"
        }
        
        view.addSubview(tableView)
        view.addSubview(deleteButton)
        view.addGestureRecognizer(tap)
        
        tap.cancelsTouchesInView = false
        
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension TaskViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = TitleCell()
            cell.selectionStyle = .none
            cell.configure(with: task?.name)
            cell.delegate = self
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = DateCell()
                cell.delegate = self
                cell.selectionStyle = .none
                cell.configure(with: selectedStartDate, indexPath: indexPath)
                return cell
            } else {
                let cell = DateCell()
                cell.delegate = self
                cell.selectionStyle = .none
                cell.configure(with: selectedEndDate, indexPath: indexPath)
                return cell
            }
        case 2:
            let cell = DescriptionCell()
            cell.selectionStyle = .none
            cell.configure(with: task?.description)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 2:
            return 200
        default:
            return 44
        }
    }
}

// MARK: - TitleCellDelegate
extension TaskViewController: TitleCellDelegate {
    func didTapDoneButton(title: String) {
        selectedName = title
        
        updateAddButtonState()
    }
}

// MARK: - DateCellDelegate
extension TaskViewController: DateCellDelegate {
    func didSelectDate(date: Date, indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            selectedStartDate = date
            selectedEndDate = date.plusOneHour
        case 1:
            selectedEndDate = date
            selectedStartDate = date.minusOneHour
        default:
            break
        }
        
        tableView.performBatchUpdates {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1),
                                      IndexPath(row: 1, section: 1)],
                                 with: .automatic)
        }
        
        updateAddButtonState()
    }
}

// MARK: - DescriptionCellDelegate
extension TaskViewController: DescriptionCellDelegate {
    func descriptionChanged(text: String) {
        selectedDescription = text

        updateAddButtonState()
    }
}
