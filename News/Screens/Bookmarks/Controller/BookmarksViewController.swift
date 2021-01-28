import UIKit
import RealmSwift

class BookmarksViewController: UIViewController {
    
    @IBOutlet private(set) weak var table: UITableView!
    
    private(set) var favouritesNewsModel: [News.Item]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpModel()
    }
    
    private func setUpElements() {
        table.separatorStyle = .none
        table.backgroundColor = .clear
        self.title = "Bookmarks"
        table.register(UINib(nibName: NewsCell.reuseIndetifier, bundle: nil), forCellReuseIdentifier: NewsCell.reuseIndetifier)
    }
    
    private func setUpModel() {
        let favouritesNews: [NewsRealmModel] = RealmManager.shared.fetch()
        favouritesNewsModel = favouritesNews.map { News.Item(realmModel: $0) }
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
}

//MARK: - UITableViewDataSource
extension BookmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = favouritesNewsModel?.count else { return 0 }
        return items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIndetifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let cellViewModel = favouritesNewsModel?[indexPath.row]
        cell.set(newsModel: cellViewModel)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension BookmarksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = favouritesNewsModel?[indexPath.row]
        let webVC = WebViewController(cellViewModel)
        webVC.modalPresentationStyle = .fullScreen
        self.present(webVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
        let removeFavouritesAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            let cellViewModel = self.favouritesNewsModel?[indexPath.row]
            guard let url = cellViewModel?.url else { return }
            RealmManager.shared.delete(objectField: url)
            self.favouritesNewsModel?.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .left)
            completion(true)
        }
        removeFavouritesAction.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        removeFavouritesAction.image = UIImage(systemName: "trash", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [removeFavouritesAction])
    }
}
