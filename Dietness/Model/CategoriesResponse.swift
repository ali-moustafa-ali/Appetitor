//
//  CategoriesResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - CategoriesResponse
struct CategoriesResponse: Codable {
    let error_flag: Int?
    let message: String?
    var result: CategoriesResult?
}

// MARK: - Result
struct CategoriesResult: Codable {
    var categories: [Category]?
    let image_url: String?
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
    var products: [Product]?
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    var isSelected: Bool?
    let category: String?
    let status: String?
    let image: String?
    let title, desc: String?
//    let days: [Day]?ini
    init() {
        id = 0
        isSelected = false
        category = ""
        status = ""
        image = ""
        title = ""
        desc = ""
    }
}

// MARK: - Day
struct Day: Codable {
    let id: Int
    let day, product: String

    enum CodingKeys: String, CodingKey {
        case id, day, product
    }
}
enum Status: String, Codable {
    case hot = "Hot"
    case normal = "Normal"
}
// MARK: - SliderResponse
struct SliderResponse: Codable {
    var error_flag: Int?
    var message: String?
    var result: SliderResult?

}

// MARK: - Result
struct SliderResult: Codable {
    var sliders: [Slider]?
    var image_url: String?
}
struct Slider: Codable {
    var image: String?
}
