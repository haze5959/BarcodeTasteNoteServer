//
//  ServerError.swift
//
//
//  Created by OGyu kwon on 9/17/24.
//

import Vapor

enum ErrorCode: Int {
    case emptyData = 1000   // 해당 정보가 존재하지 않습니다.
    case nickNameAlreadyExist = 1001    // 닉네임이 이미 사용중 입니다.
    case authenticatedFail = 1002    // 인증에 실패하였습니다. 다시 로그인해주세요.
    case unknown = 9999 //
}

struct ServerError: Content {
    let code: Int
    let msg: String
    
    init(code: ErrorCode, msg: String) {
        self.code = code.rawValue
        self.msg = msg
    }
}
