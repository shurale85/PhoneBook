//
//  MainViewController.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 26.01.2023.
//

import UIKit

class MainViewController: UITableViewController, UISearchResultsUpdating {
    // MARK: - Outlets
    private lazy var refreshUpdateControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.addTarget(self, action: #selector(self.didSwipe), for: .valueChanged)
        return refreshControl
    }()

    @Injected<IDataProvider>
    var dataProvider: IDataProvider?
    private var alertController: CustomAlert?
    private let cellId = "cell"
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
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
        configureSelf()
        getData()
    }
    
    private func configureSelf() {
        title = "Contacts"
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        tableView.refreshControl = refreshUpdateControl
        tableView.register(ContactCellView.self, forCellReuseIdentifier: ContactCellView.cellId)
    }
    
    private func getData() {
        guard let dataProvider = dataProvider else {
            return
        }
        dataProvider.getData{ [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let persons):
                self.personsOrigin.append(contentsOf: persons)
                DispatchQueue.main.async {
                    self.refreshUpdateControl.endRefreshing()
                    self.tableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.refreshUpdateControl.endRefreshing()
                    self.showAlert()
                }
            }
        }
    }
    
    @objc private func didSwipe() {
        getData()
    }
    
    private func showAlert(with message: String = "нет подключения к сети"){
        guard alertController != nil else {
            self.alertController = CustomAlert()
            return
        }
        alertController!.showAlert(on: self)
    }

    // MARK: TableView delegagtes and datasources
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCellView.cellId, for: indexPath) as! ContactCellView
        cell.setupCell(person: persons[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = DetailsViewController(person: self.persons[indexPath.row]) else { return }
        show(detailVC, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: searchbar
extension MainViewController: UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController){ //(_ searchBar: UISearchBar, textDidChange searchText: String)
        
        guard let searchText = searchController.searchBar.text else { return }
        
        persons = []
        
        if searchText.isEmpty {
            persons = personsOrigin
        } else {
            persons = personsOrigin.filter { $0.name.lowercased().contains(searchText.lowercased())}
            if persons.isEmpty {
                persons = personsOrigin.filter { $0.phone.digits.contains(searchText)}
            }
        }
        persons = persons.sorted()
        self.tableView.reloadData()
    }
}
