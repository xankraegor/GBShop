

import XCTest

class UITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testScreens() {
        snapshot("Login Screen")
        enterAuthData(login: "Someuser", password: "mypassword")
        checkUserAuthData(message: "Успешно")
        
        snapshot("Main Screen")
        
        let goodsTableView = app.tables["goodsTableView"]
        goodsTableView.cells.firstMatch.tap()
        
        snapshot("Merch Screen")
    }
    
    private func enterAuthData(login: String, password: String) {
        
        let loginTextField = app.textFields["loginTextField"]
        loginTextField.tap()
        loginTextField.typeText(login)
        
        let passwordTextField = app.secureTextFields["passwordTextField"]
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        let loginButton = app.buttons["loginButton"]
        loginButton.tap()
    }
    
    private func checkUserAuthData(message: String) {
        let monitor = addUIInterruptionMonitor(withDescription: message) { (alert) -> Bool in
            alert.buttons["Закрыть"].tap()
            return true
        }
        
        RunLoop.current.run(until: Date(timeInterval: 2, since: Date()))
        app.tap()
        removeUIInterruptionMonitor(monitor)
    }
    
}
