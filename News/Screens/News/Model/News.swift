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
    }
}
