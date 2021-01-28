import UIKit

extension SceneDelegate: AuthFirebaseDelegate {
    func authSignIn() {
        guard let window = self.window else { return }
        let newsViewController = NewsViewController()
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        let filterViewController = FilterViewController()
        let bookmarksViewController = BookmarksViewController()
//        let bookmarksViewController = UINavigationController(rootViewController: BookmarksViewController())
        
        newsViewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "news"), selectedImage: nil)
        filterViewController.tabBarItem = UITabBarItem(title: "Filter", image: UIImage(named: "filter") , selectedImage: nil)
        bookmarksViewController.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), selectedImage: nil)
        navigationController.viewControllers = [newsViewController]
        
        tabBarController.viewControllers = [navigationController, filterViewController, bookmarksViewController]
        window.rootViewController = tabBarController
        
        UIView.transition(with: window,
                          duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
    }
    
    func authSignOut() {
        guard let window = self.window else { return }
        let startViewController = StartViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [startViewController]
        window.rootViewController = navigationController
        
        UIView.transition(with: window,
                          duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
    }
}
