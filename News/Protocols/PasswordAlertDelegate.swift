import UIKit

@objc protocol PasswordAlertDelegate: class {
    func passwordAlertConfirmed()
    func passwordAlertCompare(_ password: String)
    func passwordAlertPresent(_ alertController: UIAlertController)
    @objc optional func passwordAlertCreatePassword(_ password: String)
    @objc optional func passwordAlertUnConfirmed()
    @objc optional func passwordAlertDeletePassword(_ password: String)
}
