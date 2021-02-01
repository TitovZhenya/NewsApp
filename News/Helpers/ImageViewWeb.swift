import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageViewWeb: UIImageView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func setImage(from url: String) {
        image = nil
        addActivityIndicator()
        
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            image = cachedImage
            activityIndicator.removeFromSuperview()
            return
        }
        
        RequestHandler(hostUrl: url).getImage { [weak self] result in
            guard let self = self, let image = UIImage(data: result) else { return }
            imageCache.setObject(image, forKey: url as AnyObject)
            
            self.image = image
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    private func addActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
