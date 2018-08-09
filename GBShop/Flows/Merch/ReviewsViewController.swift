import UIKit

struct Review {
    
    var userName: String
    var text: String
    
    init(name: String, text: String) {
        self.userName = name
        self.text = text
    }
}

class ReviewsViewController: UIViewController, TrackableMixin {
    
    var user: User?
    var requestFactory: RequestFactory?
    
    var reviews: [Review] {
        // Заглушка вместо данных, которые должен возвращать сервер:
        return [
        Review(name: "Лолкек", text: "Супер! афтар жжот пешиисчо упчк"),
        Review(name: "Аноним", text: "Не тянет пасьянс косынку, пришлось купить электростанцию, тк жрет как черная дыра, не влазиет в корпус моего телефона, пришлось заливать корпус жидким азотом: нагревается до состояния плазмы, слишком мало памяти"),
        Review(name: "Филипп", text: "Самая мощная на сегодняшний день, CUDA. Переплата 1000$ за объединение 2х ядер. Памяти по факту 6 гб."),
        Review(name: "Саша", text: "Высокая битность и большой обьем видеопамяти. Очень завышена цена за бренд"),
        Review(name: "Аноним", text: "Максимум возможностей, аналогов этого чуда нет!"),
        ]
    }
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self

        reviewsTableView.register(
            UINib(nibName: "ReviewTableViewCell", bundle: nil),
            forCellReuseIdentifier: Cells.reviewCellIdentifier.rawValue)
    }
    
    @IBAction func addReviewButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Добавление отзыва", message: "Пожалуйста, введите свой отзыв", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let alertActionCancel = UIAlertAction(
            title: "Отмена",
            style: .default,
            handler: nil)
        alert.addAction(alertActionCancel)
        
        let alertActionSend = UIAlertAction(
            title: "Отправить",
            style: .default) { [weak self] (_) in
                let reviewText = alert.textFields?.first?.text ?? ""
                
                if reviewText.count > 0 {
                    self?.sendReview(reviewText)
                } else {
                    return
                }
                
        }
        alert.addAction(alertActionSend)
        
        self.present(alert, animated: true, completion: nil)
    }
 
    func sendReview(_ review: String)->Void {
        
        guard let user = self.user else {
            assertionFailure("User is nil")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let factory = self.requestFactory?.makeAddReviewRequestFactory()
            factory?.addReview(
                userId: user.id,
                review: review) { [weak self] (response) in
                    DispatchQueue.main.async {
                        switch response.result {
                        case let .success(value):
                            self?.track(AnalyticsEvent.someMethod(
                                name: "addReview",
                                some: "Review \(value.result) added by user with id \(user.id)"))
                            self?.presentSimpleAlert(
                                title: "Добавление отзыва",
                                message: value.userMessage,
                                buttonCaption: "Закрыть")
                            return
                        case let .failure(error):
                            self?.presentSimpleAlert(
                                title: "Ошибка добавления отзыва",
                                message: error.localizedDescription,
                                buttonCaption: "Закрыть")
                            return
                        }
                    }
            }
        }
    }
}


// MARK: - Protocol compliance

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.reviewCellIdentifier.rawValue) as! ReviewTableViewCell
        cell.userNameLabel.text = reviews[indexPath.row].userName
        cell.reviewTextLabel.text = reviews[indexPath.row].text
        return cell
    }
    
}

extension ReviewsViewController: RequestFactoryProvider {
    
    func setRequestFactory(_ factory: RequestFactory) {
        self.requestFactory = factory
    }
}

extension ReviewsViewController: UserWrapper {
    
    func setUser(_ user: User) {
        self.user = user
    }
    
}
