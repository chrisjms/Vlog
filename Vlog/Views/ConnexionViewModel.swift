//
//  ConnexionViewModel.swift
//  Vlog
//
//  Created by Christopher James on 25/09/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ConnexionViewModel: ObservableObject {
    
    @Published var alertMessage = ""
    @Published var isAlertpresented = false
    @Published var isRegistrationPresented: Bool = false
    @Published var isSubscriptionPresented: Bool = false
    @Published var user: User!
    @Published var newUserFirstName: String = ""
    @Published var newUserLastName: String = ""
    @Published var newMail: String = ""
    @Published var newPassword: String = ""
    @Published var goToHome: Bool = false
    @Published var userAdmin : User = User(lastName: "testLast", firstName: "test", mail: "test@mail.com", password: "tesst", isConnected: false, profile: .admin)
    
    init() {
        self.user = User(lastName: "", firstName: "", mail: "", password: "", isConnected: false, profile: .subscriber)
    }
    
    func signUp(newMail: String, newPassword: String) {
        if (newMail != "" && newPassword != "") {
            Auth.auth().createUser(withEmail: newMail, password: newPassword) { (authResult, error) in
                if (error != nil) {
                    self.alertMessage = error!.localizedDescription
                    self.isAlertpresented = true
                } else {
                    let db = Firestore.firestore()
                    let userId = Auth.auth().currentUser?.uid
                    db.collection("users").document(userId!).setData(["firstName": self.newUserFirstName, "lastName": self.newUserLastName, "subscribed": true])
                    self.newUserFirstName = ""
                    self.newUserLastName = ""
                    self.newMail = ""
                    self.newPassword = ""
                    self.isRegistrationPresented.toggle()
                }
            }
        }
    }
    
    func logIn(mail: String, password: String) {
        if (mail != "" && password != "") {
            Auth.auth().signIn(withEmail: mail, password: password) { (authResult, error) in
                if (error != nil) {
                    self.alertMessage = error!.localizedDescription
                    self.isAlertpresented = true
                } else {
                    if (mail == "Alice@mail.com" && password == "alicee") {
                        self.user.profile = .admin
                        self.user.firstName = "Alice"
                        self.user.lastName = "Pheulpin"
                        self.isSubscriptionPresented = false
                    } else {
                        self.setUserInformations()
                        self.isSubscriptionPresented = false
                    }
                    self.user.isConnected = true
                    self.user.mail = mail
                    self.user.password = password
                    self.goToHome.toggle()
                }
            }
        }
    }
    
    func setUserInformations() {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid
        db.collection("users").document(userId!).getDocument { snapshot, error in
            if error == nil && snapshot != nil {
                //self.user.subcribed = snapshot!["subscribed"] as! Bool
                self.user.firstName = snapshot!["firstName"] as! String
                self.user.lastName = snapshot!["lastName"] as! String
            }
        }
    }
    
}
