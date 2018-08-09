import UIKit

enum UnwindingFromBasketTo {
    
    case mainView // default
    case merchView
    
}


class BasketViewController: UIViewController {
    
    var factory: RequestFactory?
    var user: User?
    var unwindTo = UnwindingFromBasketTo.mainView
    
    var basketItems: [BasketItem] = []
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "BasketTableViewCell", bundle: nil),
            forCellReuseIdentifier: Cells.basketTableViewCellIdentifier.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBasketContentFromServer()
    }

    func getBasketContentFromServer() {
        
        guard let factory = self.factory?.makeGetBasketRequestFactory() else {
            assertionFailure("Factory is nil")
            return
        }
        
        // В описании API неправильно указан id_user для этой операции: 1 вместо 123 в других случаях,
        // поэтому напрямую получить id пользователя чепез DI (user!.id), начиная с авторизации, не получится:
        let fakeUserId = 1
        
        factory.getBasket(userId: fakeUserId) { [weak self] response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    self?.basketItems = value.contents
                    self?.tableView.reloadData()
                case let .failure(error):
                    self?.presentSimpleAlert(
                        title: "Ошибка при обновлении корзины",
                        message: "\(error.localizedDescription). Попробуйте зайти в корзину еще раз",
                        buttonCaption: "Закрыть")
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        let identifier: String
        switch unwindTo {
        case .mainView:
            identifier = Segues.UnwindFromBasketToMainSegue.rawValue
        case .merchView:
            identifier = Segues.UnwindFromBasketToMerchSegue.rawValue
        }
        
        performSegue(
            withIdentifier: identifier,
            sender: nil)
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination: UIViewController
        if let navcontroller = segue.destination as? UINavigationController {
            if let dest = navcontroller.viewControllers.first {
                destination = dest
            } else {
                assertionFailure("Destination controller is nil")
                return
            }
        } else {
            destination = segue.destination
        }
        
        guard let destinationController = destination as? UserWrapper & RequestFactoryProvider else {
            assertionFailure("Can't cast destination controller as? UserWrapper & RequestFactoryProvider")
            return
        }
        
        guard let user = self.user else {
            assertionFailure("User is nil")
            return
        }
        
        guard let factory = self.factory else {
            assertionFailure("Request factory is nil")
            return
        }
        
        destinationController.setUser(user)
        destinationController.setRequestFactory(factory)
        
    }

}

// MARK: - Protocol Compliance

extension BasketViewController: UserWrapper {
    
    func setUser(_ user: User) {
        
        self.user = user
    }
    
}

extension BasketViewController: RequestFactoryProvider {
    
    func setRequestFactory(_ factory: RequestFactory) {
        
        self.factory = factory
    }
    
}

extension BasketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.basketTableViewCellIdentifier.rawValue) as! BasketTableViewCell
        cell.itemNameLabel.text = basketItems[indexPath.row].productName
        cell.itemQuantityLabel.text = "Количество: \(basketItems[indexPath.row].quantity)"
        cell.itemPriceLabel.text = "\(basketItems[indexPath.row].price) руб."
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension BasketViewController: UITableViewDelegate {
    
}
