import Foundation
import Crashlytics

enum AnalyticsEvent {
    
    enum LoginParams {
        static let methodDefault = "default"
    }
    
    enum SomeMethodParams {
        static let nameDefault = "default"
        static let nameAssertionFailure = "assertionFailure"
    }
    
    case login(method: String, success: Bool)
    case someMethod(name: String, some: String)
}

protocol TrackableMixin {
    
    func track(_ event: AnalyticsEvent)
}

extension TrackableMixin {
    
    func track(_ event: AnalyticsEvent) {
        switch event {
        case let .login(method, success):
            let success = NSNumber(value: success)
            Answers.logLogin(withMethod: method, success: success, customAttributes: nil)
        case let .someMethod(name, some):
            Answers.logCustomEvent(withName: name, customAttributes: ["parameter": some])
        }
    }
    
}

func assertionFailure​(_ message: String) {

    #if DEBUG
    Swift.assertionFailure(message)
    #else
    track​(​AnalyticsEvent​.​someMethod(
        Answers​.​logCustomEvent(withName: "AssertionFailure", customAttributes: ["message": ​message]))
    )
    #endif
}
