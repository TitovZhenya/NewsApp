import UIKit
import RealmSwift

class BookmarksViewController: UIViewController {
    
    @IBOutlet private(set) weak var table: UITableView!
    private var visualEffectView: UIVisualEffectView!
    private var noteView: UIView!
    private var passwordButton: UIButton!
    private var noteTextView: UITextView!
    
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
    
    private func createNewsNote(to model: News.Item, indexPath: Int) {
        //add blur effect
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.frame = self.view.frame
        self.visualEffectView = visualEffectView
        
        //add note view
        let noteView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.height / 4))
        noteView.center = self.view.center
        noteView.backgroundColor = .white
        noteView.layer.cornerRadius = 15
        noteView.clipsToBounds = true
        self.noteView = noteView
        
        //animate blur effect + note view
        UIView.transition(with: self.view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(visualEffectView)
            self.view.addSubview(noteView)
        }, completion: nil)
        
        //create exit button
        let closeButtonImage = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let closeButton = UIButton(frame: CGRect(x: noteView.bounds.maxX - 35, y: 5, width: 30, height: 30))
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeNote), for: .touchUpInside)
        closeButton.tag = indexPath
        noteView.addSubview(closeButton)
        
        //create password button
        let lockButtonImage = UIImage(systemName: "lock.open")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let passwordButton = UIButton(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        passwordButton.setImage(lockButtonImage, for: .normal)
        noteView.addSubview(passwordButton)
        self.passwordButton = passwordButton
        
        //create text view
        let textView = UITextView(frame: CGRect(x: 5, y: 35, width: noteView.frame.width, height: noteView.frame.height - 35))
        textView.text = model.note
        noteView.addSubview(textView)
        self.noteTextView = textView
    }
    
    @objc private func closeNote(_ sender: UIButton) {
        UIView.transition(with: self.view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
            self.visualEffectView.removeFromSuperview()
            self.noteView.removeFromSuperview()
        }, completion: nil)
        var newsModel = favouritesNewsModel?[sender.tag]
        newsModel?.note = noteTextView.text
        RealmManager.shared.update(newsModel)
        self.setUpModel()
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
            RealmManager.shared.delete(objectField: url)
            self.favouritesNewsModel?.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .left)
            completion(true)
        }
        removeFavouritesAction.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        removeFavouritesAction.image = UIImage(systemName: "trash", withConfiguration: config)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [removeFavouritesAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
        
        guard let cellViewModel = favouritesNewsModel?[indexPath.row] else { return nil }
        let favouriteNotesViewController = FavouriteNotesViewController()
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
