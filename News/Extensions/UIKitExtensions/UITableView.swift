import UIKit

extension UITableView {
    func scrollTop() {
        if self.numberOfRows(inSection: 0) == 0 {
            return
        }
        let topRow = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: topRow, at: .top, animated: true)
    }
}
