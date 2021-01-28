import Foundation
import RealmSwift

class RealmManager {
    
    private init () {}
    static let shared = RealmManager()
    
    private lazy var realm = try! Realm()
    
    func add(_ object: Object) {
        try! realm.write {
            realm.add(object, update: .all)
        }
    }
    
    func fetch<T: Object>() -> [T] {
        let userId = FirebaseManager.shared.getUserId()
        let objects = realm.objects(T.self).filter("userId = %@", userId)
        return Array(objects)
    }
    
    func delete(objectField url: String) {
        guard let object = realm.objects(NewsRealmModel.self).filter("url = %@", url).first else { return }
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func write(_ model: News.Item?) {
        let isAdded = isObjectInRelm(url: model?.url ?? "")
        if !isAdded {
            let realmModel = NewsRealmModel()
            realmModel.userId = FirebaseManager.shared.getUserId()
            realmModel.title = model?.title ?? ""
            realmModel.desc = model?.description ?? ""
            realmModel.url = model?.url ?? ""
            realmModel.urlToImage = model?.urlToImage ?? ""
            realmModel.publishedAt = model?.publishedAt ?? ""
            add(realmModel)
        }
    }
    
    func isObjectInRelm(url: String) -> Bool {
        let userId = FirebaseManager.shared.getUserId()
        let object = realm.objects(NewsRealmModel.self).filter("url = %@ AND userId = %@", url, userId).first
        if object != nil {
            return true
        } else {
            return false
        }
    }
    
    func configure() {
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    }
}
