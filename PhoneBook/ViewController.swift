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
    
    
    let data = ["Shahban", "Ramadan", "Shawal", "Rajjab", "DEcember", "April"]
    var filteredData: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        searchBar.delegate = self
        filteredData = data
        contactsTableView.register(ContactCell.nib(), forCellReuseIdentifier: ContactCell.cellId)
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.cellId, for: indexPath) as! ContactCell
        cell.setupCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        self.show(detailVC, sender: nil)
    }
    

}

// MARK: searchbar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText.isEmpty {
            filteredData = data
        } else {
        
        for i in data {
            if i.lowercased().contains(searchText.lowercased()) {
                filteredData.append(i)
            }
        }
        }
        self.contactsTableView.reloadData()
    }
}
