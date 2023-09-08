//
//  CitiesResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//


import Foundation

// MARK: - CitiesResponse
struct CitiesResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: CitiesResult?

}

// MARK: - Result
struct CitiesResult: Codable {
    let governates: [Governate]?
}

// MARK: - Governate
struct Governate: Codable {
    let id: Int?
    let title: String?
    let cities: [City]?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let governorate, title: String?
}
