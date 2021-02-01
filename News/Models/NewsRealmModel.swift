import RealmSwift

class NewsRealmModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var urlToImage: String = ""
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var userId: String = FirebaseManager.shared.getUserId()
    var notes = List<String>()
        
    override class func primaryKey() -> String? {
        return "id"
    }
}
