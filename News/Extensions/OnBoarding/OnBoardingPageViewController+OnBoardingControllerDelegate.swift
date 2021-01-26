import UIKit

extension OnBoardingPageViewController: OnBoardingControllerDelegate {
    func onBoardingControllerGetStarted() {
        didFinishedDelegate?.onBoardingPageDidFinished()
    }
}
