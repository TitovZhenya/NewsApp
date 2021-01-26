import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak private var loginTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var loginBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet private var textFields: [UITextField]!
    @IBOutlet var userInfoViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        addKeyboardObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpElements() {        
        Utilities.shared.styleAuthButton(loginBtn)
        Utilities.shared.styleTextFild(loginTextField, placehoder: "Email")
        Utilities.shared.styleTextFild(passwordTextField, placehoder: "Password")

        for view in userInfoViews {
            Utilities.shared.styleInputView(view)
        }
        
        for textField in textFields {
            textFieldDelegate(textField)
            textField.addDoneButton()
        }
    }
        
    private func textFieldDelegate(_ textField: UITextField){
        textField.delegate = self
    }
    
    //MARK: work with keyboard obserkver
    private func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillChange(notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == UIResponder.keyboardDidShowNotification{
            (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width,
                                                              height: self.view.bounds.size.height + kbFrameSize.height / 2)
            (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height - 50, right: 0)
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let size = self?.view.bounds.size else { return }
                (self?.view as! UIScrollView).contentSize = CGSize(width: size.width,
                                                                  height: size.height - kbFrameSize.height / 2)
            }
        }
    }
    
    //MARK: IBActions
    @IBAction func loginAction(_ sender: Any) {
        if Utilities.shared.isFieldsEmpty(textFields) {
            Utilities.shared.showErrorMessage(on: errorLabel, message: "Fill all fields")
        } else {
            let email = loginTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            FirebaseManager.shared.signIn(email: email, password: password) { [weak self] error in
                guard let errorMessage = error?.localizedDescription else { return }
                Utilities.shared.showErrorMessage(on: self!.errorLabel, message: errorMessage)
            }
    
        }

    }
}
