import UIKit

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
