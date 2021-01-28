import UIKit
import CoreLocation

class NewsViewController: UIViewController {
    
    @IBOutlet private(set) weak var table: UITableView!
    @IBOutlet private(set) weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private(set) weak var searchStackView: UIStackView!
    @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!
    
    private(set) var locationManager = CLLocationManager()
    
    private(set) var newsViewModel: News?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDelegate()
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
        self.title = "News"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(showSearchMenu))
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        table.register(UINib(nibName: NewsCell.reuseIndetifier, bundle: nil), forCellReuseIdentifier: NewsCell.reuseIndetifier)
        searchBar.searchTextField.addDoneButton()
        activityIndicator.isHidden = true
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // error: turn on location
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    private func setUpDelegate() {
        let filterVC = self.tabBarController?
            .viewControllers?[TabBarViewControllers.filterViewController.rawValue] as! FilterViewController
        filterVC.delegate = self
        locationManager.delegate = self
    }
    
    func loadEverythingData() {
        table.scrollTop()
        NewsManager.shared.removePages()
        NewsManager.shared.fetchEverythingNews { [weak self] result in
            guard let self = self else { return }
            self.setModelData(result)
        }
    }
    
    func loadTopHeadlinesData() {
        table.scrollTop()
        NewsManager.shared.removePages()
        NewsManager.shared.fetchTopHeadlinesNews { [weak self] result in
            guard let self = self else { return }
            self.setModelData(result)
        }
    }
    
    private func setModelData(_ data: NewsResult?) {
        let resultArticles = data?.articles.map { newsItem -> News.Item in
            let date = newsItem.publishedAt?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
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
            let date = article.publishedAt?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
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
    
    @objc private func signOut(sender: UIBarButtonItem) {
        FirebaseManager.shared.signOut()
    }
    
    @objc private func showSearchMenu(sender: UIBarButtonItem) {
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
        let cellViewModel = newsViewModel?.items?[indexPath.row]
        let addFavouritesAction = UIContextualAction(style: .normal, title: nil) { action, view, completion in
            RealmManager.shared.write(cellViewModel)
            completion(true)
        }
        addFavouritesAction.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        if RealmManager.shared.isObjectInRelm(url: cellViewModel?.url ?? "") {
            addFavouritesAction.image = UIImage(systemName: "bookmark.fill", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        } else {
            addFavouritesAction.image = UIImage(systemName: "bookmark", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
        return UISwipeActionsConfiguration(actions: [addFavouritesAction])
    }
}
