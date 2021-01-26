import UIKit

extension UITableViewCell {
    
    static var reuseIndetifier: String {
        return String(describing: self)
    }
}
