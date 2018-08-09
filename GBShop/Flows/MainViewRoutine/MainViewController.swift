import UIKit

class MainViewController: UIViewController, TrackableMixin {
    
    var user: User?
    var requestFactory: RequestFactory?
    
    var goods: [Product] = []
    
    var categoryIdToDispay = 1
    var pageToDisplay = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "GoodsTableViewCell", bundle: nil),
            forCellReuseIdentifier: Cells.goodsTableViewCellIdentifier.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGoodsFromServer()
    }
    
    func getGoodsFromServer() {
        
        guard let factory = self.requestFactory?.makeCatalogDataRequestFactory() else {
            assertionFailure("Factory is nil")
            return
        }
        
        factory.catalogData(
            pageNumber: pageToDisplay,
            categoryId: categoryIdToDispay)
        { [weak self] response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    self?.goods = value
                    self?.tableView.reloadData()
                case let .failure(error):
                    assertionFailure("Error getting products list from server: \(error.localizedDescription)")
                
                    // Repeat data request after timeout:
                    let timeout = DispatchTime(uptimeNanoseconds: 3_000_000_000)
                    DispatchQueue.main.asyncAfter(deadline: timeout, execute: {
                        self?.getGoodsFromServer()
                    })
                    
                }
            }
        }
    }
    
    // MARK: - Buttons' actions
    
    @IBAction func accountButtonPressed(_ sender: Any) {
        
        guard let accountMenu = prepareMenu() else {
            assertionFailure("Can't instantiate account menu")
            return
        }
        
        self.present(
            accountMenu,
            animated: true,
            completion: nil)
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
            assertionFailure("Can't cast destination controller as? UserWrapper & RequestFactoryProvider")
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
        
    }
    
    @IBAction func unwindFromMerchViewController(withSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromBasketToMain(withSegue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Helper functions
    
    func prepareMenu() -> UIAlertController? {
        
        guard let factory = self.requestFactory else {
            assertionFailure("Factory is nil")
            return nil
        }
        
        guard let user = self.user else {
            assertionFailure("User is nil")
            return nil
        }
        
        let menu = UIAlertController(
            title: "Учетная запись",
            message: nil,
            preferredStyle: .actionSheet)
        
        let changeBioAction = UIAlertAction(
            title: "Изменить данные",
            style: .default,
            handler: { [weak self] (_) in
                DispatchQueue.main.async {
                    self?.performSegue(
                        withIdentifier: Segues.ChangeUserDataSegue.rawValue,
                        sender: nil)
                }
            }
            
        )
        menu.addAction(changeBioAction)
        
        let logoutAction = UIAlertAction(
            title: "Выйти",
            style: .destructive,
            handler: { [weak self] (_) in
                let logoutFactory = factory.makeLogoutRequestFactory()
                logoutFactory.logout(
                    userId: user.id,
                    completionHandler: { [weak self] (response) in
                        DispatchQueue.main.async {
                            switch response.result {
                            case .success(_):
                                self?.track(AnalyticsEvent.someMethod(name: "logout", some: "Success"))
                                self?.performSegue(
                                    withIdentifier: Segues.UnwindAfterLogoutSegue.rawValue,
                                    sender: nil)
                            case .failure(let error):
                                self?.track(AnalyticsEvent.someMethod(name: "logout", some: "Error \(error.localizedDescription)"))
                            }
                        }
                })
        })
        menu.addAction(logoutAction)
        
        let closeAction = UIAlertAction(
            title: "Закрыть",
            style: .cancel,
            handler: nil)
        menu.addAction(closeAction)
        
        return menu
    }
    

}

// MARK: - Protocol compliance

extension MainViewController: RequestFactoryProvider {
    
    func setRequestFactory(_ factory: RequestFactory) {
        
        self.requestFactory = factory
    }
    
}

extension MainViewController: UserWrapper {
    
    func setUser(_ user: User) {
        self.user = user
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.goodsTableViewCellIdentifier.rawValue) as! GoodsTableViewCell
        cell.nameLabel.text = goods[indexPath.row].productName
        cell.priceLabel.text = "\(goods[indexPath.row].price) руб."
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Так как в API нет данных
        self.performSegue(
            withIdentifier: Segues.MerchOfTheDaySegue.rawValue,
            sender: nil)
    }
    
}
