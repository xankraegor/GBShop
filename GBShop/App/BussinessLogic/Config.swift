import Foundation

class Config {
    
    let baseUrl: URL
    
    init() {
        baseUrl = URL(
            string: "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")!
    }
    
    init(withBaseUrl: URL) {
        baseUrl = withBaseUrl
    }

}
