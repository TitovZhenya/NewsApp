import UIKit

class OnBoardingFirstViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLable: UILabel!
    
    weak var delegate: OnBoardingControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func getStartedAction(_ sender: UIButton) {
        OnBoardingLogic.shared.setIsNotNewUser()
        delegate?.onBoardingControllerGetStarted()
    }
}
