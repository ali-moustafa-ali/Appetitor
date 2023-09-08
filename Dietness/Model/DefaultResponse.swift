//
//  DefaultResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - DefaultResponse
struct DefaultResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: DefaultResult?
}
struct DefaultResult: Codable {
    let message: String?
}
