//
//  ProfileResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - ProfileResponse
struct ProfileResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: ProfileResult?

}

// MARK: - Result
struct ProfileResult: Codable {
    let profile: Profile?
}

// MARK: - Profile
struct Profile: Codable {
    let id: Int?
    let name, email, country_code, mobile: String?
    let email_verified_at, mobile_verified_at, birth: String?
    let status: String?
    let fcmToken: String?
    let address: Address?
}

// MARK: - Address
struct Address: Codable {
    let id: Int?
    let user, country: String?
    let governorate, region: Governorate?
    let piece, street, avenue, house: String?
    let floor, flat, notes: String?

}
// MARK: - Governorate
struct Governorate: Codable {
    var id: Int?
    var name_en, name_ar: String?
    var deleted_at: String?
    var created_at, updated_at, governorate: String?

}
