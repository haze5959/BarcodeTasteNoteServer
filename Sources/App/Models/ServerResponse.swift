//
//  ServerResponse.swift
//  
//
//  Created by OGyu kwon on 9/17/24.
//

import Vapor

struct ServerResponse<T: Content>: Content {
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
}
