//
//  SignUpResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - SignUpResponse
struct SignUpResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: SignUpResult?
}

// MARK: - Result
struct SignUpResult: Codable {
    let user: User?
    let token, message: String?
}

