//
//  PersonModel.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 23.04.2022.
//


/// Person model
struct Person: Decodable {
    let id: String
    let name: String
    let height: Float
    let biography: String
//    let temperame: Temperament
//    let educationPeriod: EducationPeriod
    
    private enum CodingKeys: String, CodingKey {
        case id, name, height, biography
        }
}

enum Temperament: String, Decodable {
    case melancholic, phlegmatic, sanguine, choleric
}

struct EducationPeriod: Decodable {
    let start: String
    let end: String
}
