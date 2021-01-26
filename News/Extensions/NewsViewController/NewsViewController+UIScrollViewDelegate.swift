import UIKit

extension NewsViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
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
