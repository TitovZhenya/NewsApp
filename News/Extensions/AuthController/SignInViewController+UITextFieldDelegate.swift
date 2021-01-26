import UIKit

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        TextFieldAnimate.shared.animateField(for: textField, of: userInfoViews)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        TextFieldAnimate.shared.animateToNormal(of: userInfoViews)
        
    }
}
