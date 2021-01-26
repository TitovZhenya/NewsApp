import UIKit

extension NewsViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let trimmingText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        searchBar.text = ""
        if trimmingText == ""  {
            return
        }
        guard let text = trimmingText else { return }
        switch segmentControl.selectedSegmentIndex {
        case FetchPath.everything.rawValue:
            NewsManager.shared.search = text
            NewsManager.shared.addParameters()
            loadEverythingData()
        case FetchPath.topHeadlines.rawValue:
            NewsManager.shared.search = text
            NewsManager.shared.addParameters()
            loadTopHeadlinesData()
        default:
            return
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.searchStackView.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
