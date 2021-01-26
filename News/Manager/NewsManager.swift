import Foundation

class NewsManager {
    static let shared = NewsManager()
    
    var parameters: [String : Any] = [ApiParameters.q.rawValue : "apple"]

    var country: String?
    var category: String?
    var sources: String?
    var search: String?
            
    private init() {}
    
    func addParameters() {
        var newParameters = [String : Any]()
        if let category = category {
            newParameters[ApiParameters.category.rawValue] = category
        }
        
        if let sources = sources {
            newParameters[ApiParameters.sources.rawValue] = sources
        }
        
        if let country = country {
            newParameters[ApiParameters.country.rawValue] = country
        }
        
        if let search = search {
            newParameters[ApiParameters.q.rawValue] = search
        }
        parameters = newParameters
    }
    
    func nextPage(_ page: Int) {
        parameters[ApiParameters.page.rawValue] = page
    }
    
    func fetchEverythingNews(closure: @escaping ((NewsResult?) -> Void)) {
        RequestHandler(path: ApiPath.everything, parameters: parameters).response(closure)
    }
    
    func fetchTopHeadlinesNews(closure: @escaping ((NewsResult?) -> Void)) {
        RequestHandler(path: ApiPath.topHeadlines, parameters: parameters).response(closure)
    }
    
    func fetchSources(closure: @escaping ((SourceResult?) -> Void )) {
        RequestHandler(path: ApiPath.sources).response(closure)
    }
    
    func removeParameters() {
        parameters.removeAll()
        country = nil
        category = nil
        sources = nil
        search = nil
    }
    
    func removePages() {
        parameters.removeValue(forKey: ApiParameters.page.rawValue)
    }
}
