//
//  CountryModel.swift
//  Wingo_Live
//
//  Created by karim metawea on 8/23/19.
//  Copyright © 2019 Eslam Muhammed. All rights reserved.
//

import Foundation
struct Country: Codable {
    let name: String
    let code: String
    let dialCode:String
    enum CodingKeys:String,CodingKey {
        case name,code
        case dialCode = "dial_code"
    }
}
