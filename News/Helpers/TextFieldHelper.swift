import UIKit

class TextFieldAnimate {
    
    static let shared = TextFieldAnimate()
    
    private init() {}
    
    private var bottomLine: CALayer?
    
    func animateField(for textField: UITextField, of views: [UIView]){
        for view in views {
            if textField.isDescendant(of: view){
                let bottomLine = CALayer()
                bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1.5, width: textField.frame.width, height: 1.5)
                bottomLine.backgroundColor = Colors.buttonColor.cgColor
                textField.borderStyle = UITextField.BorderStyle.none
                textField.layer.addSublayer(bottomLine)
                self.bottomLine = bottomLine
                
                UIView.animate(withDuration: 0.7) {
                    view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
            }
        }
    }
    
    func animateToNormal(of views: [UIView]){
        for view in views{
            self.bottomLine?.backgroundColor = .none
            UIView.animate(withDuration: 0.7) {
                view.transform = .identity
            }
        }
    }
}
