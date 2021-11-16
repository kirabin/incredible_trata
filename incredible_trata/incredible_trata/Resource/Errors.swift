//
//  Errors.swift
//  incredible_trata
//
//  Created by Aristova Alina on 16.11.2021.
//  
//

import Foundation

protocol OurErrorProtocol: LocalizedError {

    var title: String? { get }
    var code: CodeError { get }
}

struct CustomError: OurErrorProtocol {

    var title: String?
    var code: CodeError
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String, code: CodeError) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}

enum CodeError: Int {
    case emptyData = -1
}
