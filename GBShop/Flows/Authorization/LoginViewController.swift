import UIKit

class LoginViewController: UIViewController, TrackableMixin {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var user: User?
    var requestFactory: RequestFactory?
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    // MARK: - Buttons' events
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        guard let username = usernameTextField.text, username.count > 0,
            let password = passwordTextField.text, password.count > 0 else {
                self.presentSimpleAlert(
                    title: "Ошибка",
                    message: "Необходимо ввести логин и пароль",
                    buttonCaption: "Закрыть")
                return
        }
        
        let factory = requestFactory?.makeAuthRequestFactory()
        factory?.login(login: username, password: password) { [weak self] (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    self?.track(AnalyticsEvent.login(
                        method: AnalyticsEvent.LoginParams.methodDefault,
                        success: true))
                    self?.user = result.user
                    self?.performSegue(
                        withIdentifier: Segues.MainStoryboardSegue.rawValue,
                        sender: nil)
                case .failure:
                    self?.track(AnalyticsEvent.login(
                        method: AnalyticsEvent.LoginParams.methodDefault,
                        success: false))
                    self?.presentSimpleAlert(
                        title: "Ошибка",
                        message: "Данные введены не верно",
                        buttonCaption: "Закрыть")
                }
            }
        }
    }
    
        // MARK: - Navigation
        
        override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            
            if identifier == Segues.MainStoryboardSegue.rawValue {
                return user?.id != nil
            }
            
            return true
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let destination: UIViewController
            if let navcontroller = segue.destination as? UINavigationController {
                destination = navcontroller.viewControllers.first!
            } else {
                destination = segue.destination
            }
            
            guard let destinationController = destination as? UserWrapper & RequestFactoryProvider else {
                assertionFailure("Can't cast destination controller as? UserWrapper & RequestFactoryProvider")
                return
            }
            
            guard let user = user else {
                assertionFailure("User is nil")
                return
            }
            
            guard let factory = requestFactory else {
                assertionFailure("Request factory is nil")
                return
            }

            destinationController.setUser(user)
            destinationController.setRequestFactory(factory)
            
        }
        
        @IBAction func unwindFromSignup(segue: UIStoryboardSegue) {
            
            if let username = user?.login {
                self.usernameTextField.text = username
            }
            
        }
    
        @IBAction func unwindAfterLogout(segue: UIStoryboardSegue) {
            
            if let username = user?.login {
                self.usernameTextField.text = username
            }
            
            passwordTextField.text = ""
        }
        
    }
    
    
    // MARK: - Protocol compliance
    
    extension LoginViewController: RequestFactoryProvider {
        
        func setRequestFactory(_ factory: RequestFactory) {
            self.requestFactory = factory
        }
    }
    
    extension LoginViewController: UserWrapper {
        
        func setUser(_ user: User) {
            self.user = user
        }
        
}
