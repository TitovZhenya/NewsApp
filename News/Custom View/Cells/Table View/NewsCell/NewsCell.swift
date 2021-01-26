import UIKit
import Kingfisher

class NewsCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsCardView: UIView!
    
    weak var delegate: NewsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setUpElements()
    }
    
    private func setUpElements() {
        backgroundColor = .clear
        selectionStyle = .none
        newsImageView.layer.cornerRadius = 13
        newsCardView.layer.cornerRadius = 13
        newsCardView.clipsToBounds = true
    }
    
    func set(newsModel: News.Item?) {
        titleLabel.text = newsModel?.title
        descriptionLabel.text = newsModel?.description?.htmlToString
        dateLabel.text = newsModel?.publishedAt
        
        if let stringUrl = newsModel?.urlToImage, let url = URL(string: stringUrl) {
            newsImageView.kf.setImage(with: url,
                                      placeholder: nil,
                                      options: [
                                        .loadDiskFileSynchronously,
                                        .cacheOriginalImage
                                      ],
                                      completionHandler: nil)
            newsImageView.isHidden = false
        } else {
            newsImageView.isHidden = true
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        delegate?.newsCellNewsShare(self, sender: sender)
    }
    
}
