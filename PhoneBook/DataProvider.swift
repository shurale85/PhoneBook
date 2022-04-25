//
//  DataProvider.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 25.04.2022.
//

import Foundation

/// Provide with data from API or local storage
protocol IDataProvider {
    
    func getData(completion: @escaping ([Person]) -> Void)
    
    func updateData(completion: @escaping ([Person]) -> Void)
    
}

class DataProvider: IDataProvider {
    private let urls = Constants.getUrls()
    private let networkManager: INetworkManager
    private let dataStateService: IDataStateService
   // private var personsData: [Person] = []
    
    init(networkManager: INetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.dataStateService = DataStateStub()
    }
    
    func getData(completion: @escaping ([Person]) -> Void) {
        if  dataStateService.isActual() {
            getPesonsDataFromDB()
        } else {
            getPersonsDataFromApi(completion: completion)
        }
    }
    
    func updateData(completion: @escaping ([Person]) -> Void) {
        getPersonsDataFromApi(completion: completion)
    }
    
    func getPersonsDataFromApi(completion: @escaping ([Person]) -> Void) {
        var personsData: [Person] = []
        let group = DispatchGroup()
        urls.forEach { url in
            group.enter()
            networkManager.fetchData(url: url){result in
                switch result {
                case .success(let data):
                    personsData.append(contentsOf: data)
                case .failure(let err):
                    print(err)
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main){
            print("person data count: \(personsData.count)")
            completion(personsData)
        }
    }
    
    func getPesonsDataFromDB() -> [Person] {
        return Person.getStubData()
    } 
}
