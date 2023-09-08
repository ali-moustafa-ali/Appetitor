//
//  Login.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: LoginResult?

}

// MARK: - Result
struct LoginResult: Codable {
    let user: User?
    let token: String?
    let current_subscription: CurrentSubscription?
    
}

// MARK: - CurrentSubscription
struct CurrentSubscription: Codable {
    let id: Int?
    let user, package, plan, from: String?
    let to, amount, status, approved_at: String?
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let name, email, country_code, mobile: String?
    let email_verified_at, mobile_verified_at, birth: String?
    let status, fcmToken: String?
    let current_subscription: CurrentSubscription?

}
