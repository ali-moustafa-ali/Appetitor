//
//  RegistrationConnector.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/15/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

enum RegisterationConnector:Connector,AuthorizedConnector{
    
    
    case login(loginData:String,password:String,code:String?,type:String)
    case signup(name:String,mobile:String,email:String,password:String,code:String, planId: Int)
    case forgotPassword(emailOrMobile:String,type:String,code:String?)
    case verifyOtpForget(otp:String,emailOrMobile:String,type:String,code:String)
    case verifyOtp(otp:String,emailOrMobile:String,type:String,code:String)
    case resend
    case updateDeviceToken(token:String)
    case changePasswordWithForgot(otp:String,emailOrMobile:String,type:String,code:String,password:String)
  
    case payment(executePaymentResponse:Codable)
    var baseURL: URL{
        return URL(string: EndPoints.baseUrl)!
    }
    var authorizationToken: AuthorizationToken?{
        switch self {
        case .resend:
            return .bearer(token: SettingsManager.manager.getUserToken())
        case .updateDeviceToken:
            return .bearer(token: SettingsManager.manager.getUserToken())
        case .verifyOtp:
            return .bearer(token: SettingsManager.manager.getUserToken())
        case .verifyOtpForget:
            return .bearer(token: SettingsManager.manager.getUserToken())
        case .payment:
            return .bearer(token: SettingsManager.manager.getUserToken())
        default:
            return nil
        }
    }

    
    var endpoint: String{
        switch self {
        case .payment:
            return EndPoints.payment
        case .login:
            return EndPoints.login
        case .signup:
            return EndPoints.signup
        case .forgotPassword:
            return EndPoints.forgetPassword
        case .verifyOtp:
            return EndPoints.verifyOtp
        case .verifyOtpForget:
            return EndPoints.verifyOtpForget
        case .resend:
            return EndPoints.resendOtp
        case .changePasswordWithForgot:
            return EndPoints.newPassword
        case .updateDeviceToken:
            return EndPoints.updateToken
        }
    }
    
    var method: HTTPMethod{
        switch self {
        default:
            return .post
        }
    }
    
    var headers: [HTTPHeader]{
        return []
    }
    
    var parameters: ParametersRepresentable?{
        switch self {
        case .login(let data , let password,let code,let type):
            return Parameter.jsonObject(value: ["emailOrmobile":data,"password":password,"code":code,"type":type])
            
        case .signup(let name, let mobile, let email, let password, let code, let planId):
            
            let params = Parameter.jsonObject(value: ["name":name,"mobile":mobile,"email":email,"password":password,"verify_password":password,"code":code, "plan_id": String(planId)])
            
            print(params)
            
            return params
            
        case .forgotPassword(let emailOrMobile, let type, let code):
            return Parameter.jsonObject(value: ["emailOrmobile":emailOrMobile,"type":type,"code":code])
        case .verifyOtp(let otp, let emailOrMobile, let type, let code):
            return Parameter.jsonObject(value: ["otp":otp,"emailOrmobile":emailOrMobile,"type":type,"code":code])
        case .verifyOtpForget(let otp, let emailOrMobile, let type, let code):
            return Parameter.jsonObject(value: ["otp":otp,"emailOrmobile":emailOrMobile,"type":type,"code":code])
        case .resend:
            return nil
        case .updateDeviceToken(let token):
            return Parameter.jsonObject(value: ["token":token])
        case .changePasswordWithForgot(let otp, let emailOrMobile, let type, let code, let password):
            return Parameter.jsonObject(value: ["otp":otp,"emailOrmobile":emailOrMobile,"type":type,"code":code,"password":password,"verify_password":password])
        case .payment(executePaymentResponse: let executePaymentResponse):
            return Parameter.jsonObject(value: executePaymentResponse)
        }
    }
    
    
}
