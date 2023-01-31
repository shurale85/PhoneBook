import UIKit

protocol IDatabaseManager {
    func insertData(data: [PersonDB])
    
    static func setup(for application: UIApplication) throws
    
    func ifTableExists() throws -> Bool
    
    func fetchData() throws -> [PersonDB]
}
