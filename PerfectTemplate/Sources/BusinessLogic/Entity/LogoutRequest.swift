//
//  LogoutRequest.swift
//  COpenSSL
//
//  Created by Xan Kraegor on 12.07.2018.
//

import Foundation

struct LogoutRequest: RequestConvertable {
    
    var idUser: Int
    
    init?(json: [String:AnyObject]) {
        guard let idUser = json["id_user"] as? Int else {
            return nil
        }
        
        self.idUser = idUser
    }
    
}
