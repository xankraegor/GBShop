import UIKit

class SignupViewController: UIViewController, TrackableMixin {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var genderSegmenetedControl: UISegmentedControl!
    @IBOutlet weak var cardTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    var designatedUsername = ""
    var designatedPassword = ""
    var signupAcceptedByServer = false
    
    var requestFactory: RequestFactory?

    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginTextField.text = designatedUsername
        passwordTextField.text = designatedPassword
    
        signupAcceptedByServer = false
    }
    
    
    // MARK: - Button's actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        guard let login = loginTextField.text,
            UserDataFieldsChecker.userName(login).isCorrect() else {
                self.presentSimpleAlert(
                    title: "Ошибка",
                    message: "Логин указан неправильно",
                    buttonCaption: "Закрыть")
                return
        }
        
        guard let password = passwordTextField.text,
            UserDataFieldsChecker.password(password).isCorrect() else {
                self.presentSimpleAlert(
                    title: "Ошибка",
                    message: "Пароль указан неправильно",
                    buttonCaption: "Закрыть")
                return
        }
        
        guard let email = emailTextField.text,
            UserDataFieldsChecker.email(email).isCorrect() else {
                self.presentSimpleAlert(
                    title: "Ошибка",
                    message: "Адрес электронной почты указан неправильно",
                    buttonCaption: "Закрыть")
                return
        }
        
        guard let card = cardTextField.text,
            UserDataFieldsChecker.creditCard(card).isCorrect() else {
                self.presentSimpleAlert(
                    title: "Ошибка",
                    message: "Номер банковской карты указан неправильно",
                    buttonCaption: "Закрыть")
                return
        }
        
        let userData = UserData(
            // Вообще, userId должен генерироваться на сервере при успешной регистрации,
            // но тут он проставляется руками, что неправильно. Но так работает API
            userId: 123,
            userName: login,
            password: password,
            email: email,
            gender: genderSegmenetedControl.selectedSegmentIndex == 0 ? "M" : "F",
            creditCard: card,
            bio: bioTextField.text ?? "")
        
        let factory = requestFactory?.makeSignupRequestFactory()
        
        factory?.signup(userData: userData) { [weak self] response in
            DispatchQueue.main.async {
                print(response)
                switch response.result {
                case let .success(value):
                    self?.signupAcceptedByServer = (value.result == 1 ? true : false)
                    self?.performSegue(withIdentifier: Segues.UnwindToLoginSegue.rawValue, sender: nil)
                    self?.track(AnalyticsEvent.someMethod(
                        name: "signup",
                        some: "Successfully created new user `\(userData.userName ?? "")`"
                            + "with id \(userData.userId ?? -1)"))
                    return
                case let .failure(error):
                    self?.presentSimpleAlert(
                        title: "Ошибка регистрации",
                        message: error.localizedDescription,
                        buttonCaption: "Закрыть")
                    return
                }
            }
        }
    }
    

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == Segues.UnwindToLoginSegue.rawValue {
            return signupAcceptedByServer
        }
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? LoginViewController {
            destination.usernameTextField.text = loginTextField.text
        }
    }

}

extension SignupViewController: RequestFactoryProvider {
    
    func setRequestFactory(_ factory: RequestFactory) {
        self.requestFactory = factory
    }
    
}
