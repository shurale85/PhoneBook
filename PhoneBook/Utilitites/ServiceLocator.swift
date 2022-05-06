import Foundation

class ServiceLocator {
    static let shared = ServiceLocator()
    
    lazy var services: [String: AnyObject] = {
        return [String: AnyObject]()
    }()
    
    func addServices<K:Any, T:AnyObject>(service: T, for type: K.Type) {
        let key = String(describing: type.self)
        if services[key] == nil {
            services[key] = service
        }
    }
    
    func resolve<T: Any>(type: T.Type)->T? {
        let key = String(describing: type)
        return services[key] as? T
    }
}

extension ServiceLocator {
    func register() {
        addServices(service: NetworkManager(), for: INetworkManager.self)
        addServices(service: DataProvider(), for: IDataProvider.self)
        addServices(service: DataStateService(), for: IDataStateService.self)
    }
}
