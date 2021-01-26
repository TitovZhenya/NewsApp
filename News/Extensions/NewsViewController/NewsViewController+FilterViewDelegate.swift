import UIKit

extension NewsViewController: FilterViewDelegate {
    func filterViewShouldDisplay(_ view: FilterViewController, name: String, id: String?, filterTitle: String) {
        NewsManager.shared.removeParameters()
        switch filterTitle {
        case ApiParameters.category.rawValue:
            NewsManager.shared.category = name
            NewsManager.shared.addParameters()
            segmentControl.selectedSegmentIndex = FetchPath.topHeadlines.rawValue
            loadTopHeadlinesData()
        case ApiParameters.country.rawValue:
            guard let id = id else { return }
            NewsManager.shared.country = id
            NewsManager.shared.addParameters()
            segmentControl.selectedSegmentIndex = FetchPath.topHeadlines.rawValue
            loadTopHeadlinesData()
        case ApiParameters.sources.rawValue:
            guard let id = id else { return }
            NewsManager.shared.sources = id
            NewsManager.shared.addParameters()
            if segmentControl.selectedSegmentIndex == FetchPath.everything.rawValue {
                loadEverythingData()
            } else {
                loadTopHeadlinesData()
            }
        default:
            return
        }
    }
}
