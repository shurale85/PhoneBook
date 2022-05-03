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
        educationYears.text = person.educationPeriod.description
        educationYears.textColor = Constants.mainGrayColor
        temperament.text = person.temperament.description
        temperament.textColor = Constants.mainGrayColor
        phone.setText(person.phone, prependedBySymbolNameed: "phone.fill")
        biography.text = person.biography
        biography.textColor = Constants.mainGrayColor
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(phoneTapped))
        phone.isUserInteractionEnabled = true
        phone.addGestureRecognizer(phoneTap)
    }
    
    @objc func phoneTapped(sender: UIGestureRecognizer){
        guard let phoneNumber = phone.text?.phoneNumberSymbols, let url = URL(string: "tel://\(phoneNumber)") else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            print("calling")
        }
    }
}
