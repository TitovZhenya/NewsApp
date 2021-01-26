import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    private init() {}
    
    static let shared = FirebaseManager()
    
    private var currentUser = ""
    
    weak var delegate: AuthFirebaseDelegate?
    
    func addUser(firstName: String, lastName: String, email: String, password: String, _ closure: @escaping ((Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            if error != nil {
                closure(error)
            } else {
                let db = Firestore.firestore()
                self.currentUser = result!.user.uid
                db.collection("users").document(self.currentUser).setData(["firstName" : firstName,
                                                              "lastName" : lastName,
                                                              "email" : email,
                                                              "uid" : result!.user.uid])
//                db.collection("users").addDocument(data: ["firstName" : firstName,
//                                                          "lastName" : lastName,
//                                                          "email" : email,
//                                                          "uid" : result!.user.uid]) { [weak self] (error) in
//                    if error != nil {
//                        closure(error)
//                    } else {
//                        self?.delegate?.authSignIn()
//                    }
//                }
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
                self.delegate?.authSignIn()
            }
        }
    }
    
    func getSignInUser() {
        Auth.auth().addStateDidChangeListener {[weak self] (result, user) in
            if user != nil {
                self?.currentUser = result.currentUser!.uid
                self?.delegate?.authSignIn()
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.delegate?.authSignOut()
    }
    
    func setToFavourites() {
//        let db = Firestore.firestore()
//        Add to favourites
//        db.collection("users").document(self.currentUser).updateData(["hello" : ["Any" : "asd"]])
    }
}
