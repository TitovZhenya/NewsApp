import UIKit
import CoreLocation

class NewsViewController: UIViewController {
    
    @IBOutlet private(set) weak var table: UITableView!
    @IBOutlet private(set) weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private(set) weak var searchStackView: UIStackView!
    @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var noResultsStackView: UIStackView!
    
    private(set) var locationManager = CLLocationManager()
    
    private(set) var newsViewModel: News?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setUpElements() {
        table.separatorStyle = .none
        table.backgroundColor = .clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        table.register(UINib(nibName: NewsCell.reuseIndetifier, bundle: nil), forCellReuseIdentifier: NewsCell.reuseIndetifier)
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        searchBar.backgroundColor = .clear
        activityIndicator.isHidden = true
        let filterVC = self.tabBarController?
            .viewControllers?[TabBarViewControllers.filterViewController.rawValue] as! FilterViewController
        filterVC.delegate = self
        locationManager.delegate = self
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func loadEverythingData() {
        table.scrollTop()
        NewsManager.shared.removePages()
        NewsManager.shared.fetchEverythingNews { [weak self] result in
            guard let self = self else { return }
            self.checkResult(result)
        }
    }
    
    func loadTopHeadlinesData() {
        table.scrollTop()
        NewsManager.shared.removePages()
        NewsManager.shared.fetchTopHeadlinesNews { [weak self] result in
            guard let self = self else { return }
            self.checkResult(result)
        }
    }
    
    private func checkResult(_ result: NewsResult?) {
        if result != nil {
            self.noResultsStackView.isHidden = result?.totalResults == 0 ? false : true
            self.setModelData(result)
        } else {
            self.noResultsStackView.isHidden = false
            self.newsViewModel = nil
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    private func setModelData(_ data: NewsResult?) {
        let resultArticles = data?.articles.map { newsItem -> News.Item in
            let date = newsItem.publishedAt?.toDate()
            return News.Item(title: newsItem.title,
                             description: newsItem.description,
                             url: newsItem.url,
                             urlToImage: newsItem.urlToImage,
                             publishedAt: date)
        }
        guard let totalResults = data?.totalResults else { return }
        var lastPage = Int(totalResults / ApiPage.pageSize)
        if totalResults % ApiPage.pageSize > 0 {
            lastPage = totalResults / ApiPage.pageSize + 1
        }
        self.newsViewModel = News(items: resultArticles, totalResults: data?.totalResults, currentPage: 1, lastPage: lastPage)
        
        self.table.isHidden = false
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func loadPreviousNews(_ data: NewsResult?) {
        data?.articles.forEach { article in
            let date = article.publishedAt?.toDate()
            let newsItem = News.Item(title: article.title,
                                    description: article.description,
                                    url: article.url,
                                    urlToImage: article.urlToImage,
                                    publishedAt: date)
            self.newsViewModel?.items?.append(newsItem)
        }
        self.activityIndicator.stopAnimating()
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func setNextPage() -> Bool {
        guard var page = newsViewModel?.currentPage else { return false }
        page += 1
        if page != newsViewModel?.lastPage {
            NewsManager.shared.nextPage(page)
            newsViewModel?.currentPage? = page
            return true
        }
        activityIndicator.isHidden = true
        return false
    }
    
    @objc private func handleSegmentChange() {
        switch segmentControl.selectedSegmentIndex {
        case FetchPath.topHeadlines.rawValue:
            loadTopHeadlinesData()
        case FetchPath.everything.rawValue:
            loadEverythingData()
        default:
            break
        }
    }
    
    @IBAction func signOut(sender: UIBarButtonItem) {
        FirebaseManager.shared.signOut()
    }
    
    @IBAction func showSearchMenu(sender: UIBarButtonItem) {
        if searchStackView.isHidden {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.searchStackView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.searchStackView.isHidden = true
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = newsViewModel?.items?.count else { return 0 }
        return items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIndetifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let cellViewModel = newsViewModel?.items?[indexPath.row]
        cell.set(newsModel: cellViewModel)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = newsViewModel?.items?[indexPath.row]
        let webVC = WebViewController(cellViewModel)
        webVC.modalPresentationStyle = .fullScreen
        self.present(webVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
        guard let cellViewModel = newsViewModel?.items?[indexPath.row],
              let url = cellViewModel.url else { return nil }
        let addFavouritesAction = UIContextualAction(style: .normal, title: nil) { action, view, completion in
            if RealmManager.shared.findRealmObject(by: url) != nil {
                RealmManager.shared.deleteNews(url)
            } else {
                RealmManager.shared.write(cellViewModel)
            }
            completion(true)
        }
        addFavouritesAction.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        if (RealmManager.shared.findRealmObject(by: url) != nil) {
            addFavouritesAction.image = UIImage(systemName: "bookmark.fill", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        } else {
            addFavouritesAction.image = UIImage(systemName: "bookmark", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
        return UISwipeActionsConfiguration(actions: [addFavouritesAction])
    }
}
