import UIKit

final class Constants {
    static let json1 = "generated-01.json"
    static let json2 = "generated-02.json"
    static let json3 = "generated-03.json"
    
    static let urls = ["generated-01.json", "generated-02.json", "generated-03.json"]
    static let baseURL = "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/"
    
    /// Key to store data actual state
    static let lastDownload = "lastDownload"
    static let launchTime = "luanchTime"
    
    static let mainGrayColor = UIColor.systemGray2
    
    static let tableName = "personDB"
    static let dbName = "personDb"
}

extension Constants {
    
    /// Get array of url string
    /// - Returns: Array of  url strings to fetch data
    static func getUrls() -> [String] {
        Constants.urls.map { Constants.baseURL + $0}
    }
}
