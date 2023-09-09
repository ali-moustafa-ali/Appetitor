//
//  MainConnector.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/15/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

enum MainConnector: Connector, AuthorizedConnector{
    
    
    case getPackages
    case getUpdatedPackages
    case getPackagesById(id:Int)
    case getCategories
    case getSlider
    
    case foodSystems
    case sportTargets
    
    case getAllergens
    case getDislikedClassifications
    
    case setting

    var baseURL: URL{
        
        switch self {
            
        case .getDislikedClassifications:
            
            var urlString = EndPoints.baseUrl
            
            let userToRemove = "user"
            
            if urlString.contains(userToRemove) {
                urlString = urlString.replacingOccurrences(of: userToRemove, with: "")
            }
            
            
            return URL(string: urlString)!
        default:
            return URL(string: EndPoints.baseUrl)!
        }
    }
    
    var authorizationToken: AuthorizationToken?{
        switch self {
        default:
            return nil
        }
    }

    
    var endpoint: String{
        switch self {
            
        case .getDislikedClassifications:
            return EndPoints.dislikedClassifications
        case .getAllergens:
            return EndPoints.allergens
        case .sportTargets:
            return EndPoints.sportTargets
        case .foodSystems:
            return EndPoints.foodSystems
        case .getPackages:
            return EndPoints.getPackages
        case .getUpdatedPackages:
            return EndPoints.getUpdatedPackages
        case .getPackagesById:
            return EndPoints.getPackages
        case .getCategories:
            return EndPoints.getCategories
        case .getSlider:
            return EndPoints.slider
        case .setting:
            return EndPoints.setting
        }
    }
    
    var method: HTTPMethod{
        switch self {
        default:
            return .get
        }
    }
    
    var headers: [HTTPHeader]{
        return []
    }
    
    var parameters: ParametersRepresentable?{
        switch self {
        case .getPackagesById(let id):
            return Parameter.queryInt(key: "id", value: id)
        default:
            return nil
        }
    }
    
    
}
