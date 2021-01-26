import Foundation
import SwiftyJSON

extension Decodable {
    static func from(_ json: JSON) -> Self? {
        guard let data = try? json.rawData() else {
            return nil
        }
        return from(data)
    }
    
    static func from(_ data: Data) -> Self? {
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
