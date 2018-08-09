import UIKit

class UserDataChangeViewController: UIViewController {
    
    enum ChangeableUserData {
        
        case userName(String)
        case password(String)
        case email(String)
        case creditCard(String)
        case bio(String)
        
        func isCorrect() -> Bool {
            switch self {
            case let .userName(name):
                return UserDataFieldsChecker.userName(name).isCorrect()
            case let .password(pass):
                return UserDataFieldsChecker.password(pass).isCorrect()
            case let .email(email):
                return UserDataFieldsChecker.email(email).isCorrect()
            case let .creditCard(card):
                return UserDataFieldsChecker.creditCard(card).isCorrect()
            case .bio:
                return true
            }
        }
        
        func titleDescription() -> String {
            
            switch self {
                
            case .userName(_):
                return "Имя пользователя"
            case .password(_):
                return "Пароль"
            case .email(_):
                return "Адрес электронной почты"
            case .creditCard(_):
                return "Номер банковской карты"
            case .bio:
                return "Дополнительная информация"
            }
        }
        
        func textDescription() -> String {
            
            switch self {
                
            case .userName(_):
                return "Может состоять из анлгийских букв (строчных и заглавных), символов, точки, тире и знака подчеркивания. Длина должна быть не менее 4 символов"
            case .password(_):
                return "Может состоять из анлгийских букв (строчных и заглавных), символов, точки, тире и знака подчеркивания. Длина должна быть не менее 8 символов. Рекомендуется создавать пароль из нескольких слов общей длинной не менее 12 символов"
            case .email(_):
                return "Ничего необычного :)"
            case .creditCard(_):
                return "Номер банковской карты без пробелов длиной от 12 до 16 цифр"
            case .bio:
                return "Все, что вы дополнительно хотите сообщить и если хотите"
            }
        }
        
        func value() -> String {
            switch self {
                
            case let .userName(value):
                return value
            case let .password(value):
                return value
            case let .email(value):
                return value
            case let .creditCard(value):
                return value
            case let .bio(value):
                return value
            }
        }
        
    }
    
    
    var user: User?
    var requestFactory: RequestFactory?
    var userData: UserData?
    var changeable: ChangeableUserData?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dataDescriptionLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeable = ChangeableUserData.email(userData?.email ?? "")
        updateLabelsAndTextAccordingToSelectedEntry()
    }
    
    func updateLabelsAndTextAccordingToSelectedEntry() {
        titleLabel.text = changeable?.titleDescription()
        dataDescriptionLabel.text = changeable?.textDescription()
        textField.text = changeable?.value()
    }
    
    // MARK: - Button's actions
    
    @IBAction func goToNextUserDataEntryButtonPressed(_ sender: Any) {
        
        checkAndChangeCurrentUserDataEntry()
        guard let unwrappedChangeable = changeable else {
            assertionFailure("Changeable is nil")
            return
        }
        
        switch unwrappedChangeable {
        
        case .userName(_):
            changeable = ChangeableUserData.password(userData?.password ?? "")
        case .password(_):
            changeable = ChangeableUserData.email(userData?.email ?? "")
        case .email(_):
            changeable = ChangeableUserData.creditCard(userData?.creditCard ?? "")
        case .creditCard(_):
            changeable = ChangeableUserData.bio(userData?.bio ?? "")
        case .bio(_):
            changeable = ChangeableUserData.userName(userData?.userName ?? "")
        }
        
        updateLabelsAndTextAccordingToSelectedEntry()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        checkAndChangeCurrentUserDataEntry()
        
        guard let unwrappedChangeable = changeable else {
            assertionFailure("Changeable is nil")
            return
        }
        
        switch unwrappedChangeable {
            
        case .userName(_):
            changeable = ChangeableUserData.bio(userData?.bio ?? "")
        case .password(_):
            changeable = ChangeableUserData.userName(userData?.userName ?? "")
        case .email(_):
            changeable = ChangeableUserData.password(userData?.password ?? "")
        case .creditCard(_):
            changeable = ChangeableUserData.email(userData?.email ?? "")
        case .bio(_):
            changeable = ChangeableUserData.creditCard(userData?.creditCard ?? "")
        }
        
        updateLabelsAndTextAccordingToSelectedEntry()
    }
    
    private func checkAndChangeCurrentUserDataEntry() {
        
        guard let unwrappedChangeable = changeable else {
            assertionFailure("Changeable is nil")
            return
        }
        
        guard unwrappedChangeable.isCorrect() else {
            self.presentSimpleAlert(
                title: "Ошбика",
                message: "Данные указаны неправильно. Пожалуйста, проверьте их!",
                buttonCaption: "Закрыть")
            return
        }
        
        switch unwrappedChangeable {
        case .userName:
            userData?.userName = textField.text
        case .password:
            userData?.password = textField.text
        case .email:
            userData?.email = textField.text
        case .creditCard:
            userData?.creditCard = textField.text
        case .bio:
            userData?.bio = textField.text
        }
        
    }
    
    @IBAction func updateUserDataButtonPressed(_ sender: Any) {
        
        guard let userData = userData else {
            assertionFailure("User data is nil")
            return
        }
        
        let factory = requestFactory?.makeChangeUserDataRequestFactory()
        factory?.changeUserData(
        with: userData) { [weak self] (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    if result.result == 1 {
                        self?.dismiss(animated: true, completion: nil)
                    } else {
                        self?.presentSimpleAlert(
                            title: "Ошибка",
                            message: "Не получилось обновить данные пользователя. Проверьте соединение с сетью",
                            buttonCaption: "Закрыть")
                    }
                case .failure:
                    self?.presentSimpleAlert(
                        title: "Ошибка",
                        message: "Данные введены не верно",
                        buttonCaption: "Закрыть")
                }
            }
        }
    }
    
}

// MARK: - Protocol compliance

extension UserDataChangeViewController: UserWrapper {
    
    func setUser(_ user: User) {
        self.user = user
    }
    
}

extension UserDataChangeViewController: RequestFactoryProvider {
    
    func setRequestFactory(_ factory: RequestFactory) {
        self.requestFactory = factory
    }

}
