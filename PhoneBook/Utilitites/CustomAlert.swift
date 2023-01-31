import UIKit

/// Custom alert
class CustomAlert {
    private var isShowing: Bool = false
    
    func showAlert(with text: String = "нет подключения к сети", on viewController: UIViewController){
       
        guard let targetView = viewController.view, !isShowing else {
            return
        }
        isShowing = true
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
        msgView.text = text
        msgView.textAlignment = .left
        msgView.textColor = .white
        msgView.numberOfLines = 1
        msgView.translatesAutoresizingMaskIntoConstraints = false
        msgView.font = msgView.font.withSize(20)
        alertView.center = targetView.center
        alertView.addSubview(msgView)
        targetView.addSubview(alertView)
        
        // constraint example without snp
        NSLayoutConstraint.activate([
            msgView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            msgView.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
            alertView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: 20),
            targetView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 20),
            alertView.heightAnchor.constraint(equalToConstant: 60),
            targetView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 20)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isShowing = false
            msgView.removeFromSuperview()
            alertView.removeFromSuperview()
        }
    }
}
