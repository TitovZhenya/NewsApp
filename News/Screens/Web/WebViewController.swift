import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var toolBar: UIToolbar!    
    private var observation: NSKeyValueObservation?

    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpElements()
        self.setUpObservation()
        self.loadRequest()
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
    
    func loadRequest() {
        guard let url = self.url else { return }
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    @IBAction func dismissViewAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        guard let url = url else { return }
        let shareVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = toolBar
        shareVC.popoverPresentationController?.barButtonItem = sender
        present(shareVC, animated: true)
    }
}
