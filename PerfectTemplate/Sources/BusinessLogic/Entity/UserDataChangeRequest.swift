//
//  UserDataChangeRequest.swift
//  PerfectTemplate
//
//  Created by Xan Kraegor on 12.07.2018.
//

import Foundation

struct UserDataChangeRequest: RequestConvertable {
    var idUser: Int
    var username: String
    var password: String
    var email: String = ""
    var gender: String = ""
    var creditCard: String = ""
    var bio: String = ""
    
    init?(json: [String:AnyObject]) {
        guard let idUser = json["id_user"] as? Int,
            let username = json["username"] as? String,
            let password = json["password"] as? String
            else {
                return nil
        }
        
        self.idUser = idUser
        self.username = username
        self.password = password
        
        if let email = json["email"] as? String {
            self.email = email
        }
        if let gender = json["gender"] as? String {
            self.gender = gender
        }
        if let creditCard = json["credit_card"] as? String {
            self.creditCard = creditCard
        }
        if let bio = json["bio"] as? String {
            self.bio = bio
        }
    }
    
}
