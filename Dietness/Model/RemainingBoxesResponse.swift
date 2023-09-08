//
//  RemainingBoxesResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - RemainingBoxesResponse
struct RemainingBoxesResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: RemainingBoxesResult?
}

// MARK: - Result
struct RemainingBoxesResult: Codable {
    let days: Int?
    let from, to: String?
}
