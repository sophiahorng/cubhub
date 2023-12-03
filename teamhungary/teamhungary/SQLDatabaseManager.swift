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

    static func addUsertoFirestore(uni: String, name: String, email: String, graduationYear: String = "", school: String = "", igProfile: String = "",  profilePic: String = "") {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uni)

        var userInfo: [String: Any] = [
            "name": name,
            "email": email,
            "graduation_year": graduationYear,
            "school": school,
            "ig_profile": igProfile,
            "profile_pic": profilePic
        ]

//        userInfo["displayName"] = name

        userRef.setData(userInfo) { error in
            if let error = error {
                print("Error adding user to Firestore: \(error.localizedDescription)")
            } else {
                print("User added to Firestore successfully!")
            }
        }
    }
    
    static func addEventToFirestore(uid: String, name: String, datetime: Timestamp, address: String = "", locationName: String = "", lat: Double = 0.0, lon: Double = 0.0, attendees: [String] = []) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(uid)

        var eventInfo: [String: Any] = [
            "name": name,
            "date_time": datetime,
            "address": address,
            "location_name": locationName,
            "lat": lat,
            "lon": lon
        ]

        // Set the attendees field
        eventInfo["attendees"] = attendees

        eventRef.setData(eventInfo) { error in
            if let error = error {
                print("Error adding event to Firestore: \(error.localizedDescription)")
            } else {
                print("Event added to Firestore successfully!")

                // Add attendees to the subcollection
                for attendeeID in attendees {
                    addAttendeeToEvent(eventID: uid, userID: attendeeID)
                }
            }
        }
    }

    static func addAttendeeToEvent(eventID: String, userID: String) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        let attendeesCollectionRef = eventRef.collection("attendees")
        
        let attendeeData: [String: Any] = [
            "userRef": db.collection("users").document(userID)
        ]

        attendeesCollectionRef.addDocument(data: attendeeData) { error in
            if let error = error {
                print("Error adding attendee to event subcollection: \(error.localizedDescription)")
            } else {
                print("Attendee added to event subcollection successfully!")
            }
        }
    }

    static func deleteEventFromFirestore(eventID: String) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        
        eventRef.delete { error in
            if let error = error {
                print("Error deleting event from Firestore: \(error.localizedDescription)")
            } else {
                print("Event deleted from Firestore successfully!")
                
                // Delete attendees from the subcollection
                deleteAttendeesFromEvent(eventID: eventID)
            }
        }
    }
    
    static func deleteAttendeeFromEvent(eventID: String, attendeeID: String) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        let attendeesCollectionRef = eventRef.collection("attendees")

        let attendeeRef = attendeesCollectionRef.document(attendeeID)

        attendeeRef.delete { error in
            if let error = error {
                print("Error deleting attendee from event subcollection: \(error.localizedDescription)")
            } else {
                print("Attendee deleted from event subcollection successfully!")
            }
        }
    }
//    static func updateAttendeesInEvent(eventID: String, attendees: [String]) {
//        let db = Firestore.firestore()
//        let eventRef = db.collection("events").document(eventID)
//        let attendeesCollectionRef = eventRef.collection("attendees")
//
//        // Clear existing attendees
//        attendeesCollectionRef.getDocuments { snapshot, error in
//            if let error = error {
//                print("Error getting existing attendees: \(error.localizedDescription)")
//            } else {
//                for document in snapshot?.documents ?? [] {
//                    document.reference.delete()
//                }
//                    // Add updated attendees
//                for attendeeID in attendees {
//                    addAttendeeToEvent(eventID: eventID, userID: attendeeID)
//                }
//            }
//        }
//    }
    
    
    static func deleteAttendeesFromEvent(eventID: String) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        let attendeesCollectionRef = eventRef.collection("attendees")
            // Delete all documents in the attendees subcollection
        attendeesCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting attendees for deletion: \(error.localizedDescription)")
            } else {
                for document in snapshot?.documents ?? [] {
                    document.reference.delete()
                }
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
