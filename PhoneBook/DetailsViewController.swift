//
//  DetailsViewController.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 22.04.2022.
//

import UIKit

class DetailsViewController: UIViewController {

   
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var educationYears: UILabel!
    @IBOutlet weak var temperament: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var biography: UILabel!
    
    private let person: Person
    
//    init(person: Person){
//        self.person = person
//        super.init(nibName: nil, bundle: nil)
//    }

    init?(person: Person, coder: NSCoder) {
        self.person = person
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields(person: person)
    }
    
    private func setupFields(person: Person) {
        name.text = person.name
        educationYears.text = person.educationPeriod.start + " - " + person.educationPeriod.end
        temperament.text = person.temperament.rawValue
        phone.text = person.phone
        biography.text = person.biography
    }
}
