//
//  LoginRequest.swift
//  PerfectTemplate
//
//  Created by Xan Kraegor on 12.07.2018.
//

import Foundation

struct LoginRequest: RequestConvertable {
    var username : String
    var password : String
    
    init?(json: [String:AnyObject]) {
        guard
            let username = json["username"] as? String,
            let password = json["password"] as? String
            else {
                return nil
        }
        
        self.username = username
        self.password = password
    }
    
}
