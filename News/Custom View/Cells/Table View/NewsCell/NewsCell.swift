import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var newsImageView: ImageViewWeb!
    @IBOutlet private weak var newsCardView: UIView!
    
    weak var delegate: NewsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setUpElements()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsImageView.isHidden = true
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
        descriptionLabel.text = newsModel?.description
        dateLabel.text = newsModel?.publishedAt
        
        if let stringUrl = newsModel?.urlToImage {
            newsImageView.setImage(from: stringUrl)
            newsImageView.isHidden = false
        } else {
            newsImageView.isHidden = true
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        delegate?.newsCellNewsShare(self, sender: sender)
    }
    
}
