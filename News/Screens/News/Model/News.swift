import UIKit

struct News {
    var items: [Item]?
    var totalResults: Int?
    var currentPage: Int?
    var lastPage: Int?
    
    struct Item {
        var title: String?
        var description: String?
        var url: String?
        var urlToImage: String?
        var publishedAt: String?
        var notes: [String]?
        
        init(title: String?, description: String?, url: String?, urlToImage: String?, publishedAt: String?) {
            self.title = title
            self.description = description
            self.url = url
            self.urlToImage = urlToImage
            self.publishedAt = publishedAt
        }
        
        init(realmModel: NewsRealmModel) {
            self.title = realmModel.title
            self.description = realmModel.desc
            self.url = realmModel.url
            self.urlToImage = realmModel.urlToImage
            self.publishedAt = realmModel.publishedAt
            self.notes = Array(realmModel.notes)
        }
    }
}
