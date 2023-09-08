//
//  DietnessServices.swift
//  Dietness
//
//  Created by mohamed dorgham on 08/07/2021.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation
import Alamofire
import MOLH

class DietnessServices {
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable, ErrorResponse:Decodable >(url: URL, responseType: ResponseType.Type, body: RequestType,errorResponse:ErrorResponse.Type, completion: @escaping (ResponseType?,ErrorResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(((MOLHLanguage.currentAppleLanguage() == "ar") ? "ar" : "en"), forHTTPHeaderField: "Accept-Language")
        request.addValue("Bearer \(SettingsManager.init().getUserToken())", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil,nil,error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject,nil,nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil,errorResponse,nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil,nil,error)
                    }
                }
            }
        }
        task.resume()
    }
    class func order(day:String,items:[CartItem], completion:@escaping (_ success: Bool, _ orderResponse: OrderResponse?, _ error:Error?, _ orderError: OrderErrorResponse?)->Void){
        
        
        let parameters: [String : Any] = [
            "day": day,
            "items": items
        ]
        let headers: HTTPHeaders = [
            "Accept-Language": MOLHLanguage.currentAppleLanguage(),
            "Authorization": "Bearer \(SettingsManager.init().getUserToken())",
            "Content-Type": "application/json"
        ]
        
        AF.request("\(Endpnts.order.stringValue)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString {
            (response) in
            let decoder = JSONDecoder()
            guard let data = response.data else {return}
            switch response.result {
            case .success:
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("order_JSON: \(json)")
                    
                    let convertedString = String(data: data, encoding: String.Encoding.utf8)
                    if !(convertedString?.contains("error"))! {
                        guard let orderResponse = try? decoder.decode(OrderResponse.self, from: data) else {
                            completion(false, nil, nil, nil)
                            return
                        }
                        completion(true, orderResponse, nil, nil)
                    }else{
                        guard let orderError = try? decoder.decode(OrderErrorResponse.self, from: data) else {
                            completion(false, nil, nil, nil)
                            return
                        }
                        completion(false, nil, nil, orderError)
                    }
                } catch let jsonErr {
                    print("Error decoding order: ", jsonErr)
                    completion(false, nil, jsonErr, nil)
                }
            case .failure(let error):
                print("orderError: \(error.localizedDescription)")
                completion(false, nil, error, nil)
                
            }
            
        }
        
    }
    class func addOrder(day: String, items: [CartItem], completion: @escaping (OrderResponse?,OrderErrorResponse?,Error?) -> Void) {
        let body = OrderRequest(day: day, items: items)
        taskForPOSTRequest(url: Endpnts.order.url, responseType: OrderResponse.self, body: body, errorResponse: OrderErrorResponse.self) { (OrderResponse, OrderErrorResponse, error) in
            print("addOrderBody: \(body.items)")
            if let OrderResponse = OrderResponse{
                completion(OrderResponse,nil,nil)
            }
            if let orderError = OrderErrorResponse{
                completion(nil,orderError,nil)
            }
            if let error = error{
                completion(nil,nil,error)
            }
            
        }
    }
}
