//
//  AuthController.swift
//  COpenSSL
//
//  Created by Xan Kraegor on 12.07.2018.
//

import Foundation
import PerfectHTTP

class AuthController {
    
    static func registerFabric<T: RequestConvertable>(
        register: T.Type,
        failureResponse: Dictionary<String, Any>,
        successResponse: Dictionary<String, Any>)
        ->((HTTPRequest, HTTPResponse) -> ()) {
            
            let genericClosure:(HTTPRequest, HTTPResponse) -> () = { request , response in
                
                guard
                    let str = request.postBodyString,
                    let data = str.data(using: .utf8)
                    else {
                        response.completed(status: HTTPResponseStatus.custom(code : 500, message: "Wrong user data"))
                        return
                }
                do {
                    let json = try JSONSerialization.jsonObject(
                        with: data,
                        options: []) as! [String: AnyObject]
                    guard let registerRequest = register.init(json: json) else {
                        try response.setBody(json: failureResponse)
                        response.completed()
                        return
                    }
                    
                    print ("Request: \(registerRequest)")
                    try response.setBody(json: successResponse)
                    response.completed()
                } catch {
                    response.completed(status : HTTPResponseStatus.custom(code: 500, message: "Parse data error: \(error)"))
                }
            }
            
            return genericClosure
    }
    
    let register:(HTTPRequest, HTTPResponse) -> () = { request , response in
        AuthController.registerFabric(
            register: RegisterRequest.self,
            failureResponse: ["result": 0 , "userMessage": "Ошибка при регистрации"],
            successResponse: ["result": 1 , "userMessage": "Регистрация прошла успешно!"]
            )(request, response)
    }
    
    let login:(HTTPRequest, HTTPResponse) -> () = { request , response in
        AuthController.registerFabric(
            register: LoginRequest.self,
            failureResponse: ["result": 0 , "userMessage": "Не удалось осуществить вход"],
            successResponse: ["result": 1 , "userMessage": "Авторизация прошла успешно"]
            )(request, response)
    }
    
    let userDataChange:(HTTPRequest, HTTPResponse) -> () = { request , response in
        AuthController.registerFabric(
            register: UserDataChangeRequest.self,
            failureResponse: ["result": 0 , "userMessage": "Не удалось изменить данные пользователя"],
            successResponse: ["result": 1 , "userMessage": "Данные пользователя успешно изменены"]
            )(request, response)
    }
    
    let logout:(HTTPRequest, HTTPResponse) -> () = { request , response in
        AuthController.registerFabric(
            register: LogoutRequest.self,
            failureResponse: ["result": 0 , "userMessage": "Не удалось осуществить выход"],
            successResponse: ["result": 1 , "userMessage": "Деавторизация прошла успешно"]
            )(request, response)
    }
    
}





