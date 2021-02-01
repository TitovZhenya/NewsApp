import UIKit
import RealmSwift

class FavouriteNotesViewController: UIViewController {
    
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    @IBOutlet private weak var noteTextView: UITextView!
    @IBOutlet private weak var noteView: UIView!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var lockedNotesStackView: UIStackView!
    
    private var passwordAlertHelper: PasswordAlertHelper!
    
    private var newsModel: News.Item?
    private(set) var userSettingsModel: SettingsModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        setSettingsRealmModel()
    }
    
    convenience init(_ model: News.Item) {
        self.init()
        self.newsModel = model
    }

    private func setUpElements() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        noteView.layer.cornerRadius = 15
        table.register(UINib(nibName: FilterCell.reuseIndetifier, bundle: nil), forCellReuseIdentifier: FilterCell.reuseIndetifier)
        table.tableFooterView = UIView()
        passwordAlertHelper = PasswordAlertHelper()
        passwordAlertHelper.delegate = self
    }
    
    func setSettingsRealmModel() {
        let settingsRealmModel: Results<SettingsRealmModel> = RealmManager.shared.fetch()
        guard let realmModel = settingsRealmModel.first else {
            userSettingsModel = SettingsModel()
            return
        }
        userSettingsModel = SettingsModel(realmModel: realmModel)
        table.isHidden = realmModel.isLocked ? true : false
        addButton.isEnabled = realmModel.isLocked ? false : true
        lockedNotesStackView.isHidden = realmModel.isLocked ? false : true
    }
    
    private func showNote() {
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.noteView.alpha = 1
            self.noteTextView.alpha = 1
        }
    }
    
    private func hideNote() {
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 0
            self.noteView.alpha = 0
            self.noteTextView.alpha = 0
        }
    }
    
    @IBAction func closeNote(_ sender: UIButton) {
        let formatedText = noteTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        hideNote()
        if formatedText == "" {
            return
        }
        if sender.accessibilityLabel == "add" {
            newsModel?.notes?.append(formatedText)
            RealmManager.shared.addNote(newsModel, text: formatedText)
        } else {
            newsModel?.notes?[sender.tag] = formatedText
            RealmManager.shared.updateNote(newsModel, text: formatedText, index: sender.tag)
        }
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        closeButton.accessibilityLabel = "add"
        noteTextView.text = ""
        showNote()
    }
    
    @IBAction func dismissViewController(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unlockNotes(_ sender: UIButton) {
        passwordAlertHelper.unlockNote(userSettingsModel?.isLocked ?? false)
    }
}

//MARK: - UITableViewDataSource
extension FavouriteNotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = newsModel?.notes?.count else { return 0 }
        return items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIndetifier, for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        let noteText = newsModel?.notes?[indexPath.row]
        cell.set(noteText)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FavouriteNotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteText = newsModel?.notes?[indexPath.row]
        noteTextView.text = noteText
        closeButton.tag = indexPath.row
        closeButton.accessibilityLabel = nil
        showNote()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cellNewsModel = newsModel else { return nil }
        let noteIndex = indexPath.row
        let deleteNoteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] action, view, completion in
            guard let self = self else { return }
            RealmManager.shared.deleteNote(cellNewsModel, index: indexPath.row)
            self.newsModel?.notes?.remove(at: noteIndex)
            self.table.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        deleteNoteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteNoteAction])
    }
}
