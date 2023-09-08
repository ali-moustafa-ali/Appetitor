//
//  GetOrderByDayResponse.swift
//  Dietness
//
//  Created by karim metawea on 5/25/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation
struct GetOrderByDayResponse: Codable {
    let errorFlag: Int
    let message: String
    let result: OrderResult?

    enum CodingKeys: String, CodingKey {
        case errorFlag = "error_flag"
        case message, result
    }
}

// MARK: - Result
struct OrderResult: Codable {
    let order: OrderForDay
}

// MARK: - Order
struct OrderForDay: Codable {
    let id: Int?
    let user: String?
    let package: Package?
    let plan: Plan?
    let day: String?
    let items: [OrderItem]?
    let status, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, user, package, plan, day, items, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Item
struct OrderItem: Codable {
    let category: Category?
    let products: [Product]?
}


