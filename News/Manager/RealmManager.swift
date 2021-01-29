import Foundation
import RealmSwift

class RealmManager {
    
    private init () {}
    static let shared = RealmManager()
    
    private lazy var realm = try! Realm()
    
    private func add(_ object: Object) {
        try! realm.write {
            realm.add(object, update: .all)
        }
    }
    
    func fetch() -> [NewsRealmModel] {
        let userId = FirebaseManager.shared.getUserId()
        let objects = realm.objects(NewsRealmModel.self).filter("userId = %@", userId)
        return Array(objects)
    }
    
    func delete(objectField url: String) {
        let userId = FirebaseManager.shared.getUserId()
        guard let object = realm.objects(NewsRealmModel.self).filter("url = %@ AND userId = %@", url, userId).first else { return }
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func write(_ model: News.Item?) {
        let isAdded = findRealmObject(by: model?.url ?? "")
        if isAdded == nil {
            let realmModel = NewsRealmModel()
            realmModel.userId = FirebaseManager.shared.getUserId()
            realmModel.title = model?.title ?? ""
            realmModel.desc = model?.description ?? ""
            realmModel.url = model?.url ?? ""
            realmModel.urlToImage = model?.urlToImage ?? ""
            realmModel.publishedAt = model?.publishedAt ?? ""
            realmModel.note = model?.note ?? ""
            add(realmModel)
        }
    }
    
    func update(_ model: News.Item?) {
        guard let url = model?.url else { return }
        let object = findRealmObject(by: url)
        try! realm.write {
            object!.note = model?.note ?? ""
        }
    }
    
    func findRealmObject(by url: String) -> NewsRealmModel? {
        let userId = FirebaseManager.shared.getUserId()
        let object = realm.objects(NewsRealmModel.self).filter("url = %@ AND userId = %@", url, userId).first
        if object != nil {
            return object
        } else {
            return nil
        }
    }
    
    func configure() {
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    }
}
