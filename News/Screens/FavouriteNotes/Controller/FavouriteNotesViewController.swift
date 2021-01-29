import UIKit

class FavouriteNotesViewController: UIViewController {
    
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    private func setUpElements() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    @IBAction func dismissController(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDataSource
extension FavouriteNotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

//MARK: - UITableViewDelegate
extension FavouriteNotesViewController: UITableViewDelegate {
    
}
