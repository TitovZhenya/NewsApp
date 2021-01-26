import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageViewWeb: UIImageView {
    
    func setImage(from url: String) {
        image = nil

        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        RequestHandler(hostUrl: url).getImage { [weak self] result in
            guard let self = self, let image = UIImage(data: result) else { return }
            imageCache.setObject(image, forKey: url as AnyObject)
            
            self.image = image
        }
    }
}
