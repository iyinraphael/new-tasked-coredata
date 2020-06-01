//
//  CreateTaskViewController.swift
//  Tasks
//
//  Created by Ben Gohlke on 4/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {

    // MARK: - Properties
    var complete = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var prirotiyControl: UISegmentedControl!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else {return}
        let notes = notesTextView.text
        let priorityIndex = prirotiyControl.selectedSegmentIndex
        let priority = TaskPriority.allCases[priorityIndex]
        
        Task(name: name, notes: notes, complete: complete, priority: priority)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context")
        }
        
    }
    
    @IBAction func toggleCompleted(_ sender: UIButton){
        complete.toggle()
        
        sender.setImage(complete ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
    }
}
