import UIKit

class OnBoardingPageViewController: UIPageViewController {
    
    private var myViewControllers = [UIViewController]()
    
    private var pageControl = UIPageControl()
    private var currentPage = 0
    
    weak var didFinishedDelegate: OnBoardingPageViewDelegate?
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpPageControl()
    }

    private func setUpElements() {
        self.dataSource = self
        self.delegate = self
        
        let OnBoardingFirstVC = OnBoardingFirstViewController()
        let OnBoardingSecondVC = OnBoardingSecondViewController()
        OnBoardingFirstVC.delegate = self
        OnBoardingSecondVC.delegate = self
        
        myViewControllers.append(OnBoardingFirstVC)
        myViewControllers.append(OnBoardingSecondVC)
        
        setViewControllers([OnBoardingFirstVC], direction: .forward, animated: true, completion: nil)
    }
    
    private func setUpPageControl() {
        pageControl.frame = CGRect(x: 0, y: view.bounds.maxY - 50, width: view.bounds.size.width, height: 28)
        pageControl.numberOfPages = myViewControllers.count
        view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageControlAction), for: .valueChanged)
    }
    
    @objc private func pageControlAction(_ sender: UIPageControl) {
        if currentPage < sender.currentPage {
            let displayViewController = myViewControllers[sender.currentPage]
            setViewControllers([displayViewController], direction: .forward, animated: true, completion: nil)
            currentPage = myViewControllers.firstIndex(of: displayViewController)!
        } else {
            let displayViewController = myViewControllers[sender.currentPage]
            setViewControllers([myViewControllers[sender.currentPage]], direction: .reverse, animated: true, completion: nil)
            currentPage = myViewControllers.firstIndex(of: displayViewController)!
        }
    }
}

//MARK: - UIPageViewControllerDataSource
extension OnBoardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = myViewControllers.firstIndex(of: viewController), viewControllerIndex > 0 else {
            return nil
        }
        let previousViewController = viewControllerIndex - 1
        return myViewControllers[previousViewController]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = myViewControllers.firstIndex(of: viewController), viewControllerIndex < (myViewControllers.count - 1) else {
            return nil
        }
        let nextViewController = viewControllerIndex + 1
        return myViewControllers[nextViewController]
    }
}

//MARK: - UIPageViewControllerDelegate
extension OnBoardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        let viewController = viewControllers[0]
        currentPage = myViewControllers.firstIndex(of: viewController)!
        pageControl.currentPage = currentPage
    }
}
