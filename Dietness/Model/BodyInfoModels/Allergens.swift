//
//  Allergens.swift
//  Dietness
//
//  Created by Ahmad medo on 09/09/2023.
//  Copyright © 2023 Dietness. All rights reserved.
//

import Foundation

// MARK: - AllergensModel
struct AllergensModel: Codable {
    let errorFlag: Int?
    let message: String?
    let result: [AllergenItem]?

}

// MARK: - Result
struct AllergenItem: Codable {
    let id: Int
    let nameAr, nameEn: String

    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}
