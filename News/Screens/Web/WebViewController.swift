import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var toolBar: UIToolbar!
    @IBOutlet private weak var favouritesButton: UIBarButtonItem!
    
    var lastOffsetY: CGFloat = 0
    
    private var observation: NSKeyValueObservation?
    
    private var newsModel: News.Item?
    
    convenience init(_ model: News.Item?) {
        self.init()
        self.newsModel = model
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpObservation()
        loadRequest()
        setFavouritesImage()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    deinit {
        self.observation?.invalidate()
    }
    
    private func setUpElements() {
        self.activityIndicator.hidesWhenStopped = true
    }
    
    private func setUpObservation() {
        self.observation = self.webView.observe(\.isLoading, options: .new) { [weak self] webView, change in
            guard let self = self, let isLoading = change.newValue else { return }
            
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    private func loadRequest() {
        guard let urlString = newsModel?.url,
              let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedString) else { return }
        
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    private func setFavouritesImage() {
        guard let url = newsModel?.url else { return }
        if RealmManager.shared.findRealmObject(by: url) != nil {
            favouritesButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            favouritesButton.image = UIImage(systemName: "bookmark")
        }
    }
    
    @IBAction func dismissViewAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        guard let urlString = newsModel?.url, let url = URL(string: urlString) else { return }
        let shareVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = toolBar
        shareVC.popoverPresentationController?.barButtonItem = sender
        present(shareVC, animated: true)
    }
    
    @IBAction func addToFavouritesAction(_ sender: UIBarButtonItem) {
        guard let url = newsModel?.url else { return }
        if RealmManager.shared.findRealmObject(by: url) != nil {
            RealmManager.shared.delete(objectField: url)
        } else {
            RealmManager.shared.write(newsModel)
        }
        setFavouritesImage()
    }
    
    @IBAction func goBackAction(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func goForwardAction(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
}
