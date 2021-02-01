import RealmSwift

class SettingsRealmModel: Object {
    @objc dynamic var userId = FirebaseManager.shared.getUserId()
    @objc dynamic var password: String = ""
    @objc dynamic var isLocked = false
        
    override class func primaryKey() -> String? {
        return "userId"
    }
}
