import Foundation

class SettingsModel {
    var userId: String?
    var password: String?
    var isLocked: Bool
    
    init(userId: String? = nil, password: String? = nil, isLocked: Bool = false) {
        self.userId = userId
        self.password = password
        self.isLocked = isLocked
    }
    
    init(realmModel: SettingsRealmModel) {
        self.userId = realmModel.userId
        self.password = realmModel.password
        self.isLocked = realmModel.isLocked
    }
}
