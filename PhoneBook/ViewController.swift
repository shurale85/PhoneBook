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
    
    private let networkManager: INetworkManager
    
    required init?(coder: NSCoder) {
        networkManager = NetworkStab()
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    let data = ["Shahban", "Ramadan", "Shawal", "Rajjab", "DEcember", "April"]
    var filteredData: [String]!
    
    var persons: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let n = NetworkManager()
        let url = Constants.baseURL + Constants.json1
        n.fetchData(url: url){ result in
            switch result {
            case .success(let persons):
                self.persons.append(contentsOf: persons)
                DispatchQueue.main.async {
                    self.contactsTableView.reloadData()
                }
                
            case .failure(let err):
                print(err)
            }
        }
        
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        searchBar.delegate = self
        filteredData = data
        contactsTableView.register(ContactCell.nib(), forCellReuseIdentifier: ContactCell.cellId)
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
