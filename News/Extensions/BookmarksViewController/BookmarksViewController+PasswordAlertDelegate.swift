import UIKit

extension BookmarksViewController: PasswordAlertDelegate {
    
    func passwordAlertConfirmed() {
        self.userSettingsModel?.isLocked = false
        RealmManager.shared.write(self.userSettingsModel)
        self.setSettingsRealmModel()
    }
    
    func passwordAlertUnConfirmed() {
        self.userSettingsModel?.isLocked = true
        RealmManager.shared.write(self.userSettingsModel)
        self.setSettingsRealmModel()
    }
    
    func passwordAlertCompare(_ password: String) {
        let savedPassword = self.userSettingsModel?.password
        if password == savedPassword {
            self.userSettingsModel?.isLocked = false
            RealmManager.shared.write(self.userSettingsModel)
        } else {
            passwordAlertHelper.wrongPassword()
        }
        self.setSettingsRealmModel()
    }
    
    func passwordAlertPresent(_ alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func passwordAlertCreatePassword(_ password: String) {
        self.userSettingsModel?.password = password
        self.userSettingsModel?.isLocked = true
        RealmManager.shared.write(self.userSettingsModel)
        self.setSettingsRealmModel()
    }
    
    func passwordAlertDeletePassword(_ password: String) {
        let savedPassword = self.userSettingsModel?.password
        if password == savedPassword {
            RealmManager.shared.deletePassword()
        } else {
            passwordAlertHelper.wrongPassword()
        }
        self.setSettingsRealmModel()
    }
}

