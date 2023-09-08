//
//  Connector.swift
//
//  Copyright (c) 2020 Tarek Sabry
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import Alamofire
import MOLH

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias HTTPHeader = Alamofire.HTTPHeader

public protocol Connector: Alamofire.URLRequestConvertible {
    var baseURL: URL { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeader] { get }
    var parameters: ParametersRepresentable? { get }
}

public extension Connector {
    
    func asURLRequest() throws -> URLRequest {
        
        let url: URL

        if endpoint.isEmpty {
            url = baseURL
        } else {
            url = baseURL.appendingPathComponent(endpoint)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let authorizedConnector = self as? AuthorizedConnector, let token = authorizedConnector.authorizationToken {
            switch token{
            case .bearer(let token):
                urlRequest.headers.add(.authorization(bearerToken: token))
            case .basic(let credentials):
                urlRequest.headers.add(.authorization(username: credentials.username, password: credentials.password))
            case .custom(let token):
                urlRequest.headers.add(.authorization(token))
            }
        }
        urlRequest.headers.add(.accept("application/json"))
        urlRequest.headers.add(.acceptLanguage((MOLHLanguage.currentAppleLanguage() == "ar") ? "ar" : "en"))
        headers.forEach { header in
            urlRequest.headers.add(header)
        }
        
        if let parameters = parameters {
            return try parameters.encode(request: urlRequest)
        } else {
            return urlRequest
        }
        
    }
    
}
