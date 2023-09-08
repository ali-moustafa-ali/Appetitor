//
//  TabConnector.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/15/21.
//  Copyright © 2021 Dietness. All rights reserved.
//


import Foundation

enum TabConnector:Connector,AuthorizedConnector{
    
    
    case getRemainingBoxes
    case getProfile
    case contact
    case updatePassword(oldPassword:String,password:String,confirmPassword:String)
    case addAddress(country:String,governorate:String,region:String,piece:String,street:String,avenue:String,house:String,floor:String,flat:String,notes:String,lat:String,lng:String)
    case updateAddress(country:String,governorate:String,region:String,piece:String,street:String,avenue:String,house:String,floor:String,flat:String,notes:String,lat:String,lng:String)
    case updateProfile(name:String,email:String,country_code:String,mobile:String,birth:String,status:String,deleted_at:String)
    case getCities
    case getUserReservedDays
    case getUserRestrictedDays
    case getCategories(day:String)
    case sendDeliveryTime(time:String)
    case freeze(day:String,isFreezed:Bool)
    case order(items:OrderRequest)
    case getOrderByDay(day:String)
    case deleteOrder(day:String)
    
    
    var baseURL: URL{
        return URL(string: EndPoints.baseUrl)!
    }
    
    var authorizationToken: AuthorizationToken?{
        switch self {
        
            
        default:
            return .bearer(token: SettingsManager.init().getUserToken())
        }
    }
    
    
    var endpoint: String{
        switch self {
        
        case .sendDeliveryTime:
            return EndPoints.sendDeliveryTime

        case .getRemainingBoxes:
            return EndPoints.getRemainigBoxes

        case .getProfile:
            return EndPoints.getProfile
            
        case .contact:
            return EndPoints.contactUs
        case .updatePassword:
            return EndPoints.profileUpdatePassword
        case .updateAddress:
            return EndPoints.updateAddress
        case .addAddress:
            return EndPoints.addAddress
        case .getCities:
            return EndPoints.getCities
            
        case .getUserReservedDays:
                    return EndPoints.getReservedDates
        case .getUserRestrictedDays:
                    return EndPoints.getRestrictedDates
                
        case .getCategories:
                return EndPoints.getCategories
        case .freeze(day: _, isFreezed: let isFreezed):
            if isFreezed{
            return EndPoints.unPauseDay
            }else{
            return EndPoints.pauseDay
            }
        case .updateProfile:
            return EndPoints.profileUpdate
        case .order:
            return EndPoints.sendOrder
        case .getOrderByDay:
            return EndPoints.getOrderByDay
        case .deleteOrder:
            return EndPoints.deleteOrder
        }
        
        
        
    }
    
    var method: HTTPMethod{
        switch self {
        case .updatePassword:
            return .post
            case .updateAddress:
            return .post
        case .addAddress:
            return .post
        case .freeze:
            return .post
            
        case .updateProfile:
            return .post
        case .order:
            return .post
        case .deleteOrder:
            return .post
        case .sendDeliveryTime:
            return .post
        default:
            return .get
        }
    }
    
    var headers: [HTTPHeader]{
        return []
    }
    
    var parameters: ParametersRepresentable?{
        switch self {
        case .updatePassword(let oldPassword, let password, let confirmPassword):
            return Parameter.jsonObject(value: ["current_password":oldPassword,"password":password,"verify_password":confirmPassword])
        case .updateAddress(let country, let governorate, let region, let piece, let street, let avenue, let house, let floor, let flat, let notes, let lat, let lng):
            return Parameter.jsonObject(value: ["country": country,
            "governorate": governorate,
            "region": region,
            "piece": piece,
            "street": street,
            "avenue": avenue,
            "house": house,
            "floor": floor,
            "flat": flat,
            "notes": notes,
            "lat": lat,
            "lng": lng])
        case .addAddress(let country, let governorate, let region, let piece, let street, let avenue, let house, let floor, let flat, let notes, let lat, let lng):
            return Parameter.jsonObject(value: ["country": country,
            "governorate": governorate,
            "region": region,
            "piece": piece,
            "street": street,
            "avenue": avenue,
            "house": house,
            "floor": floor,
            "flat": flat,
            "notes": notes,
            "lat": lat,
            "lng": lng])
        case .freeze(day: let day, isFreezed: _):
            return Parameter.jsonObject(value: ["day":day])
        case .updateProfile(let name, let email, let country_code, let mobile, let birth, let status, let deleted_at):
            return Parameter.jsonObject(value: ["name":name,"email":email
                ,"country_code":country_code,"mobile": mobile,
            "birth": birth,
            "status": status,
            "deleted_at": deleted_at])
        case .order(items: let request):
            return Parameter.jsonObject(value: request)
        case .getCategories(day: let day):
            return Parameter.query(key: "day", value: day)
        case .getOrderByDay(day: let day):
            return Parameter.query(key: "day", value: day)
        case .deleteOrder(let day):
            return Parameter.query(key: "day", value: day)
        case .sendDeliveryTime(let time):
            return Parameter.query(key: "delivery_timeframe", value: time)

            
        default:
            return nil
        }
    }
    
    
}


