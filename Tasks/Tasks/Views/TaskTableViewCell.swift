//
//  TaskTableViewCell.swift
//  Tasks
//
//  Created by Ben Gohlke on 4/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    // MARK: - Properties
    var task: Task? {
        didSet{
            updateViews()
        }
    }
    
    static let reuseIdentifier = "TaskCell"
    // MARK: - IBOutlets
    
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    private func updateViews(){
        guard let task = task else {return}
        
        taskNameLabel.text = task.name
        completedButton.setImage(task.complete ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
    }
    
    @IBAction func toggleComplete(_ sender: UIButton) {
        guard let task = task else {return}
        
        task.complete.toggle()
        
        sender.setImage(task.complete ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            
            NSLog("Error saving context task complete bolean: \(error)")
        }
    }
}
