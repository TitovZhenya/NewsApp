import UIKit

extension NewsViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 10 {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            switch segmentControl.selectedSegmentIndex {
            case FetchPath.everything.rawValue:
                if setNextPage() {
                    NewsManager.shared.fetchEverythingNews { [weak self] result in
                        guard let self = self else { return }
                        self.loadPreviousNews(result)
                        self.activityIndicator.isHidden = true
                    }
                }
            case FetchPath.topHeadlines.rawValue:
                if setNextPage() {
                    NewsManager.shared.fetchTopHeadlinesNews { [weak self] result in
                        guard let self = self else { return }
                        self.loadPreviousNews(result)
                        self.activityIndicator.isHidden = true
                    }
                }
            default:
                return
            }
        }
    }
}
