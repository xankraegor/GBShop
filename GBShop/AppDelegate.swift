import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate:
UIResponder,
UIApplicationDelegate {
    
    var window: UIWindow?
    
    let requestFactory = RequestFactory(config: Config())

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        if let controller = window?.rootViewController as? RequestFactoryProvider {
            controller.setRequestFactory(requestFactory)
        }
        
        return true
    }

}
