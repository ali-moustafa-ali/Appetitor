//
//  OtpResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 20/05/2021.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation
struct OtpResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: OtpResult?
}
struct OtpResult: Codable {
    let message: String?
    let accountStatus: String?
}
struct OtpForgetResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: [String]?
}
