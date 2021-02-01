import UIKit
import LocalAuthentication

class PasswordAlertHelper {
    
    var alertController: UIAlertController!
    let context = LAContext()
    var error: NSError?
    
    weak var delegate: PasswordAlertDelegate?
    
    func createPassword() {
        alertController = UIAlertController(title: "Do you want to create password", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.alertController = UIAlertController(title: "Enter your password",
                                                message: "Password must contains one big letter, one number and is minimum seven char long",
                                                preferredStyle: .alert)
            self.alertController.addTextField {
                $0.placeholder = "password"
                $0.isSecureTextEntry = true
                $0.addTarget(self, action: #selector(self.textDidChangeInLoginAlert), for: .editingChanged)
            }
            self.alertController.addAction(UIAlertAction(title: "Exit", style: .default, handler: nil))
            self.alertController.addAction(UIAlertAction(title: "Confirm", style: .default) { [weak self] action in
                guard let self = self,
                      let textField = self.alertController.textFields?.first,
                      let password = textField.text else { return }
                self.delegate?.passwordAlertCreatePassword?(password)
            })
            self.alertController.actions[1].isEnabled = false
            self.delegate?.passwordAlertPresent(self.alertController)
        })
        delegate?.passwordAlertPresent(self.alertController)
    }
    
    func unlockNote(_ isLocked: Bool) {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            checkDeviceBiometrics(isLocked)
        } else {
            showPasswordAlert(.compare)
        }
    }
    
    func lockNote(_ isLocked: Bool) {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            checkDeviceBiometrics(isLocked)
        } else {
            if isLocked {
                showPasswordAlert(.compare)
            } else {
                self.delegate?.passwordAlertUnConfirmed?()
            }
        }
    }
    
    func wrongPassword() {
        alertController = UIAlertController(title: "Your password is incorrect", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        delegate?.passwordAlertPresent(alertController)
    }
    
    func deletePassword() {
        alertController = UIAlertController(title: "Do you want to delete your password", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.showPasswordAlert(.delete)
        })
        delegate?.passwordAlertPresent(alertController)
    }
    
    @objc func textDidChangeInLoginAlert(_ textField: UITextField) {
        if let password = textField.text {
            self.alertController.actions[1].isEnabled = Utilities.shared.isPasswordCorrect(password)
        }
    }
    
    private func checkDeviceBiometrics(_ isLocked: Bool) {
        let reason = "Allow app to use your biometrics"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    isLocked ? self.delegate?.passwordAlertConfirmed() : self.delegate?.passwordAlertUnConfirmed?()

                } else {
                    self.showPasswordAlert(.compare)
                }
            }
        }
    }
    
    private func showPasswordAlert(_ passwordAction: PasswordAction) {
        self.alertController = UIAlertController(title: "Enter your password", message: nil, preferredStyle: .alert)
        self.alertController.addTextField {
            $0.placeholder = "password"
            $0.isSecureTextEntry = true
        }
        self.alertController.addAction(UIAlertAction(title: "Exit", style: .default, handler: nil))
        self.alertController.addAction(UIAlertAction(title: "Confirm", style: .default) { [weak self] action in
                guard let self = self,
                      let textField = self.alertController.textFields?.first,
                      let password = textField.text else { return }
            switch passwordAction {
            case .compare:
                self.delegate?.passwordAlertCompare(password)
            case .delete:
                self.delegate?.passwordAlertDeletePassword?(password)
            }
        })
        self.delegate?.passwordAlertPresent(self.alertController)
    }
}
