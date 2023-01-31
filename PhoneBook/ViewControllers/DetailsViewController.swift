import UIKit

class DetailsViewController: UIViewController {    
    private lazy var detailView: DetailsView = {
        DetailsView(frame: view.frame)
    }()
    
    private let person: Person

    init?(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        view.backgroundColor = .clear
        detailView.setup(person: person)
    }
}
