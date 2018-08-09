import UIKit

class PurchaseViewController: UIViewController, TrackableMixin {

    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var purchaseAddressTextField: UITextView!
    
    var user: User?
    var requestFactory: RequestFactory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserCreditCardNumberFromAPI()
    }
    
    @IBAction func purchaseButtonPressed(_ sender: Any) {
        
        guard let user = self.user else {
            assertionFailure("User is nil")
            return
        }
        
        // Нет метода API на покупку
        self.presentSimpleAlert(
            title: "Поздравляем!",
            message: "Покупка завершена успешно",
            buttonCaption: "Закрыть") { [weak self] (_) in
                self?.track(AnalyticsEvent.someMethod(
                    name: "purchase",
                    some: "Purchase successful by user with id \(user.id)"))
                self?.performSegue(
                    withIdentifier: Segues.UnwindFromPurchaseToMainSegue.rawValue,
                    sender: nil)
        }
    }
    
    func getUserCreditCardNumberFromAPI() {
        // Здесь должна быть функция по получению карты из API, которой нет,
        // так что подставляем карту по умолчанию:
        cardNumberTextField.text = "9872389-2424-234224-234"
    }

}


// MARK: - Protocol compliance

extension PurchaseViewController: UserWrapper {
    
    func setUser(_ user: User) {
        
        self.user = user
    }

}

extension PurchaseViewController: RequestFactoryProvider {
    
    func setRequestFactory(_ factory: RequestFactory) {
        
        self.requestFactory = factory
    }
    
}
