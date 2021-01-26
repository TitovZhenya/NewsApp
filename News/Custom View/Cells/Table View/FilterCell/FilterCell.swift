import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet private weak var filterLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpElements()

    }

    private func setUpElements() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func set(filterModel: Filter.Item?) {
        filterLabel.text = filterModel?.name
    }
}
