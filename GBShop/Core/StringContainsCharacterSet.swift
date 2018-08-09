import Foundation

extension String {
    
    func containsCaharctersInSet(_ set: CharacterSet) -> Bool {
        let charactersInString = CharacterSet(charactersIn: self)
        return charactersInString.isStrictSubset(of: set)
    }
    
}
