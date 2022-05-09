import Foundation
/// Check if data is actual or need to be updated
protocol IDataStateService {
    func isActual() -> Bool
    
    func setDownloadDate(date: Date)
}

extension IDataStateService {
    func setDownloadDate(date: Date = Date()){
        UserDefaults.standard.set(Date(), forKey: Constants.lastDownload)
    }
}
