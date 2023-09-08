//
//  OrderRequest.swift
//  Dietness
//
//  Created by karim metawea on 2/24/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

class OrderRequest:Codable{
    let day:String
    let items:[CartItem]
    init(day: String, items: [CartItem]) {
        self.day = day
        self.items = items
    }
}

class CartItem:Codable {
    let category:Int
    let products:[Int]
    init(category: Int, products: [Int]) {
        self.category = category
        self.products = products
    }
}
