import Alamofire

class RequestFactory {
    
    private var config: Config
    
    init(config: Config) {
        
        self.config = config
    }
    
    private func makeErrorParser()
        -> AbstractErrorParser {
            
        return ErrorParser()
    }
    
    private lazy var commonSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = SessionManager(configuration: configuration)
        return manager
    }()
    
    private let sessionQueue = DispatchQueue.global(qos: .utility)
    
    private func makeAbstractRequestFactory() -> AbstractRequestFactory {
        let errorParser = makeErrorParser()
        return Auth(
            errorParser: errorParser,
            sessionManager: commonSessionManager,
            queue: sessionQueue,
            config: config)
    }
    
    // swiftlint:disable force_cast
    
    func makeAuthRequestFactory()
        -> LoginRequestFactory {
            
            return makeAbstractRequestFactory() as! LoginRequestFactory
    }
    
    func makeSignupRequestFactory()
        -> SignupRequestFactory {
            
        return makeAbstractRequestFactory() as! SignupRequestFactory
    }
    
    func makeLogoutRequestFactory()
        -> LogoutRequestFactory {
            
        return makeAbstractRequestFactory() as! LogoutRequestFactory
    }
    
    func makeChangeUserDataRequestFactory()
        -> ChangeUserDataRequestFactory {
            
        return makeAbstractRequestFactory() as! ChangeUserDataRequestFactory
    }
    
    func makeAddReviewRequestFactory()
        -> AddReviewRequestFactory {
            
        return makeAbstractRequestFactory() as! AddReviewRequestFactory
    }
    
    func makeApproveReviewRequestFactory()
        -> ApproveReviewRequestFactory {
            
        return makeAbstractRequestFactory() as! ApproveReviewRequestFactory
    }
    
    func makeRemoveReviewRequestFactory()
        -> RemoveReviewRequestFactory {
            
        return makeAbstractRequestFactory() as! RemoveReviewRequestFactory
    }
    
    func makeAddProductRequestFactory()
        -> AddProductRequestFactory {
            
            return makeAbstractRequestFactory() as! AddProductRequestFactory
    }
    
    func makeRemoveProductRequestFactory()
        -> RemoveProductRequestFactory {
            
            return makeAbstractRequestFactory() as! RemoveProductRequestFactory
    }
    
    func makeCatalogDataRequestFactory()
        -> CatalogDataRequestFactory {
            
            return makeAbstractRequestFactory() as! CatalogDataRequestFactory
    }
    
    func makeGetBasketRequestFactory()
        -> GetBasketRequestFactory {
            
            return makeAbstractRequestFactory() as! GetBasketRequestFactory
    }
    
    // swiftlint:enable force_cast
}
