import Foundation

protocol UserWrapper {
    
    func setUser(_ user: User)
    
}

extension UserWrapper {
    
    var user: User? { return nil }
}
