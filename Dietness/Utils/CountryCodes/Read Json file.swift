//
//  Read Json file.swift
//  Wingo_Live
//
//  Created by Eslam Muhammed on 7/24/19.
//  Copyright © 2019 Eslam Muhammed. All rights reserved.
//

import Foundation
import UIKit

struct readJsonFile {
    func loadJson(filename fileName: String) -> [Country]?{
        if let path = Bundle.main.path(forResource: fileName , ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                let book = try JSONDecoder().decode([Country].self, from: data)
                //                for i in 0..<book.count {
                //
                //                    callin.append(cuntryModel(code:book[i].callingCodes![0], name: book[i].AF!, avatar: book[i].flag!))
                //                }
                return book
                //   print("jsonData:\(clalling)")
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return nil
    }
}
//"countries"
