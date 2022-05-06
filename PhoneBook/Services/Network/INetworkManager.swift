import Foundation

protocol INetworkManager {
    /// Fetching person data from url specified
    /// - Parameters:
    ///   - url: url to fetch data
    ///   - completion: action to perform since data is fethced
    func fetchData(url: String, completion: @escaping(Result<[Person], CustomError>) -> Void)
}

extension INetworkManager {
    func fetchData(url: String, completion: @escaping(Result<[Person], CustomError>) -> Void){
        completion(.success(Person.getStubData()))
    }
}
