//
//  TaskController.swift
//  Tasks
//
//  Created by Iyin Raphael on 6/1/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case faliedDecode
    case failedEncode
}

class TaskController {
    
    let baseURL = URL(string: "https://fir-chat-65ddc.firebaseio.com/")!
    
    typealias CompleteHnadler = (Result<Bool, NetworkError>) -> Void
    
    init() {
        fetchTaskFromServer()
    }
    
    func fetchTaskFromServer(completion: @escaping CompleteHnadler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                NSLog("No data returned from firebase (fetching tasks).")
                completion(.failure(.noData))
                return
            }
            
            do {
                let taskRepresentations = Array (try JSONDecoder().decode([String : TaskRepesentation].self, from: data).values)
                try self.updateTasks(with: taskRepresentations)
                
            } catch {
                NSLog("Error decoding tasks from Firebase: \(error)")
                completion(.failure(.faliedDecode))
            }
            
        }.resume()
        
    }
    
    func sendTaskServer(task: Task, completion: @escaping CompleteHnadler = {_ in }) {
        
        guard let uuid = task.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            let jsonEncoder = JSONEncoder()
            
            guard let representation = task.taskRepresentation else {
                completion(.failure(.failedEncode))
                return
            }
            request.httpBody = try jsonEncoder.encode(representation)
            
        } catch {
            NSLog("Error encoding task \(task): \(error)")
            completion(.failure(.failedEncode))
            return
        }
        URLSession.shared.dataTask(with: request) { Data, _, error in
            if let error = error {
                NSLog("Error sending task to server \(task): \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    func deleteTaskFromServer(_ task: Task, completion: @escaping CompleteHnadler = {_ in }) {
        guard let uuid = task.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
    
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error sending task to server \(task): \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    private func updateTasks(with representations: [TaskRepesentation]) throws {
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier)}
        let representationsByID  = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var tasksToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        
        let existing = try context.fetch(fetchRequest)
        
        for task in existing {
            guard let id = task.identifier,
                let representation = representationsByID[id] else { continue }
            
            self.update(task: task, with: representation)
            tasksToCreate.removeValue(forKey: id)
        }
        
        // tasksToCreatw should now contain FB tasks tha we DON't have in Core Data
        for representaion in tasksToCreate.values {
            Task(taskRespresention: representaion, context: context)
        }
        
        try context.save()
        
    }
    
    private func update(task: Task, with representation: TaskRepesentation) {
        task.name = representation.name
        task.notes = representation.notes
        task.priority = representation.priority
        task.complete = representation.complete
    }
}
