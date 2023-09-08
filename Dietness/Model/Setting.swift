//
//  Setting.swift
//  Dietness
//
//  Created by 10 on 25/08/2021.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation
// MARK: - SignUpResponse
struct Setting: Codable {
    let error_flag: Int?
    let message: String?
    let result: SettingResult?
}
// MARK: - Result
struct SettingResult: Codable {
    let status: String?
    let enable_delievery_timeframes: String?
    let skip_activation: String?
    let delivery_notes: String?
}
