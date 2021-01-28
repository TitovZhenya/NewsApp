import Foundation
import Alamofire
import SwiftyJSON

struct RequestHandler {
    private let hostUrl: String
    private let path: String
    private let headers: HTTPHeaders = ["X-Api-Key" : "227455a1d31c41968aed5e863f925693"]
    private let method: HTTPMethod
    private var parameters: Parameters?
    //MARK: API KEY - 275c9975157c45ca88f7a5f9dcda48c8 - Zhenya
    //MARK: API KEY - 227455a1d31c41968aed5e863f925693 - Anya
        
    private var completeUrl: String {
        return hostUrl + path
    }
    
    init(hostUrl: String = "https://newsapi.org/v2/", path: String = "", method: HTTPMethod = .get, parameters: Parameters? = nil) {
        self.hostUrl = hostUrl
        self.method = method
        self.path = path
        self.parameters = parameters
      }
    
    @discardableResult
    func response<T: Codable>(_ closure: @escaping ((T?) -> Void)) -> RequestHandler {
        responseJSON { json in
            let model = T.from(json)
            closure(model)
        }
        return self
    }
    
    @discardableResult
    func responseJSON(_ closure: @escaping ((JSON) -> Void)) -> RequestHandler {
        AF.request(completeUrl, method: method, parameters: parameters, headers: headers)
            .responseData { response in
                if let data = response.data, let json = try? JSON(data: data) {
                        closure(json)
                      } else {
                        closure(JSON())
                      }
        }
        return self
    }
    
    @discardableResult
    func getImage(_ closure: @escaping ((Data) -> Void)) -> RequestHandler {
        AF.request(completeUrl, method: method).responseData { response in
            if let data = response.data {
                closure(data)
            }
        }
        return self
    }
}

