//
//  EndPoints.swift
//  NewGalen
//
//  Created by karim metawea on 9/18/19.
//  Copyright © 2019 Microtec Saudi. All rights reserved.
//

import Foundation

var patientId = UserDefaults.standard.string(forKey: "patientId")
enum Endpnts {
    static let base = "https://dietnesskw.com/api/user"
    static let imageBase = "http://masrhosting.com:4000/uploads/"

    case order
    var stringValue: String {
        switch self {
        case .order: return Endpnts.base + "/order"
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
