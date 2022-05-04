import UIKit

/// Custom alert
class CustomAlert {
    private var isShowing: SafeBool = SafeBool()
    
    func showAlert(with text: String = "нет подключения к сети", on viewController: UIViewController){
       
        guard let targetView = viewController.view, !isShowing.read() else {
            return
        }
        isShowing.write(value: true)
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
