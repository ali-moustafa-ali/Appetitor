//
//  FoodSystem.swift
//  Dietness
//
//  Created by Ahmad medo on 08/09/2023.
//  Copyright © 2023 Dietness. All rights reserved.
//

import Foundation

// MARK: - FoodSystemModel
struct FoodSystemModel: Codable {
    let errorFlag: Int?
    let message: String?
    let result: [FoodSystemItem]?
//
//    enum CodingKeys: String, CodingKey {
//        case errorFlag = "error_flag"
//        case message, result
//    }
}

// MARK: - Result
struct FoodSystemItem: Codable {
    let id: Int?
    let nameAr, nameEn: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
    }
}
