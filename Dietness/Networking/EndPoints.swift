//
//  EndPoints.swift
//  Gaxa
//
//  Created by karim metawea on 5/14/20.
//  Copyright © 2020 Rami Suliman. All rights reserved.
//

import Foundation

class EndPoints{
    static let baseUrl = "https://Appetitor.app/api/user"

//    static let baseUrl = "https://dietnesskw.com/api/user"
    
    static let signup = "/signup"
    static let unPauseDay = "/unPauseDay"
    static let pauseDay = "/pauseDay"
    static let profileUpdate = "/profile/update"
    static let profileUpdatePassword = "/profile/password/update"
    static let login = "/login"
    static let sendOrder = "/order"
    static let payment = "/payment"
    static let forgetPassword = "/forget"
    static let resendOtp = "/resendOtp"
    static let verifyOtpForget = "/verify_otp_forget"
    static let verifyOtp = "/verify_otp_is_first"
    static let newPassword = "/new_password_with_forget_otp"
    static let addAddress = "/profile/address/add"
    static let updateAddress = "/profile/address/update"
    static let getPackages = "/packages/get"
    static let getUpdatedPackages = "/packages/menu/get"
    static let getCities = "/getCities"
    static let contactUs = "/contact/mobile"
    static let getRemainigBoxes = "/getRemainingBoxes"
    static let getReservedDates = "/getUserReservedDates"
    static let getRestrictedDates = "/getUserRestrictedDates"
    static let getProfile = "/profile/get"
    static let getOrderByDay = "/getOrderByDay"
    static let deleteOrder = "/removeUserOrder"
    static let getCategories = "/categories/get"
    static let updateToken = "/updateFcmToken"
    static let slider = "/getsliders"
    static let setting = "/settings"
    static let sendDeliveryTime = "/profile/UpdateDelieveryTimeframe"
    
    
    
    
    
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let phone = "phone"
        static let id = "id"
        static let day = "day"
        static let code = "code"
    }
    
    enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
    
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
    
}
