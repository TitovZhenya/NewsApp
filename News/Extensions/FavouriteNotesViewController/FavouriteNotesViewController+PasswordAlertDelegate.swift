import UIKit

extension FavouriteNotesViewController: PasswordAlertDelegate {
 
    func passwordAlertConfirmed() {
        self.userSettingsModel?.isLocked = false
        RealmManager.shared.write(self.userSettingsModel)
        self.setSettingsRealmModel()
    }
    
    func passwordAlertCompare(_ password: String) {
        let savedPassword = self.userSettingsModel?.password
            if password == savedPassword {
            self.userSettingsModel?.isLocked = false
            RealmManager.shared.write(self.userSettingsModel)
            self.setSettingsRealmModel()
        }
    }
    
    func passwordAlertPresent(_ alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}

