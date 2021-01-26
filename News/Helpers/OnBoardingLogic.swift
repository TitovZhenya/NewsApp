import UIKit

class OnBoardingLogic {
    
    static let shared = OnBoardingLogic()

    private init() {}
    
    private let userDefaultsKey = "isNewUser"
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: userDefaultsKey)
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: userDefaultsKey)
    }
}
