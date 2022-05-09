import Foundation

final class DataStateService: IDataStateService {
    func isActual() -> Bool {
        let lastDonwloadTime = UserDefaults.standard.object(forKey: Constants.lastDownload) as? Date
        guard let lastDonwloadTime = lastDonwloadTime else {
            return false
        }
        let launchTime = UserDefaults.standard.object(forKey: Constants.launchTime) as? Date
        guard let launchTime = launchTime else {
            return false
        }
        
        print(lastDonwloadTime.timeIntervalSinceNow)
        return lastDonwloadTime.distance(to: launchTime) < 60
    }
}

final class DataStateStub: IDataStateService {
    
    private let isDateActual: Bool
    
    init(returnWith state: Bool = false){
        self.isDateActual = state
    }
    
    func isActual() -> Bool {
        isDateActual
    }
}
