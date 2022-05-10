import Foundation

class DataProvider: IDataProvider {
    private let urls = Constants.getUrls()
    
    @Injected<INetworkManager>
    var networkManager: INetworkManager?
    @Injected<IDataStateService>
    var dataStateService: IDataStateService?
    @Injected<IDatabaseManager>
    var databaseManager: IDatabaseManager?
    
    init(){
        
    }
    
    init(networkManager: INetworkManager, dataStateService: IDataStateService, dataBaseManager: IDatabaseManager) {
        self.networkManager = networkManager
        self.dataStateService = dataStateService
        self.databaseManager = dataBaseManager
    }
    
    func getData(completion: @escaping (Result<[Person], CustomError>) -> Void) {
        do {
            guard let databaseManager = databaseManager, try databaseManager.ifTableExists() else {
                getPersonsDataFromApi(completion: completion)
                return
            }
        } catch {
            debugPrint(error)
        }
        guard let dataStateService = dataStateService else {
            return
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
            networkManager?.fetchData(url: url){ result in
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
        
        group.notify(queue: .global(qos: .utility)){ [weak self] in
            if isSuccess {
                self?.databaseManager?.insertData(data: personsData.valueArray)
                self?.dataStateService?.setDownloadDate()
            }
        }    
    }
    
    func getPesonsDataFromDB(completion: (Result<[Person], CustomError>) -> Void)  {
        print("getting fron db")
        guard let databaseManager = databaseManager else {
            return
        }
        do{
            let personsData = try databaseManager.fetchData()
            completion(.success(personsData.dropLast(personsData.count - 5)))
        }
        catch {
            completion(.failure(.errMsg(msg: error.localizedDescription)))
        }
    } 
}
