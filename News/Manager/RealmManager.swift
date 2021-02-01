import Foundation
import RealmSwift

class RealmManager {
    
    private init () {}
    static let shared = RealmManager()
    
    private lazy var realm = try! Realm()
    
    private var userId = ""
    
    private func add(_ object: Object) {
        try! realm.write {
            realm.add(object, update: .all)
        }
    }
    
    func fetch<T: Object>() -> Results<T> {
        let userId = FirebaseManager.shared.getUserId()
        self.userId = userId
        let objects = realm.objects(T.self).filter("userId = %@", userId)
        return objects
    }
    
    func deleteObject(_ object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func write(_ model: News.Item?) {
        let isAdded = findRealmObject(by: model?.url ?? "")
        if isAdded == nil {
            let realmModel = NewsRealmModel()
            realmModel.title = model?.title ?? ""
            realmModel.desc = model?.description ?? ""
            realmModel.url = model?.url ?? ""
            realmModel.urlToImage = model?.urlToImage ?? ""
            realmModel.publishedAt = model?.publishedAt ?? ""
            add(realmModel)
        }
    }
    
    func write(_ model: SettingsModel?) {
        guard let password = model?.password,
              let isLocked = model?.isLocked else { return }
        let realmModel = SettingsRealmModel()
        realmModel.password = password
        realmModel.isLocked = isLocked
        add(realmModel)
    }
    
    func deleteNews(_ url: String) {
        guard let object = realm.objects(NewsRealmModel.self).filter("url = %@ AND userId = %@", url, self.userId).first else { return }
        deleteObject(object)
    }
    
    func addNote(_ model: News.Item?, text: String) {
        guard let url = model?.url,
              let object = findRealmObject(by: url) else { return }
        try! realm.write {
            object.notes.append(text)
        }
    }
    
    func updateNote(_ model: News.Item?, text: String, index: Int) {
        guard let url = model?.url,
              let object = findRealmObject(by: url) else { return }
        try! realm.write {
            object.notes[index] = text
        }
    }
    
    func deleteNote(_ model: News.Item?, index: Int) {
        guard let url = model?.url,
              let object = findRealmObject(by: url) else { return }
        try! realm.write {
            object.notes.remove(at: index)
        }
    }
    
    func deletePassword() {
        guard let object = realm.objects(SettingsRealmModel.self).filter("userId = %@", self.userId).first else { return }
        deleteObject(object)
    }
    
    func findRealmObject(by url: String) -> NewsRealmModel? {
        let userId = FirebaseManager.shared.getUserId()
        self.userId = userId
        let object = realm.objects(NewsRealmModel.self).filter("url = %@ AND userId = %@", url, userId).first ?? nil
        return object
    }
    
    func configure() {
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    }
}
