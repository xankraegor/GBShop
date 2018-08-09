import Alamofire

protocol LoginRequestFactory {
    
    func login(
        login: String,
        password: String,
        completionHandler: @escaping (DataResponse<LoginResult>) -> Void)
    
}

protocol LogoutRequestFactory {
    
    func logout(
        userId: Int,
        completionHandler: @escaping (DataResponse<LogoutResult>) -> Void)
    
}

protocol SignupRequestFactory {
    
    func signup(
        userData: UserData,
        completionHandler: @escaping (DataResponse<SignupResult>) -> Void)
    
}

protocol ChangeUserDataRequestFactory {
    
    func changeUserData(
        with data: UserData,
        completionHandler: @escaping (DataResponse<ChangeUserDataResult>) -> Void)
    
}
