//
//  DisLikedList.swift
//  Ali
//
//  Created by Ali Moustafa on 08/09/2023.
//

struct DisLikedElement: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

typealias DisLiked = [DisLikedElement]

