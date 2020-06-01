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
    
    let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!
    
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
        }
    }
}
