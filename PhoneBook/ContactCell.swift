//
//  ContactCell.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 21.04.2022.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    
    static let cellId = "contactCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
            return UINib(nibName: "ContactCell", bundle: nil)
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        self.nameLabel?.text = "name"
        self.phoneLabel?.text = "phone"
        self.temperamentLabel?.text = "test temp"
    }
    
}
