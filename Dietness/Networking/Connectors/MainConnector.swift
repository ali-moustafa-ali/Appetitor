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
    case setting

    var baseURL: URL{
        return URL(string: EndPoints.baseUrl)!
    }
    
    var authorizationToken: AuthorizationToken?{
        switch self {
        default:
            return nil
        }
    }

    
    var endpoint: String{
        switch self {
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
