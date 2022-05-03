import UIKit

class ViewController: UIViewController {
    
    private let cellId = "cell"
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let dataProvider: IDataProvider
    private var alertController: CustomAlert?
    
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
            switch result {
            case .success(let persons):
                self.personsOrigin.append(contentsOf: persons)
                DispatchQueue.main.async {
                    //self.contactsTableView.reloadData()
                    self.showAlert()
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

class SafeBool {
    private var isTrue: Bool = false
    private let queue = DispatchQueue(label: "safe bool", attributes: .concurrent)
    
    public func write(value: Bool) {
        queue.async(flags: .barrier) {
            self.isTrue = value
        }
    }
    
    public func read() -> Bool {
        var result: Bool = false
        queue.sync {
            result = isTrue
        }
        return result
    }
}

class CustomAlert {
    private var isShowing: SafeBool = SafeBool()
    
    func showAlert(on viewController: UIViewController){
       
        guard let targetView = viewController.view, !isShowing.read() else {
            return
        }
        isShowing.write(value: true)
        print("alarm")
        let alertView = UIView()
        alertView.backgroundColor = .black
        alertView.alpha = 0.5
        alertView.layer.masksToBounds = true
        alertView.layer.cornerRadius = 10
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        let msgView = UILabel(frame: CGRect(x: 0,
                                            y: 0,
                                            width: alertView.frame.size.width,
                                            height: 30))
        msgView.text = "нет подключения к сети"
        msgView.textAlignment = .left
        msgView.textColor = .white
        msgView.numberOfLines = 1
        msgView.translatesAutoresizingMaskIntoConstraints = false
        msgView.font = msgView.font.withSize(20)
        
        // setting frame does mean nothing since project use Autolayout. Constrains has to be used
        //        alertView.frame = CGRect(x: 0,
        //                                 y: 0,
        //                                 width: targetView.frame.size.width - 20,
        //                                 height: 70)
        alertView.center = targetView.center
        alertView.addSubview(msgView)
        targetView.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            msgView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            msgView.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
            alertView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: 20),
            targetView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 20),
            alertView.heightAnchor.constraint(equalToConstant: 60),
            targetView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 20)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isShowing.write(value: false)
            msgView.removeFromSuperview()
            alertView.removeFromSuperview()
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

