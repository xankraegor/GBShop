import XCTest
@testable import GBShop

class NetflowTests: XCTestCase {
    
    // MARK: - Prerequirements
    
    let requestFactory: RequestFactory =
        RequestFactory(config: Config())
    
    let expectionTimeout: TimeInterval = 2
    
    let userData = UserData(
        userId: 123,
        userName: "Somebody",
        password: "mypassword",
        email: "some@some.ru",
        gender: "m",
        creditCard: "9872389-2424-234224-234",
        bio: "This is good! I think I will switch to another language")
    
    let reviewText = "This vaccuum cleaner sucks!"
    let reviewId = 123
    let productId = 123
    let productQuantity = 1
    
    // MARK: - Tests
    
    func testSignUp() {
        
        let signupExpectation = XCTestExpectation(description: "Signup successfull")
        let signup = requestFactory.makeSignupRequestFactory()
        signup.signup(
            userData: userData) { response in
            switch response.result {
            case .success(let login):
                print("SignUP: \(login)")
                signupExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [signupExpectation], timeout: expectionTimeout)
    }
    
    func testLogin() {
        
        let loginExpectation = XCTestExpectation(description: "Login successfull")
        let auth = requestFactory.makeAuthRequestFactory()
        auth.login(
            login: userData.userName!,
            password: userData.password!) { response in
            switch response.result {
            case .success(let login):
                print("Login: \(login)")
                loginExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [loginExpectation], timeout: expectionTimeout)
    }
    
    func testUserDataChange() {
        
        let userDataChangedExpectation = XCTestExpectation(description: "User data change successfull")
        let userDataChange = requestFactory.makeChangeUserDataRequestFactory()
        userDataChange.changeUserData(with: userData)
        { response in
            switch response.result {
            case .success(let value):
                print("User data change: \(value)")
                userDataChangedExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [userDataChangedExpectation], timeout: expectionTimeout)
    }
    
    func testLogout() {
        
        let logoutExpectation = XCTestExpectation(description: "Logout successfull")
        let logout = requestFactory.makeLogoutRequestFactory()
        logout.logout(userId: 123)
        { response in
            switch response.result {
            case .success(let value):
                print("Logout: \(value)")
                logoutExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [logoutExpectation], timeout: expectionTimeout)
    }
    
    func testAddReview() {
        
        let addReviewExpectation = XCTestExpectation(description: "Review added successfully")
        let addReview = requestFactory.makeAddReviewRequestFactory()
        addReview.addReview(userId: userData.userId!, review: reviewText)
        { response in
            switch response.result {
            case .success(let value):
                print("Add Review: \(value)")
                addReviewExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [addReviewExpectation], timeout: expectionTimeout)
    }
    
    func testRemoveReview() {
        
        let removeReviewExpectation = XCTestExpectation(description: "Review removed expactation")
        let removeReview = requestFactory.makeRemoveReviewRequestFactory()
        removeReview.removeReview(reviewId: reviewId)
        { response in
            switch response.result {
            case .success(let value):
                print("Remove Review: \(value)")
                removeReviewExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [removeReviewExpectation], timeout: expectionTimeout)
    }
    
    func testApproveReview() {
        
        let approveReviewExpectation = XCTestExpectation(description: "Review approved expactation")
        let approveReview = requestFactory.makeApproveReviewRequestFactory()
        approveReview.approveReview(reviewId: reviewId)
        { response in
            switch response.result {
            case .success(let value):
                print("Approve Review: \(value)")
                approveReviewExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [approveReviewExpectation], timeout: expectionTimeout)
    }
    
    func testAddProduct() {
        
        let productAddedExpectation = XCTestExpectation(description: "Product added expactation")
        let addProduct = requestFactory.makeAddProductRequestFactory()
        addProduct.addProduct(productId: productId, quantity: productQuantity)
        { response in
            switch response.result {
            case .success(let value):
                print("Product added: \(value)")
                productAddedExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [productAddedExpectation], timeout: expectionTimeout)
    }
    
    func testRemoveProduct() {
        
        let productRemovedExpectation = XCTestExpectation(description: "Product removed expactation")
        let removeProduct = requestFactory.makeRemoveProductRequestFactory()
        removeProduct.removeProduct(productId: productId)
        { response in
            switch response.result {
            case .success(let value):
                print("Product removed: \(value)")
                productRemovedExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [productRemovedExpectation], timeout: expectionTimeout)
    }
    
    func testGetBasketProduct() {
        
        let getBasketExpectation = XCTestExpectation(description: "Get basket expactation")
        let getBasket = requestFactory.makeGetBasketRequestFactory()
        getBasket.getBasket(userId: userData.userId!)
        { response in
            switch response.result {
            case .success(let value):
                print("Get basket: \(value)")
                getBasketExpectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [getBasketExpectation], timeout: expectionTimeout)
    }
}
