import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
    private var filterViewModel: [Source]?
    
    weak var delegate: FilterViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setCategoryModel()
    }

    private func setUpElements() {
        table.backgroundColor = .clear
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        table.register(UINib(nibName: FilterCell.reuseIndetifier, bundle: nil), forCellReuseIdentifier: FilterCell.reuseIndetifier)
        table.tableFooterView = UIView()
    }
    
    private func setCategoryModel() {
        let categories = ApiFilter.categories.map { Source(name: $0) }
        filterViewModel = categories
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    private func setCountryModel() {
        let countries = ApiFilter.countries.map { country -> Source in
            let convertedCountry = country.getCountryName()
            return Source(id: country, name: convertedCountry)
        }
        filterViewModel = countries
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    private func setSourseModel() {
        NewsManager.shared.fetchSources { [weak self] result in
            guard let self = self else { return }
            if let result = result?.sources {
                let sources = result.map { source -> Source in
                    return Source(id: source.id, name: source.name)
                }
                self.filterViewModel = sources
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
    }
    
    @objc private func handleSegmentChange() {
        switch segmentControl.selectedSegmentIndex {
        case NewsFilter.category.rawValue:
            table.scrollTop()
            setCategoryModel()
        case NewsFilter.country.rawValue:
            table.scrollTop()
            setCountryModel()
        case NewsFilter.sources.rawValue:
            table.scrollTop()
            setSourseModel()
        default:
            break
        }
    }
}

//MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = filterViewModel?.count else { return 0 }
        return items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIndetifier, for: indexPath) as? FilterCell,
              let filterViewModel = self.filterViewModel else {
            return UITableViewCell()
        }
        let cellFilter = filterViewModel[indexPath.row]
        cell.set(cellFilter.name)
        if (indexPath.row == filterViewModel.count - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: view.bounds.width, bottom: 0, right: 0);
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = filterViewModel?[indexPath.row]
        guard let name = cellViewModel?.name,
              let filterTitle = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)?.lowercased()
        else {
            return
        }
        self.delegate?.filterViewShouldDisplay(self, name: name, id: cellViewModel?.id, filterTitle: filterTitle)
        tabBarController?.selectedIndex = 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.001 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
    }
}
