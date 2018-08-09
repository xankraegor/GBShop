import UIKit

extension UIViewController {
    
     func presentSimpleAlert(
        title: String,
        message: String,
        buttonCaption: String,
        handler: ((UIAlertAction) -> Void)? = nil) {
        
        let action = UIAlertAction(
            title: buttonCaption,
            style: .default,
            handler: handler)
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(action)
        
        self.present(
            alert,
            animated: true,
            completion: nil)
    }
    
}
