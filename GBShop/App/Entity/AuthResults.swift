import Foundation

struct LoginResult: Codable {
    
    let result: Int
    let user: User
}

struct User: Codable {
    
    let id: Int
    let login: String
    let name: String
    let lastname: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_user"
        case login = "user_login"
        case name = "user_name"
        case lastname = "user_lastname"
    }
}

struct SignupResult: Codable {
    
    let result: Int
    let userMessage: String
}

struct LogoutResult: Codable {
    
    let result: Int
}

struct ChangeUserDataResult: Codable {
    
    let result: Int
}
