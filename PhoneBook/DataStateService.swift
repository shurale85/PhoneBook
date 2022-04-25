//
//  IDataState.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 25.04.2022.
//

import Foundation

/// Check if data is actual or need to be updated
protocol IDataStateService {
    func isActual() -> Bool
    
    func setDownloadDate(date: Date)
}

extension IDataStateService {
    func setDownloadDate(date: Date = Date()){
        UserDefaults.standard.set(Date(), forKey: Constants.dataKeyName)
    }
}

final class DataStateService: IDataStateService {
    func isActual() -> Bool {
        let lastDonwloadTime = UserDefaults.standard.object(forKey: Constants.dataKeyName) as? Date
        guard let lastDonwloadTime = lastDonwloadTime else {
            return false
        }
        
        return Int(lastDonwloadTime.timeIntervalSinceNow) < 60
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
