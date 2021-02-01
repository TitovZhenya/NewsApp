import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        FirebaseManager.shared.delegate = self
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if OnBoardingLogic.shared.isNewUser() {
            let onBoardingPageViewController = OnBoardingPageViewController()
            onBoardingPageViewController.didFinishedDelegate = self
            window?.rootViewController = onBoardingPageViewController
        } else {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [StartViewController()]
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
    }
}

