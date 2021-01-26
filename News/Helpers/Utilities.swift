import UIKit

class Utilities {
    
    static let shared = Utilities()
    
    private init() {}
    
    func defaultButtonStyle(_ button: UIButton){
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    func styleAuthButton(_ button: UIButton){
        defaultButtonStyle(button)
        button.layer.borderColor = Colors.buttonColor.cgColor
        button.backgroundColor = Colors.buttonColor
    }
    
    func styleMainVCButton(_ button: UIButton, tag: Int){
        defaultButtonStyle(button)
        button.layer.borderColor = UIColor.white.cgColor
        button.tag = tag
        button.alpha = 0
    }
    
    func styleInputView(_ view: UIView){
        view.layer.cornerRadius = view.frame.height / 2
    }
    
    func styleTextFild(_ textField: UITextField, placehoder: String){
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: placehoder,
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    func animateButton(_ button: UIButton){
        UIView.animate(withDuration: 1) {
            button.alpha = 1
        }
    }
    
    func isFieldsEmpty(_ textFields: [UITextField]) -> Bool{
        for textField in textFields {
            if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return true
            }
        }
        return false
    }
    
    func isEmailCorrect(_ email: String) -> Bool {
        let emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailRegex.evaluate(with: email)
    }
        
    func isPasswordCorrect(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{7,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    func showErrorMessage(on label: UILabel, message: String) {
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            label.alpha = 1
            label.text = message
        } completion: { finish in
            UIView.animate(withDuration: 1.5) {
                label.alpha = 0
            }
        }
    }
}
