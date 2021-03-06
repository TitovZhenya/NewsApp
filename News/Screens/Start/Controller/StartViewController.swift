import UIKit
import CoreLocation

class StartViewController: UIViewController {
    
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseManager.shared.getSignInUser()
        setUpElements()
        checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utilities.shared.animateButton(signInButton)
        Utilities.shared.animateButton(signUpButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    private func setUpElements () {
        Utilities.shared.styleMainVCButton(signInButton, tag: 0)
        Utilities.shared.styleMainVCButton(signUpButton, tag: 1)
    }
    
    @IBAction private func pressedButton(_ sender: UIButton){
        switch sender.tag {
        case StartButton.SignIn.rawValue:
            let signInVC = SignInViewController()
            self.navigationController?.pushViewController(signInVC, animated: true)
        case StartButton.SignUp.rawValue:
            let signUpVC = SignUpViewController()
            self.navigationController?.pushViewController(signUpVC, animated: true)
        default:
            return
        }
    }
}
