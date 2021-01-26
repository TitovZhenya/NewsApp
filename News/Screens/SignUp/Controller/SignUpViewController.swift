import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet var userInfoViews: [UIView]!
    @IBOutlet private var textFields: [UITextField]!


    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        addKeyboardObserver()
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpElements() {
        Utilities.shared.styleAuthButton(signUpButton)
        Utilities.shared.styleTextFild(firstNameTextField, placehoder: "First name")
        Utilities.shared.styleTextFild(lastNameTextField, placehoder: "Last name")
        Utilities.shared.styleTextFild(emailTextField, placehoder: "Email")
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
    
    private func fieldsValidation() -> String? {
        
        if Utilities.shared.isFieldsEmpty(textFields) {
            return "Fill all fields"
        }

        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !Utilities.shared.isEmailCorrect(email) {
            return "Wrong email"
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !Utilities.shared.isPasswordCorrect(password) {
            return "Password must contains one big letter, one number and is minimum seven char long"
        }
                
    
        return nil
    }
    
    //MARK: IBActions
    @IBAction func signUpAction(_ sender: Any) {
        let error = fieldsValidation()
        if error != nil {
            Utilities.shared.showErrorMessage(on: errorLabel, message: error!)
        } else {
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            FirebaseManager.shared.addUser(firstName: firstName, lastName: lastName, email: email, password: password) { [weak self] error in
                guard let errorMessage = error?.localizedDescription else { return }
                Utilities.shared.showErrorMessage(on: self!.errorLabel, message: errorMessage)
            }
            
        }
    }
}
