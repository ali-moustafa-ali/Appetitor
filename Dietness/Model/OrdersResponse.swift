//
//  OrdersResponse.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/10/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - OrdersResponse
//struct OrdersResponse: Codable {
//    let error_flag: Int?
//    let message: String?
//    let result: OrdersResult?
//
//}
//
//// MARK: - Result
//struct OrdersResult: Codable {
//    let order: Order?
//}
//
//// MARK: - Order
//struct Order: Codable {
//    let id: Int?
//    let user: String?
//    let package: Package?
//    let plan: Plan?
//    let day: String?
//    let items: [Item]?
//}
//
//// MARK: - Item
//struct Item: Codable {
//    let category: Package?
//    let products: [Product]?
//}

// MARK: - OrderResponse
struct OrderResponse: Codable {
    var error_flag: Int?
    var message: String?
    var result: [String]?
}

// MARK: - Result
struct OrderRes: Codable {
    var packages: [Package]?
    var image_url: String?

}
struct OrderErrorResponse: Codable {
    var error_flag: Int?
    var message: String?
    var result: String?
}


