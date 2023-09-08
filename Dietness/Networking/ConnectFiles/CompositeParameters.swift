//
//  CompositeParameters.swift
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

public struct CompositeParameters: ParametersRepresentable {
    
    public let parameters: [Parameter]
    
    public init(_ parameters: Parameter...) {
        self.parameters = parameters
    }
    
    public func encode(request: URLRequest) throws -> URLRequest {
        var request = request
        
        //Get all path parameters
        let pathParameters = parameters.filter { parameter in
            switch parameter {
            case .path:
                return true
            default:
                return false
            }
        }
        
        //Get all other parameters
        let otherParameters = parameters.filter { parameter in
            switch parameter {
            case .path:
                return false
            default:
                return true
            }
        }
        
        //Construct dictionary of all path parameters to encode at once
        var pathParametersDictionary: [String: Any] = [:]
        pathParameters.forEach { parameter in
            switch parameter {
            case .path(let key, let value):
                pathParametersDictionary[key] = value
            default:
                break
            }
        }
        
        //Fix the URL
        request.url = request.url?.withPathParameters(pathParametersDictionary)
        
        //Encode the other parameters
        try otherParameters.forEach { parameter in
            request = try parameter.encode(request: request)
        }
        
        return request
    }
}
