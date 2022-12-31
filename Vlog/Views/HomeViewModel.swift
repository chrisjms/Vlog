//
//  HomeViewModel.swift
//  Vlog
//
//  Created by Christopher James on 29/09/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit

class HomeViewModel: ObservableObject {
    
    @Published var isBlogPresented = false
    @Published var alertMessage = ""
    @Published var isAlertpresented = false
    @Published var selectedImage: UIImage?
    @Published var user: User
    @Published var blogsList = [Blog]()
    @Published var isPopUpBlogPresented: Bool = false
    @Published var newTitle: String = ""
    
    init(currentUser: User) {
        self.user = currentUser
    }
    
    func fetchBlog() {
        let db = Firestore.firestore()
        db.collection("blogs").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var path = String()
                for documents in snapshot!.documents {
                    path = documents["previewImage"] as! String
                    let storageRef = Storage.storage().reference()
                    let imageRef = storageRef.child(path)
                    imageRef.getData(maxSize: 20 * 1024 * 1024) { data, error in
                        if error != nil || data == nil {
                            self.isAlertpresented = true
                            self.alertMessage = error.debugDescription
                        } else {
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    self.blogsList.append(Blog(title: documents["title"] as! String, date: documents["date"] as! String, image: image, id: documents.documentID, imagePath: path, textContent: documents["textContent"] as! String))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addNewBlog() {
        guard selectedImage != nil && newTitle != "" else {
            return
        }
        let storageRef = Storage.storage().reference()
        let imageData = self.selectedImage!.pngData()
        guard imageData != nil else {
            return
        }
        let path = "Images/\(UUID().uuidString).png"
        let fileRef = storageRef.child(path)
        fileRef.putData(imageData!,metadata: nil) { metadata, error in
            if error ==  nil && metadata != nil {
                let db = Firestore.firestore()
                let id = UUID().uuidString
                db.collection("previews").document(id).setData(["title": self.newTitle, "image": path, "date": "Par christopher | \(self.setDate())"])
                self.blogsList.append(Blog(title: self.newTitle, date: "Par Christopher | \(self.setDate())", image: self.selectedImage!, id: id, imagePath: path, textContent: ""))
            }
        }
        self.isPopUpBlogPresented = false
    }
    
    func setDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        return formatter.string(from: currentDateTime)
    }
    
    func deleteBlog(blog: Blog) {
        let db = Firestore.firestore()
        print(blog.id)
        db.collection("previews").document(blog.id).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                let storageRef = Storage.storage().reference()
                let imageRef = storageRef.child("\(blog.imagePath)")
                imageRef.delete { error in
                  if let error = error {
                    print("Error deleting storage image")
                  } else {
                      print("storage image deleted successfully")
                  }
                }
            }
        }
    }
    
    func deconnexion() {
        do {
            try Auth.auth().signOut()
            self.user.isConnected = false
            self.user.mail = ""
            self.user.lastName = ""
            self.user.firstName = ""
            self.user.password = ""
        } catch let error {
            self.alertMessage = error.localizedDescription
            self.isAlertpresented = true
        }
    }
    
}
