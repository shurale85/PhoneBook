import Foundation

final class DataStateService: IDataStateService {
    func isActual() -> Bool {
        let lastDonwloadTime = UserDefaults.standard.object(forKey: Constants.dataKeyName) as? Date
        guard let lastDonwloadTime = lastDonwloadTime else {
            return false
        }
        print(lastDonwloadTime.timeIntervalSinceNow)
        return Int(lastDonwloadTime.timeIntervalSinceNow) > -60
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
