import Foundation

protocol RequestFactoryProvider {
    
    func setRequestFactory(_ factory: RequestFactory)
    
}

extension RequestFactoryProvider {
    
    var requestFactory: RequestFactory? { return nil }
}
