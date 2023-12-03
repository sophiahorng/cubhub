//
//  SQLDatabaseManager.swift
//  teamhungary
//
//  Created by Sophia Horng on 12/1/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class FirebaseUtilities {
    
    static func uploadProfilePicture(_ imageURL: URL?, userID: String) {
        guard let imageURL = imageURL else {
            print("Error: Profile picture URL is nil")
            return
        }

        let storageRef = Storage.storage().reference()
        let profilePictureRef = storageRef.child("profilePictures/\(userID).jpg")

        if let imageData = try? Data(contentsOf: imageURL) {
            profilePictureRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("Error uploading profile picture: \(error.localizedDescription)")
                } else {
                    // Get the download URL and save it to Firestore
                    profilePictureRef.downloadURL { url, error in
                        guard let downloadURL = url, error == nil else {
                            print("Error getting download URL: \(error?.localizedDescription ?? "")")
                            return
                        }
                        saveProfilePictureURL(downloadURL.absoluteString, for: userID)
                    }
                }
            }
        } else {
            print("Error: Unable to convert image URL to data")
        }
    }

    
    static func saveProfilePictureURL(_ url: String, for userID: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        userRef.updateData(["profilePictureURL": url]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Profile picture URL updated successfully!")
            }
        }
    }

    
    static func retrieveProfilePictureURL(for userID: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let profilePictureURL = document.get("profilePictureURL") as? String
                completion(profilePictureURL)
            } else {
                print("Document does not exist or there was an error: \(error?.localizedDescription ?? "")")
                completion(nil)
            }
        }
    }

    static func addUsertoFirestore(uid: String, name: String, email: String, profilePic: String, displayName: String?) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)

        var userData: [String: Any] = [
            "name": "",
            "email": email,
            "graduation_year": "",
            "school": "",
            
        ]

        if let displayName = displayName {
            userData["displayName"] = displayName
        }

        userRef.setData(userData) { error in
            if let error = error {
                print("Error adding user to Firestore: \(error.localizedDescription)")
            } else {
                print("User added to Firestore successfully!")
            }
        }
    }
    
}
//import SQLite
//
//class DatabaseManager {
//    static let shared = DatabaseManager()
//
//    private var db: Connection?
//
//    private init() {
//        do {
//            // Initialize the SQLite database connection
//            let path = try FileManager.default
//                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//                .appendingPathComponent("your_database.sqlite3")
//                .path
//
//            db = try Connection(path)
//
//                // Call methods to create tables or perform any other setup
//            try createTables()
//        } catch {
//            print("Error initializing database: \(error)")
//        }
//    }
//
//    private func createTables() throws {
//        // Implement table creation logic here
//        let users = Table("users")
//        let id = Expression<Int>("id")
//        let name = Expression<String>("name")
//        let email = Expression<String>("email")
//        let gradyear = Expression<String>("graduation_year")
//        let school = Expression<String>("school")
//        let iguser = Expression<String>("instagram_username")
//        let pfPicPath = Expression<String?>("profile_picture_path")
//
//        try db?.run(users.create { table in
//            table.column(id, primaryKey: .autoincrement)
//            table.column(name)
//            table.column(email, unique: true)
//            table.column(gradyear, check: gradyear.like("20[2-9][0-9]"))
//            table.column(school)
//            table.column(iguser)
//            table.column(pfPicPath)
//        })
//    }
//}
