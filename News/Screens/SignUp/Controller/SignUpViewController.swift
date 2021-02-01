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
        }
    }
    
    private func textFieldDelegate(_ textField: UITextField){
        textField.delegate = self
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
