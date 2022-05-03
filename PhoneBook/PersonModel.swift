//
//  PersonModel.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 23.04.2022.
//
import Foundation
import GRDB

/// Person model
struct Person: Codable, Comparable {
    let id: String
    let name: String
    let height: Float
    let phone: String
    let biography: String
    let temperament: Temperament
    let educationPeriod: EducationPeriod

    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.name == rhs.name
    }
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
}

extension Person: FetchableRecord, MutablePersistableRecord {
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        height = row["height"]
        phone = row["phone"]
        biography = row["biography"]
        temperament = row["temperament"]
        educationPeriod = EducationPeriod(startDate: row["educationStart"], endDate: row["educationEnd"])
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
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: start)
        let startDateString = components.getRuDateRepresentaion()
        components = calendar.dateComponents([.year, .month, .day], from: end)
        let endDateString = components.getRuDateRepresentaion()
        return startDateString + " - " + endDateString
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

extension DateComponents {
    func getRuDateRepresentaion() -> String {
        guard let day = self.day, let month = self.month, let year = self.year else {
            return ""
        }
        return "\(day).\(month).\(year)"
    }
}

extension Person: PersistableRecord {
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["name"] = name
        container["phone"] = phone
        container["height"] = height
        container["biography"] = biography
        container["temperament"] = temperament
        container["educationStart"] = educationPeriod.start
        container["educationEnd"] = educationPeriod.end
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
