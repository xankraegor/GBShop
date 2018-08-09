import Alamofire

class Auth: AbstractRequestFactory, TrackableMixin {
    
    let errorParser: AbstractErrorParser
    let sessionManager: SessionManager
    let queue: DispatchQueue?
    let config: Config
    
    init(
        errorParser: AbstractErrorParser,
        sessionManager: SessionManager,
        queue: DispatchQueue? = DispatchQueue.global(qos: .utility),
        config: Config) {
        
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
        self.config = config
    }
}

extension Auth:
    LoginRequestFactory,
    LogoutRequestFactory,
    SignupRequestFactory,
ChangeUserDataRequestFactory {
    
    func login(
        login: String,
        password: String,
        completionHandler: @escaping (DataResponse<LoginResult>)
        -> Void) {
        
        let requestModel = Login(
            baseUrl: config.baseUrl,
            login: login,
            password: password)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func logout(
        userId: Int,
        completionHandler: @escaping (DataResponse<LogoutResult>)
        -> Void) {
        
        let requestModel = Logout(
            baseUrl: config.baseUrl,
            userId: userId)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func signup(
        userData: UserData,
        completionHandler: @escaping (DataResponse<SignupResult>)
        -> Void) {
        
        let requestModel = Signup(
            baseUrl: config.baseUrl,
            userData: userData)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func changeUserData(
        with data: UserData,
        completionHandler: @escaping (DataResponse<ChangeUserDataResult>)
        -> Void) {
        
        let requestModel = UserDataChange(
            baseUrl: config.baseUrl,
            userData: data)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
}

extension Auth:
    AddReviewRequestFactory,
    RemoveReviewRequestFactory,
ApproveReviewRequestFactory {
    
    func addReview(
        
        userId: Int,
        review: String,
        completionHandler: @escaping (DataResponse<AddReviewResult>)
        -> Void) {
        
        let requestModel = AddReview(
            baseUrl: config.baseUrl,
            userId: userId,
            review: review)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func removeReview(
        reviewId: Int,
        completionHandler: @escaping (DataResponse<RemoveReviewResult>)
        -> Void) {
        
        let requestModel = RemoveReview(
            baseUrl: config.baseUrl,
            reviewId: reviewId)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func approveReview(
        reviewId: Int,
        completionHandler: @escaping (DataResponse<ApproveReviewResult>)
        -> Void) {
        
        let requestModel = ApproveReview(
            baseUrl: config.baseUrl,
            reviewId: reviewId)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
}

extension Auth:
    AddProductRequestFactory,
    RemoveProductRequestFactory,
    CatalogDataRequestFactory,
GetBasketRequestFactory {


    func addProduct(
        productId: Int,
        quantity: Int,
        completionHandler: @escaping (DataResponse<AddProductResult>)
        -> Void) {
        
        let requestModel = AddProduct(
            baseUrl: config.baseUrl,
            productId: productId,
            quantity: quantity)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func removeProduct(
        productId: Int,
        completionHandler: @escaping (DataResponse<RemoveProductResult>)
        -> Void) {
        
        let requestModel = RemoveProduct(baseUrl: config.baseUrl, productId: productId)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func getBasket(
        userId: Int,
        completionHandler: @escaping (DataResponse<GetBasketResult>)
        -> Void) {
        
        let requestModel = GetBasket(baseUrl: config.baseUrl, userId: userId)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func catalogData(
        pageNumber: Int,
        categoryId: Int,
        completionHandler: @escaping (DataResponse<CatalogDataResult>) -> Void) {
        
        let requestModel = CatalogData(baseUrl: config.baseUrl, pageNumber: pageNumber, categoryId: categoryId)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
}


// MARK: - Supporting structs

private struct Login: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "login.json"
    
    let login: String
    let password: String
    
    var parameters: Parameters? {
        
        return [
            "username": login,
            "password": password
        ]
    }
}

private struct Logout: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "logout.json"
    
    let userId: Int
    
    var parameters: Parameters? {
        
        return [
            "id_user": userId
        ]
    }
}

private struct Signup: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "registerUser.json"
    
    let userData: UserData
    
    var parameters: Parameters? {
        
        return [
            "id_user": userData.userId ?? -1,
            "username": userData.userName ?? "",
            "password": userData.password ?? "",
            "email": userData.email ?? "",
            "gender": userData.gender ?? "",
            "credit_card": userData.creditCard ?? "",
            "bio": userData.bio ?? ""
        ]
    }
}

private struct UserDataChange: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "changeUserData.json"
    
    let userData: UserData
    
    var parameters: Parameters? {
        
        return [
            "id_user": userData.userId ?? -1,
            "username": userData.userName ?? "",
            "password": userData.password ?? "",
            "email": userData.email ?? "",
            "gender": userData.gender ?? "",
            "credit_card": userData.creditCard ?? "",
            "bio": userData.bio ?? ""
        ]
    }
}


private struct AddReview: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "addReview.json"
    
    let userId: Int
    let review: String
    
    var parameters: Parameters? {
        
        return [
            "id_user": userId,
            "text": review
        ]
    }
}

private struct ApproveReview: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "approveReview.json"
    
    let reviewId: Int
    
    var parameters: Parameters? {
        
        return [
            "id_comment": reviewId
        ]
    }
}

private struct RemoveReview: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "approveReview.json"
    
    let reviewId: Int
    
    var parameters: Parameters? {
        
        return [
            "id_comment": reviewId
        ]
    }
}

private struct AddProduct: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "addToBasket.json"
    
    let productId: Int
    let quantity: Int
    
    var parameters: Parameters? {
        
        return [
            "id_product": productId,
            "quantity": quantity
        ]
    }
}

private struct RemoveProduct: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "deleteFromBasket.json"
    
    let productId: Int
    
    var parameters: Parameters? {
        
        return [
            "id_product": productId
        ]
    }
}

private struct GetBasket: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "getBasket.json"
    
    let userId: Int
    
    var parameters: Parameters? {
        
        return [
            "id_user": userId
        ]
    }
}

private struct CatalogData: RequestRouter {
    
    let baseUrl: URL
    let method: HTTPMethod = .get
    let path: String = "catalogData.json"
    
    let pageNumber: Int
    let categoryId: Int
    
    var parameters: Parameters? {
        
        return [
            "page_number": pageNumber,
            "id_category": categoryId
        ]
    }
}
