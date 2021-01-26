import Foundation

struct NewsResult: Codable {
    var articles: [ArticlesResult]
    var totalResults: Int?
}

struct ArticlesResult: Codable {
    var source: Source?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
}

struct Source: Codable {
    var id: String?
    var name: String?
}
