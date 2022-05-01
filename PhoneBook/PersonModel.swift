//
//  PersonModel.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 23.04.2022.
//
import Foundation
import GRDB

/// Person model
struct Person: Codable, MutablePersistableRecord, TableRecord {
    let id: String
    let name: String
    let height: Float
    let phone: String
    let biography: String
    let temperament: Temperament
    let educationPeriod: EducationPeriod
    
}

extension Person: FetchableRecord {
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        height = row["height"]
        phone = row["phone"]
        biography = row["biography"]
        temperament = row["temperament"]
        educationPeriod = EducationPeriod(start: row["educationStart"], end: row["educationEnd"])
    }
}

enum Temperament: String, Codable, DatabaseValueConvertible {
    case melancholic, phlegmatic, sanguine, choleric
}

struct EducationPeriod: Codable {
    let start: String
    let end: String
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
                   educationPeriod: EducationPeriod(start: "2013-07-15T11:44:06-06:00", end: "2007-08-09T08:26:05-06:00"))
        }
    }
}
