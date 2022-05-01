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
    private let databaseManager: IDatabaseManager
   // private var personsData: [Person] = []
    
    init(networkManager: INetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.dataStateService = DataStateService()
        databaseManager = DatabaseManager()
    }
    
    func getData(completion: @escaping ([Person]) -> Void) {
        do {
            guard try databaseManager.ifTableExists() else {
                getPersonsDataFromApi(completion: completion)
                return
            }
        } catch {
            debugPrint(error)
        }
        
        if dataStateService.isActual() {
            getPesonsDataFromDB(completion: completion)
        } else {
            getPersonsDataFromApi(completion: completion)
        }
    }
    
    func updateData(completion: @escaping ([Person]) -> Void) {
        getPersonsDataFromApi(completion: completion)
    }
    
    func getPersonsDataFromApi(completion: @escaping ([Person]) -> Void) {
        print("getting from api")
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
                completion(personsData)
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .userInitiated)){ [weak self] in
            print("person data count: \(personsData.count)")
            self?.databaseManager.insertData(data: personsData.dropLast(personsData.count - 10))
            self?.dataStateService.setDownloadDate()
//            DispatchQueue.global(qos: .userInitiated).async{
//                self.databaseManager.insertData(data: personsData.dropLast(personsData.count - 10))
//            }
        }    
    }
    
    func getPesonsDataFromDB(completion: ([Person]) -> Void)  {
        print("getting fron db")
        do{
            let personsData = try databaseManager.fetchData()
            completion(personsData.dropLast(personsData.count - 5))
        }
        catch{
            debugPrint(error)
        }
    } 
}
