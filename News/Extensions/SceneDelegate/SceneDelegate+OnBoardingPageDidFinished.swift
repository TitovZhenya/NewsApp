import UIKit

extension SceneDelegate: OnBoardingPageViewDelegate {
    func onBoardingPageDidFinished() {
        guard let window = self.window else { return }
        let navigationController = UINavigationController()
        navigationController.viewControllers = [StartViewController()]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
    }
}
