//
//  PersonModel.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 23.04.2022.
//
import Foundation

/// Person model
struct Person: Decodable {
    let id: String
    let name: String
    let height: Float
    let phone: String
    let biography: String
    let temperament: Temperament
    let educationPeriod: EducationPeriod
}

enum Temperament: String, Decodable {
    case melancholic, phlegmatic, sanguine, choleric
}

struct EducationPeriod: Decodable {
    let start: String
    let end: String
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
