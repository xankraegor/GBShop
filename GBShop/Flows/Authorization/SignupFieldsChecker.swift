import Foundation

enum UserDataFieldsChecker {
    
    case userName(String)
    case password(String)
    case email(String)
    case creditCard(String)
    
    func isCorrect() -> Bool {
        switch self {
        case let .userName(name):
            return name.count > 3 &&
                name.containsCaharctersInSet(.urlUserAllowed)
        case let .password(password):
            return password.count > 8 &&
                password.containsCaharctersInSet(.urlPasswordAllowed)
        case let .email(email):
            return email.isValidEmail()
        case let .creditCard(card):
            return 16...18 ~= card.count &&
                card.containsCaharctersInSet(.numbers)
            
        }
    }
    
}
