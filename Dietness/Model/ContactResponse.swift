//
//  ContactResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - ConbtactResponse
struct ContactResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: ContacResult?

}

// MARK: - Result
struct ContacResult: Codable {
    let contact_mobile: String?

}
