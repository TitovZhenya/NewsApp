import UIKit

extension NewsViewController: NewsCellDelegate {    
    func newsCellNewsShare(_ cell: UITableViewCell, sender: UIButton) {
        guard let indexPath = table.indexPath(for: cell),
              let url = newsViewModel?.items?[indexPath.row].url else { return }
        let shareVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = sender
        shareVC.popoverPresentationController?.sourceRect = sender.frame
        present(shareVC, animated: true)
    }
}
