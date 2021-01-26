import UIKit

class LinearGradient: UIView {
    
    private let gradient = CAGradientLayer()
    
    @IBInspectable private var startColor: UIColor? {
        didSet {
            addGradientColors()
        }
    }
    
    @IBInspectable private var betweenColor: UIColor? {
        didSet {
            addGradientColors()
        }
    }
    
    @IBInspectable private var endColor: UIColor? {
        didSet {
            addGradientColors()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLinearGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    
    private func setLinearGradient() {
        self.layer.addSublayer(gradient)
        addGradientColors()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
    }

    private func addGradientColors() {
        guard let startColor = startColor,
              let betweenColor = betweenColor,
              let endColor = endColor
        else {
            return
        }
        gradient.colors = [startColor.cgColor, betweenColor.cgColor, endColor.cgColor]
    }
}
