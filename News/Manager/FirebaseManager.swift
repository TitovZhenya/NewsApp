import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    private init() {}
    
    static let shared = FirebaseManager()
    private var userId = ""
    
    weak var delegate: AuthFirebaseDelegate?
    
    func addUser(firstName: String, lastName: String, email: String, password: String, _ closure: @escaping ((Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            if error != nil {
                closure(error)
            } else {
                let db = Firestore.firestore()
                self.userId = result!.user.uid
                db.collection("users")
                    .document(self.userId)
                    .setData(["firstName" : firstName,
                              "lastName" : lastName,
                              "email" : email,
                              "uid" : result!.user.uid]) { error in
                    if error != nil {
                        closure(error)
                    }
                }
                self.delegate?.authSignIn()
            }
        }
    }
    
    func signIn(email: String, password: String, _ closure: @escaping ((Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            if error != nil {
                closure(error)
            } else {
                self.userId = result!.user.uid
                self.delegate?.authSignIn()
            }
        }
    }
    
    func getSignInUser() {
        Auth.auth().addStateDidChangeListener {[weak self] (result, user) in
            guard let self = self else { return }
            if user != nil {
                self.userId = result.currentUser!.uid
                self.delegate?.authSignIn()
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.delegate?.authSignOut()
    }
    
    func getUserId() -> String {
        return userId
    }
}
