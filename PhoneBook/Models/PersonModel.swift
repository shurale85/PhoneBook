import Foundation
import GRDB

/// Person model
struct Person: Codable, Comparable {
    let id: String
    let name: String
    let height: Float
    @PhoneNumberSanitizer
    var phone: String
    let biography: String
    let temperament: Temperament
    let educationPeriod: EducationPeriod

    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.name == rhs.name
    }
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
    
    func mapToDbEntity() -> PersonDB{
        PersonDB(personModel: self)
    }
    
    init(personDb: PersonDB) {
        id = personDb.id
        name = personDb.name
        height = personDb.height
        phone = personDb.phone
        biography = personDb.biography
        temperament = personDb.temperament
        educationPeriod = personDb.educationPeriod
    }
    
    init(id: String, name: String, height: Float, phone: String, biography: String, temperament: Temperament, educationPeriod: EducationPeriod) {
        self.id = id
        self.name = name
        self.height = height
        self.phone = phone
        self.biography = biography
        self.temperament = temperament
        self.educationPeriod = educationPeriod
    }
}

enum Temperament: String, Codable, DatabaseValueConvertible, CustomStringConvertible {
    var description: String {
        switch self {
        case .melancholic:
            return "Melancholic"
        case .phlegmatic:
            return "Phlegmatic"
        case .sanguine:
            return "Sanguine"
        case .choleric:
            return "Choleric"
        }
    }
    
    case melancholic
    case phlegmatic
    case sanguine
    case choleric
}

struct EducationPeriod: Codable, CustomStringConvertible {
    let start: Date?
    let end: Date?

    var description: String {
        guard let start = start, let end = end else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        if !dateFormatter.string(from: start).isEmpty && !dateFormatter.string(from: end).isEmpty {
            return dateFormatter.string(from: start) + " - " + dateFormatter.string(from: end)
        }
        return ""
    }
    
    init(startDate: Date, endDate: Date) {
        start = startDate
        end = endDate
    }
    
    init(from decoder: Decoder) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var dateString = try container.decode(String.self, forKey: .start)
        var date = dateFormatter.date(from: dateString)
        start = date ?? nil
        dateString = try container.decode(String.self, forKey: .end)
        date = dateFormatter.date(from: dateString)
        end = date ?? nil
    }
    
    enum CodingKeys: String, CodingKey {
        case start, end
    }
}

extension Person {
    static func getStubData() -> [Person]{
        (1...30).map {
            Person(id: String($0),
                   name: "Summer Greer \($0)",
                   height: 201.9,
                   phone: "+7 (903) 425-3032",
                   biography: "Non culpa occaecat occaecat sit occaecat aliquip esse Lorem voluptate commodo veniam ipsum velit. Mollit sunt quis reprehenderit pariatur Lorem consequat magna. Nulla nostrud ad deserunt tempor proident enim exercitation sit ullamco aliquip.",
                   temperament: Temperament.choleric,
                   educationPeriod: EducationPeriod(startDate: Date.distantPast, endDate: Date.distantFuture))
        }
    }
}
