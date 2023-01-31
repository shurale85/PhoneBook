import Foundation
import UIKit

/// Stab class for testing
final class NetworkStab: INetworkManager {
    // some stab iplementation would go here
}

final class NetworkManager: INetworkManager{
    func fetchData(url: String, completion: @escaping (Result<[Person], CustomError>) -> Void){
        let request = buildRequest(url: url)
                guard let request = request else {
                    completion(.failure(.invalidUrl))
                    return
                }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let data = data, error == nil else {
                        completion(.failure(CustomError.invalidData))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(Array<Person>.self, from: data)
                        completion(.success(result))
                        return
                    }
                    catch {
                        completion(.failure(.errMsg(msg: error.localizedDescription)))
                        return
                    }
                }
                .resume()
    }
    
    /// Build URLRequest
    /// - Parameters:
    ///   - url: URL to call
    ///   - method: HTTP method
    ///   - contentType: type of HEADER Content-Type
    /// - Returns: URLRequest
    fileprivate func buildRequest(url: String, method: String = "GET", contentType: String = "application/json") -> URLRequest? {
        
        guard let url = URL(string: url) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        return request
    }
}
