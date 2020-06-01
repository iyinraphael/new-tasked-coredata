//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Iyin Raphael on 5/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData


enum TaskPriority: String, CaseIterable {
    case low
    case normal
    case high
    case critical
}

extension Task {
    
    var taskRepresentation: TaskRepesentation? {
        guard let id = identifier,
        let name = name,
        let priority = priority else {
                return nil
        }
        
        return TaskRepesentation(identifier: id.uuidString, name: name, notes: notes, priority: priority, complete: complete)
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                     name: String,
                     notes: String? = nil,
                     complete: Bool = false,
                     priority: TaskPriority = .normal,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.notes = notes
        self.complete = complete
        self.priority = priority.rawValue
    }
    
    //Failable
    @discardableResult convenience init?(taskRespresention: TaskRepesentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        guard let identifier = UUID(uuidString: taskRespresention.identifier),
            let prirority = TaskPriority(rawValue: taskRespresention.priority) else {return nil}
        
        self.init(identifier: identifier, name: taskRespresention.name, notes: taskRespresention.notes, complete: taskRespresention.complete, priority: prirority, context: context)
        
    }
    
}
