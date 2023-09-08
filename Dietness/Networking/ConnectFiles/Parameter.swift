//
//  Parameter.swift
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

public enum Parameter: ParametersRepresentable {
    case query(key: String, value: String)
    case queryInt(key: String, value: Int)
    case path(key: String, value: String)
    case jsonObject(value: Encodable)
    
    public func encode(request: URLRequest) throws -> URLRequest {
        switch self {
        case .query(let key, let value):
            return try URLEncoding.queryString.encode(request, with: [key: value])
        case .path(let key, let value):
            var request = request
            request.url = request.url?.withPathParameters([key: value])
            return request
        case .jsonObject(let value):
            return try JSONEncoding.default.encode(request, with: value.asDictionary())
        case .queryInt(let key, let value):
            return try URLEncoding.queryString.encode(request, with: [key: value])
        }
    }
}
