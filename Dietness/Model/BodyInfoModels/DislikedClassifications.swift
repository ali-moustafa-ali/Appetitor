//
//  DislikedClassifications.swift
//  Dietness
//
//  Created by Ahmad medo on 09/09/2023.
//  Copyright © 2023 Dietness. All rights reserved.
//


import Foundation

// MARK: - DislikedClassificationsModel
struct DislikedClassificationsModel: Codable {
    let errorFlag: Int?
    let message: String?
    let result: [DislikedClassification]?


}

// MARK: - Result
struct DislikedClassification: Codable {
    let id: Int
    let titleAr, titleEn: String

    enum CodingKeys: String, CodingKey {
        case id
        case titleAr = "title_ar"
        case titleEn = "title_en"
    }
}
