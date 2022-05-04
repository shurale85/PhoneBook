/// Provide with data from API or local storage
protocol IDataProvider {
    
    func getData(completion: @escaping (Result<[Person], CustomError>) -> Void)
    
    func updateData(completion: @escaping (Result<[Person], CustomError>) -> Void)
}
