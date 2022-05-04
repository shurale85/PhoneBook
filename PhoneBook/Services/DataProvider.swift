import Foundation

class DataProvider: IDataProvider {
    private let urls = Constants.getUrls()
    private let networkManager: INetworkManager
    private let dataStateService: IDataStateService
    private let databaseManager: IDatabaseManager
    
    init(networkManager: INetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.dataStateService = DataStateService()
        databaseManager = DatabaseManager()
    }
    
    func getData(completion: @escaping (Result<[Person], CustomError>) -> Void) {
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
    
    func updateData(completion: @escaping (Result<[Person], CustomError>) -> Void) {
        getPersonsDataFromApi(completion: completion)
    }
    
    func getPersonsDataFromApi(completion: @escaping (Result<[Person], CustomError>) -> Void) {
        let personsData: SafeArray<Person> = .init()
        let group = DispatchGroup()
        var isSuccess = false

        for url in urls {
            group.enter()
            networkManager.fetchData(url: url){ result in
                switch result {
                case .success(let data):
                    personsData.append(data)
                    completion(.success(data))
                    isSuccess = true
                case .failure(let err):
                    completion(.failure(err))
                }
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .userInitiated)){ [weak self] in
            if isSuccess {
                self?.databaseManager.insertData(data: personsData.valueArray.dropLast(personsData.valueArray.count - 10))
                self?.dataStateService.setDownloadDate()
            }
        }    
    }
    
    func getPesonsDataFromDB(completion: (Result<[Person], CustomError>) -> Void)  {
        print("getting fron db")
        do{
            let personsData = try databaseManager.fetchData()
            completion(.success(personsData.dropLast(personsData.count - 5)))
        }
        catch {
            completion(.failure(.errMsg(msg: error.localizedDescription)))
        }
    } 
}
