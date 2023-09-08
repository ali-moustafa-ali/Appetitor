//
//  DatesResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - DatesResponse
struct DatesResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: DatesResult?

}

// MARK: - Result
struct DatesResult: Codable {
    let dates: [String]?
    let completed: [String]?
}

struct ErrorResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: String?

}
