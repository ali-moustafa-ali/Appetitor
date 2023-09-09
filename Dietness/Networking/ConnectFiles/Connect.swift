//
//  Connect.swift
//
//  Copyright (c) 2020 Tarek Sabry


import Foundation
import Alamofire

public protocol ErrorHandlerProtocol {
    func handle(response: [String: Any]) -> Error?
}

open class ErrorHandler: ErrorHandlerProtocol {
    
    public func handle(response: [String: Any]) -> Error? {
        if let error = response["msg"] as? String {
            return ConnectError.unknownError(message: error)
        } else if let error = response["message"] as? String {
//            if Helper.isEnglish() {
                return ConnectError.unknownError(message: error)
//            }else{
//                if let arError = response["ar_message"] as? String{
//                    return ConnectError.unknownError(message: arError)
//                }
//            }
//
        } else if let error = response["error"] as? String {
            return ConnectError.unknownError(message: error)
        } else if let error = response["err"] as? String {
            return ConnectError.unknownError(message: error)
        }
        else if let error = response["error_message"] as? String{
            return ConnectError.unknownError(message: error)
        }
//        if Helper.isEnglish(){
//            if let error = response["message"] as? String {
//                return ConnectError.unknownError(message: error)
//                        }
//        }else{
//            if let error = response["ar_message"] as? String {
//                return ConnectError.unknownError(message: error)
//            }
//        }
        
        return ConnectError.internalServerError
    }
    
    public init() {}
}

open class Connect {
    
    private let middleware: ConnectMiddlewareProtocol
    private let errorHandler: ErrorHandlerProtocol
    
    private lazy var session: Session = middleware.session
    
    public static let `default`: Connect = Connect()
    
    public init(middleware: ConnectMiddlewareProtocol = ConnectMiddleware(), errorHandler: ErrorHandlerProtocol = ErrorHandler()) {
        self.middleware = middleware
        self.errorHandler = errorHandler
    }
    
    private func parseResponse(response: AFDataResponse<Data>,vc:UIViewController? = nil) -> Error? {
        
        if response.response?.statusCode == 204{
                   return ConnectError.noContent
        }
//        if response.response?.statusCode == 401{
//            let sessionendedvc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: "SessionEndedVC") as! SessionEndedVC
//            vc?.present(sessionendedvc, animated: false, completion: nil)
//            return ConnectError.unknownError(message: "")
//        }
        
        
        if (200 ..< 300).contains(response.response?.statusCode ?? 0) == false {
            if  (response.error as NSError?)?.code == -999 {
                       return ConnectError.cancelled
                   }
                   if  (response.error as NSError?)?.code == -1009 {
                       return ConnectError.noInternetConnection
                   }
        
            guard let errorResponse = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: AnyObject] else {
                return response.error}
            return errorHandler.handle(response: errorResponse)
        }

        return nil
    }
    
     func request(_ request: Connector, debugResponse: Bool = false,vc:UIViewController? = nil ) -> Future<Data> {
        let promise = Promise<Data>()
        
        session.request(request).cURLDescription(calling: Request.debugLog).validate().responseData { [weak self] response in
            guard let self = self else { return }

            print(response.debugDescription, "response debug description")
            
            #if DEBUG
            if debugResponse {
                print((response.data ?? Data()).prettyPrintedJSONString ?? "")
            }
            #endif

            if let error = self.parseResponse(response: response,vc: vc) {
                promise.reject(with: error)
                return
            }
            
            switch response.result {
            case .success(let data):
                promise.resolve(with: data)
            case .failure(let error):
                print(response.result)
                promise.reject(with: error)
            }
        }
        
        return promise
    }

    public func upload(files: [File]?, to request: Connector, debugResponse: Bool = false) -> Future<Data> {
        let promise = Promise<Data>()
        session.upload(multipartFormData: { formData in

            if let files = files {
                files.forEach { file in
                    formData.append(file.data, withName: file.key, fileName: file.name, mimeType: file.mimeType.rawValue)
                }
            }

            if let parameters = request.parameters {
                if let parameter = parameters as? Parameter {
                    switch parameter {
                    case .jsonObject(let object):
                        try? object.asDictionary().forEach { key, value in
                            formData.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
                        }
                    default:
                        break
                    }
                } else if let compositeParameters = parameters as? CompositeParameters {
                    compositeParameters.parameters.forEach { parameter in
                        switch parameter {
                        case .jsonObject(let object):
                            try? object.asDictionary().forEach { key, value in
                                formData.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
                            }
                        default:
                            break
                        }
                    }
                }
            }

        }, with: request).cURLDescription(calling: Request.debugLog).validate().responseData { [weak self] response in
            guard let self = self else { return }
            
            #if DEBUG
            if debugResponse {
                print((response.data ?? Data()).prettyPrintedJSONString ?? "")
            }
            #endif

            if let error = self.parseResponse(response: response) {
                promise.reject(with: error)
                return
            }

            switch response.result {
            case .success(let data):
                promise.resolve(with: data)
            case .failure(let error):
                promise.reject(with: error)
            }
        }
        
        return promise
    }
    
    public func cancelAllRequests() {
        session.cancelAllRequests()
    }
}
