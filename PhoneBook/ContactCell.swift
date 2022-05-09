import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    
    static let cellId = "contactCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
            return UINib(nibName: "ContactCell", bundle: nil)
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(person: Person) {
        nameLabel.text = person.name
        phoneLabel.text = person.$phone
        phoneLabel.textColor = Constants.mainGrayColor
        temperamentLabel.text = person.temperament.description
        temperamentLabel.textColor = Constants.mainGrayColor
    }
}
