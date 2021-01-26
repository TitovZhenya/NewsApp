import Foundation

struct ApiPath {
    static let everything = "everything"
    static let topHeadlines = "top-headlines"
    static let sources = "sources"
}

struct ApiFilter {
    static let countries = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
    
    static let categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
}

struct ApiPage {
    static let pageSize = 20
}
