import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @Injected<IDataProvider>
    var dataProvider: IDataProvider?
    private var alertController: CustomAlert?
    private let cellId = "cell"
    
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
        guard let dataProvider = dataProvider else {
            return
        }
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
            switch result {
            case .success(let persons):
                self.personsOrigin.append(contentsOf: persons)
                DispatchQueue.main.async {
                    self.contactsTableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
        
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        searchBar.delegate = self
        contactsTableView.register(ContactCell.nib(), forCellReuseIdentifier: ContactCell.cellId)
    }
    
    @objc private func didSwipe() {
        guard let dataProvider = dataProvider else {
            return
        }
        
        dataProvider.updateData{
            [weak self] result in
            
            guard let self = self else {
                return
            }
            switch result {
            case .success(let persons):
                self.personsOrigin.append(contentsOf: persons)
                DispatchQueue.main.async {
                    self.contactsTableView.reloadData()
                }
            case .failure(_):
                self.showAlert()
            }
        }
    }
    
    private func showAlert(with message: String = "нет подключения к сети"){
        guard alertController != nil else {
            self.alertController = CustomAlert()
            return
        }
        alertController!.showAlert(on: self)
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
