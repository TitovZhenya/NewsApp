import UIKit
import RealmSwift
import LocalAuthentication

class BookmarksViewController: UIViewController {
    
    @IBOutlet private(set) weak var table: UITableView!
    @IBOutlet private weak var passwordButton: UIBarButtonItem!
    @IBOutlet private weak var removeNoteButton: UIBarButtonItem!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var noResultsStackView: UIStackView!
    private var alertController: UIAlertController!
    
    private(set) var passwordAlertHelper: PasswordAlertHelper!
    
    private(set) var favouritesNewsModel: [News.Item]?
    private(set) var userSettingsModel: SettingsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setSettingsRealmModel()
        lockNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setSettingsRealmModel()
        setNewsRealmModel()
    }

    private func setUpElements() {
        table.separatorStyle = .none
        table.backgroundColor = .clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        table.register(UINib(nibName: NewsCell.reuseIndetifier, bundle: nil), forCellReuseIdentifier: NewsCell.reuseIndetifier)
        passwordAlertHelper = PasswordAlertHelper()
        passwordAlertHelper.delegate = self
    }
    
    private func setNewsRealmModel() {
        let favouritesNews: Results<NewsRealmModel> = RealmManager.shared.fetch()
        favouritesNewsModel = favouritesNews.map { News.Item(realmModel: $0) }
        noResultsStackView.isHidden = favouritesNewsModel?.count == 0 ? false : true
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func setSettingsRealmModel() {
        let settingsRealmModel: Results<SettingsRealmModel> = RealmManager.shared.fetch()
        guard let realmModel = settingsRealmModel.first else {
            userSettingsModel = SettingsModel()
            removeNoteButton.isEnabled = false
            removeNoteButton.image = nil
            passwordButton.image = UIImage(systemName: "lock.open")
            return
        }
        userSettingsModel = SettingsModel(realmModel: realmModel)
        passwordButton.image = realmModel.isLocked ? UIImage(systemName: "lock") : UIImage(systemName: "lock.open")
        removeNoteButton.isEnabled = true
        removeNoteButton.image = UIImage(systemName: "lock.slash")
    }
    
    private func lockNotes() {
        userSettingsModel?.isLocked = true
        RealmManager.shared.write(self.userSettingsModel)
        setSettingsRealmModel()
    }
  
    @IBAction func lockAction(_ sender: UIBarButtonItem) {
        guard let userSettingsModel = userSettingsModel else { return }
        if userSettingsModel.password == nil {
            passwordAlertHelper.createPassword()
        } else {
            passwordAlertHelper.lockNote(userSettingsModel.isLocked)
        }
    }
    
    @IBAction func removeNotePassword(_ sender: UIBarButtonItem) {
        passwordAlertHelper.deletePassword()
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
        let removeFavouritesAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            let cellViewModel = self.favouritesNewsModel?[indexPath.row]
            guard let url = cellViewModel?.url else { return }
            RealmManager.shared.deleteNews(url)
            self.favouritesNewsModel?.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .right)
            self.noResultsStackView.isHidden = self.favouritesNewsModel?.count == 0 ? false : true
            completion(true)
        }
        removeFavouritesAction.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        removeFavouritesAction.image = UIImage(systemName: "trash", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [removeFavouritesAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
        
        guard let cellViewModel = favouritesNewsModel?[indexPath.row] else { return nil }
        let favouriteNotesViewController = FavouriteNotesViewController(cellViewModel)
        let readNoteAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            favouriteNotesViewController.modalPresentationStyle = .fullScreen
            self.present(favouriteNotesViewController, animated: true, completion: nil)
            completion(true)
        }
        readNoteAction.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        readNoteAction.image = UIImage(systemName: "note", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [readNoteAction])
    }
}
