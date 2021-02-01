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
        }
    }
        
    private func textFieldDelegate(_ textField: UITextField){
        textField.delegate = self
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
