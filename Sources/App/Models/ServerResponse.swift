//
//  ServerResponse.swift
//
//
//  Created by OGyu kwon on 9/17/24.
//

import Vapor

struct ServerResponse<T: Content>: Content, CustomStringConvertible {
    let result: Bool
    let data: T?
    let error: ServerError?
    
    init(data: T?) {
        self.result = true
        self.data = data
        self.error = nil
    }
    
    init(error: ServerError) {
        self.result = false
        self.data = nil
        self.error = error
    }
    
    var description: String {
        let mirror = Mirror(reflecting: self)
        var result = "\(mirror.subjectType):\n"
        for (label, value) in mirror.children {
            if let label = label {
                result += "\(label): \(value)\n"
            }
        }
        return result
    }
}
