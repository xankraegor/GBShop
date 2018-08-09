import UIKit

class MerchViewController: UIViewController, TrackableMixin {
    
    private var user: User?
    private var requestFactory: RequestFactory?
    
    var currentProductId: Int {
        // При открытии окна с товаром Product Id должен зарпашиваться с сервера, это — заглушка
        return 123
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Buttons' actions
    
    @IBAction func addToCardButtonPressed(_ sender: Any) {
        
        guard let user = self.user else {
            assertionFailure("User is nil")
            return
        }
        
        let factory = requestFactory?.makeAddProductRequestFactory()
        factory?.addProduct(
            productId: currentProductId,
            quantity: 1) { [weak self] response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let value):
                        print("Product added: \(value)")
                        self?.track(AnalyticsEvent.someMethod(
                            name: "addProduct",
                            some: "Product \(self?.currentProductId ?? -1) added to basket by user with id \(user.id)"))
                        self?.presentSimpleAlert(
                            title: "Корзина",
                            message: "Товар \(value) добавлен в корзину",
                            buttonCaption: "Закрыть")
                    case .failure:
                        self?.presentSimpleAlert(
                            title: "Ошибка",
                            message: "Не удалось добавить товар в корзину",
                            buttonCaption: "Закрыть")
                    }
                }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination: UIViewController
        if let navcontroller = segue.destination as? UINavigationController {
            destination = navcontroller.viewControllers.first!
        } else {
            destination = segue.destination
        }
        
        guard let destinationController = destination as? UserWrapper & RequestFactoryProvider else {
            assertionFailure("Destination should implement DI wrappers")
            return
        }
        
        guard let user = self.user else {
            assertionFailure("User is nil")
            return
        }
        
        guard let factory = self.requestFactory else {
            assertionFailure("Request factory is nil")
            return
        }
        
        destinationController.setUser(user)
        destinationController.setRequestFactory(factory)
        
        if let basketVC = destination as? BasketViewController {
            basketVC.unwindTo = UnwindingFromBasketTo.merchView
        }
    }
    
    
    @IBAction func unwindFromBasketToMerch(withSegue: UIStoryboardSegue) {
        
    }
}

// MARK: - Protocol compliance

extension MerchViewController: RequestFactoryProvider {
    
    func setRequestFactory(_ factory: RequestFactory) {
        self.requestFactory = factory
    }
    
}

extension MerchViewController: UserWrapper {
    
    func setUser(_ user: User) {
        self.user = user
    }
    
}
