//
//  TaskCell.swift
//  MyTask
//
//  Created by Nikolai Eremenko on 25.12.2024.
//

import UIKit

final class TaskCell: UICollectionViewCell {
    @IBOutlet 
    weak var taskHStack: UIStackView!
    
    @IBOutlet 
    weak var taskColorView: UIView!
    
    @IBOutlet 
    weak var taskTitleLabel: UILabel!
    
    @IBOutlet 
    weak var taskTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with task: Task, color: UIColor) {
        taskTitleLabel.text = task.name
        taskHStack.backgroundColor = color.withAlphaComponent(0.3)
        taskColorView.backgroundColor = color
        
        let start = DateFormatter.shortTimeFormatter.string(from: task.dateStart)
        let end = DateFormatter.shortTimeFormatter.string(from: task.dateFinish)
        
        taskTimeLabel.text = start + " - " + end
    }
    
    static func nib() -> UINib {
        return UINib(nibName: TaskCell.reuseIdentifier, bundle: nil)
    }
}
