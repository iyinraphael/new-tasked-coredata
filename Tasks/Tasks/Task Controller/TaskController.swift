//
//  TaskController.swift
//  Tasks
//
//  Created by Iyin Raphael on 6/1/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

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
        
    }
    
    func fetchTaskFromServer(completion: @escaping CompleteHnadler = { _ in }) {
        
        
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
}
