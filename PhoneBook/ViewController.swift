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
        //       networkManager = NetworkStab()
        dataProvider = DataProvider()
        super.init(coder: coder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    
    let data = ["Shahban", "Ramadan", "Shawal", "Rajjab", "DEcember", "April"]
    var filteredData: [String]!
    
    var persons: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipeGestureRecognizerDown.direction = .down
        view.addGestureRecognizer(swipeGestureRecognizerDown)
        
        dataProvider.getData{ [weak self] result in
            
            guard let self = self else {
                return
            }
            self.persons.append(contentsOf: result)
            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }
            
        }
        
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        searchBar.delegate = self
        filteredData = data
        contactsTableView.register(ContactCell.nib(), forCellReuseIdentifier: ContactCell.cellId)
    }
    
    @objc private func didSwipe() {
        dataProvider.updateData{
            [weak self] result in
            
            guard let self = self else {
                return
            }
            self.persons.append(contentsOf: result)
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
