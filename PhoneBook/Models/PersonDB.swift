//
//  PersonDB.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 31.01.2023.
//

import Foundation
import GRDB

struct PersonDB: FetchableRecord, PersistableRecord {
    
    let id: String
    let name: String
    let height: Float
    var phone: String
    let biography: String
    let temperament: Temperament
    let educationPeriod: EducationPeriod
    
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        height = row["height"]
        phone = row["phone"]
        biography = row["biography"]
        temperament = row["temperament"]
        educationPeriod = EducationPeriod(startDate: row["educationStart"], endDate: row["educationEnd"])
    }
    
    init(personModel:Person) {
        id = personModel.id
        name = personModel.name
        height = personModel.height
        phone = personModel.phone
        biography = personModel.biography
        temperament = personModel.temperament
        educationPeriod = personModel.educationPeriod
    }
    
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
    
    func mapToEntity() -> Person {
        Person(personDb: self)
    }
}
