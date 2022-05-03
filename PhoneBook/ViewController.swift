//
//  ViewController.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 20.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let cellId = "cell"
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //    private let networkManager: INetworkManager
    
    private let dataProvider: IDataProvider
    
    required init?(coder: NSCoder) {
        dataProvider = DataProvider()
        super.init(coder: coder)
    }

    var personsOrigin: [Person] = []
    {
        didSet {
            persons = personsOrigin.sorted()
        }
    }
    var persons: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipeGestureRecognizerDown.direction = .down
        view.addGestureRecognizer(swipeGestureRecognizerDown)
        
        dataProvider.getData{ [weak self] result in
            
            guard let self = self else {
                return
            }
            self.personsOrigin.append(contentsOf: result)
            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }
            
        }
        
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        searchBar.delegate = self
        contactsTableView.register(ContactCell.nib(), forCellReuseIdentifier: ContactCell.cellId)
    }
    
    @objc private func didSwipe() {
        dataProvider.updateData{
            [weak self] result in
            
            guard let self = self else {
                return
            }
            self.personsOrigin.append(contentsOf: result)
            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }
        }
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.cellId, for: indexPath) as! ContactCell
        cell.setupCell(person: persons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(identifier: "DetailsViewController",  creator: {[unowned self] coder in DetailsViewController(person: self.persons[indexPath.row], coder: coder)})
        else {
            fatalError("Failed to create DetailsViewController")
        }
        //   let detailVC = DetailsViewController(person: persons[indexPath.row])
        // detailVC(person: persons[indexPath.row])
        // navigationController?.show(detailsVC, sender: nil)
        //detailVC.set(person: persons[indexPath.row])
        show(detailVC, sender: nil)
    }
    
    
}

// MARK: searchbar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        persons = []
        
        if searchText.isEmpty {
            persons = personsOrigin
        } else {
            
            for person in personsOrigin {
                if person.name.lowercased().contains(searchText.lowercased()) {
                    persons.append(person)
                } else if person.phone.digits.contains(searchText) {
                    persons.append(person)
                }
            }
        }
        persons = persons.sorted()
        self.contactsTableView.reloadData()
    }
}

extension RangeReplaceableCollection where Self: StringProtocol {
    var digits: Self { filter(\.isWholeNumber)}
    
    var phoneNumberSymbols: Self {filter(\.isDigitOrPlus)}
}

extension Character {
    var isDigitOrPlus: Bool { "0"..."9" ~= self || self == "+"}
}

extension RangeReplaceableCollection where Self: StringProtocol {
    mutating func removeAllNonPhoneSymbols() {
        removeAll { !$0.isDigitOrPlus }
    }
}


extension UILabel {
    func setText(_ text: String, prependedBySymbolNameed symbolSystemName: String, font: UIFont? = nil, isSymbolSuffix: Bool = false) {
        if #available(iOS 13.0, *) {
            if let font = font { self.font = font }
            let symbolConfiguration = UIImage.SymbolConfiguration(font: self.font)
            let symbolImage = UIImage(systemName: symbolSystemName, withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
            let symbolTextAttachment = NSTextAttachment()
            symbolTextAttachment.image = symbolImage
            let attributedText = NSMutableAttributedString()
            if isSymbolSuffix {
                attributedText.append(NSAttributedString(string: text + " "))
                attributedText.append(NSAttributedString(attachment: symbolTextAttachment))
            } else {
                attributedText.append(NSAttributedString(attachment: symbolTextAttachment))
                attributedText.append(NSAttributedString(string: " " + text))
            }
            
            self.attributedText = attributedText
        } else {
            self.text = text
        }
    }
}

