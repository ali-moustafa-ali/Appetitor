//
//  SportsTargetModel.swift
//  Dietness
//
//  Created by Ahmad medo on 09/09/2023.
//  Copyright © 2023 Dietness. All rights reserved.
//

import Foundation

// MARK: - SportsTargetModel
struct SportsTargetModel: Codable {
    let errorFlag: Int?
    let message: String?
    let result: [SportsTarget]?

//    enum CodingKeys: String, CodingKey {
//        case errorFlag = "error_flag"
//        case message, result
//    }
}

// MARK: - Result
struct SportsTarget: Codable {
    let id: Int?
    let nameAr, nameEn, descriptionAr, descriptionEn: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case image
    }
}
