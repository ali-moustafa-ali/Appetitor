//
//  PackagesResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - PackagesResponse
struct PackagesResponse: Codable {
    let error_flag: Int?
    let message: String?
    let result: PackagesResult?
}

// MARK: - Result
struct PackagesResult: Codable {
    let packages: [Package]?
    let image_url: String?

}

// MARK: - Package
struct Package: Codable {
    let id: Int?
    let image: String?
    let name: String?
    let plans: [Plan]?
}

// MARK: - Plan
struct Plan: Codable {
    let id: Int?
    let price, days: String?
    let description: String?
    let categories: [PackagesCategory]?
}

// MARK: - CategoryElement
struct PackagesCategory: Codable {
    let category: Category?
    let qty, max, min: ValueWrapper?

}
enum Datum: Codable {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Datum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datum"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
