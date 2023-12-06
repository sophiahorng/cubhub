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
    static func uploadProfilePicture(imageData: UIImage, userID: String, completion: @escaping (URL?) -> Void) {
        print("uploading profile picture")
        let storage = Storage.storage()
        // Adjust the path to create a user-specific folder
        let storageRef = storage.reference().child("\(userID)/profilePicture.jpg")
        // Upload image data to Firebase Storage
        if let image = imageData.jpegData(compressionQuality: 0.5) {
            storageRef.putData(image, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    print("data writing error")
                    return
                }
                print("data written successfully")
            }
            // Metadata contains file metadata such as size, content-type.
            //          let _size = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard url != nil else {
                    print("downloadURL error: \(String(describing: error))")
                    completion(nil)
                    return
                }
                print("downloadURL returned successfully")
                completion(url)
            }
        }
        return
    }
    //        storageRef.putData(imageData, metadata: nil) { metadata, error in
    //            if let error = error {
    //                print("Error uploading image to Firebase Storage: \(error.localizedDescription)")
    //                completion(nil)
    //                return
    //            }
    //
    //            // Get the download URL
    //            storageRef.downloadURL { url, error in
    //                if let downloadURL = url {
    //                    print("Image uploaded successfully. Download URL: \(downloadURL)")
    //                    completion(downloadURL.absoluteString)
    //                } else {
    //                    print("Error getting download URL: \(error?.localizedDescription ?? "")")
    //                    completion(nil)
    //                }
    //            }
    //        }
    //    }
    
    static func saveProfilePictureURL(_ url: URL, for userID: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        userRef.updateData(["profilePictureURL": url.absoluteString]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
                completion(nil)
            } else {
                print("Profile picture URL updated successfully!")
                completion(url.absoluteString)
            }
        }
        return
    }
    
    static func retrieveProfilePicture(for userID: String, completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        // Adjust the path to create a user-specific folder
        let storageRef = storage.reference().child("/\(userID)/profilePicture.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
                print("error getting profile pic URL")
                completion(nil)
            } else {
                let image = UIImage(data: data!)
                completion(image)
            }
        }
        return
    }
    
    static func uploadEventPhoto(imageData: UIImage, eventID: String, completion: @escaping (URL?) -> Void) {
        print("uploading event photo")
        let storage = Storage.storage()
        // Adjust the path to create a user-specific folder
        let photoId = UUID().uuidString
        let storageRef = storage.reference().child("\(eventID)/\(photoId).jpg")
        // Upload image data to Firebase Storage
        if let image = imageData.jpegData(compressionQuality: 0.5) {
            storageRef.putData(image, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    print("data writing error")
                    return
                }
                print("data written successfully")
            }
            // Metadata contains file metadata such as size, content-type.
            //          let _size = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard url != nil else {
                    print("downloadURL error: \(String(describing: error))")
                    completion(nil)
                    return
                }
                print("downloadURL returned successfully")
                completion(url)
            }
        }
        return
    }
    
    static func retrieveEventPhotos(eventID: String, completion: @escaping ([UIImage]?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(eventID)

        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error in listing files: \(error)")
                completion(nil)
                return
            }

            var images = [UIImage]()
            let group = DispatchGroup()
            if let result = result {
                for item in result.items {
                    group.enter()
                    item.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("Error downloading image: \(error)")
                        } else if let data = data, let image = UIImage(data: data) {
                            images.append(image)
                        }
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                completion(images)
            }
        }
    }

    //        let userRef = db.collection("users").document(userID)
    //
    //        userRef.getDocument { document, error in
    //            if let document = document, document.exists {
    //                let profilePictureURL = document.get("profilePictureURL") as? String
    //                completion(profilePictureURL)
    //            } else {
    //                print("Document does not exist or there was an error: \(error?.localizedDescription ?? "")")
    //                completion(nil)
    //            }
    //        }
    //    }
    static func addUsertoFirestore(uid: String, name: String, email: String, graduationYear: String = "", school: String = "", bio: String = "", igProfile: String = "",  profilePic: String = "", completion: @escaping (Bool, Error?) -> Void) {
        if email.suffix(13) != "@columbia.edu" {
            print("User is not in Columbia domain")
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        let userInfo: [String: Any] = [
            "name": name,
            "email": email,
            "graduation_year": graduationYear,
            "school": school,
            "bio": bio,
            "ig_profile": igProfile,
            "profile_pic": profilePic
        ]
        userRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                print("User already exists in database")
                return
            } else {
                userRef.setData(userInfo) { error in
                    if let error = error {
                        print("Error adding user to Firestore: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("User added to Firestore successfully!")
                        completion(true, nil)
                    }
                }
            }
        }
        return
        //        userInfo["displayName"] = name
        
    }
    static func updateUserInFirestore(uid: String, name: String? = nil, email: String? = nil, graduationYear: String? = nil, school: String? = nil, bio: String? = nil, igProfile: String? = nil, profilePic: String? = nil) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        // Prepare the data to update
        var updateData: [String: Any] = [:]
        if let name = name {
            updateData["name"] = name
        }
        if let email = email, email.suffix(13) == "@columbia.edu" {
            updateData["email"] = email
        }
        if let graduationYear = graduationYear {
            updateData["graduation_year"] = graduationYear
        }
        if let bio = bio {
            updateData["bio"] = bio
        }
        if let school = school {
            updateData["school"] = school
        }
        if let igProfile = igProfile {
            updateData["ig_profile"] = igProfile
        }
        if let profilePic = profilePic {
            updateData["profile_pic"] = profilePic
        }
        // Proceed with the update if there's any data to update
        if !updateData.isEmpty {
            userRef.updateData(updateData) { error in
                if let error = error {
                    print("Error updating user in Firestore: \(error.localizedDescription)")
                } else {
                    print("User updated in Firestore successfully!")
                }
            }
        } else {
            print("No data provided for update")
        }
        return
    }
    static func addEventToFirestore(event: Event, image: UIImage? = nil) {
        
        // image upload
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(event.id)/event.jpg")
        if let imageData = image?.jpegData(compressionQuality: 0.5) {
            storageRef.putData(imageData)
            
        }
        
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(event.id)
        let eventInfo: [String: Any] = [
            "name": event.eventName,
            "date_time": event.eventDate,
            "address": event.eventAddress,
            "location_name": event.eventLocation,
            "lat": event.eventLat,
            "lon": event.eventLon,
            "ownerID": event.eventOwner,
            "attendees": [event.eventOwner],
            "description": event.eventDescription
        ]
        eventRef.setData(eventInfo) { error in
            if let error = error {
                print("Error adding event to Firestore: \(error.localizedDescription)")
            } else {
                print("Event added to Firestore successfully!")
                // Add attendees to the subcollection
                for attendeeID in event.attendees {
                    addAttendeeToEvent(eventID: event.id, userID: attendeeID)
                }
            }
        }
        return
    }
    static func updateEventInFirestore(eventID: String, updatedEventName: String? = nil, updatedEventDate: String? = nil, updatedEventAddress: String? = nil, updatedEventLocation: String? = nil, updatedEventLat: Double? = nil, updatedEventLon: Double? = nil, updatedEventOwner: String? = nil, updatedEventDescription: String? = nil) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        var updateData: [String: Any] = [:]
        if let updatedEventName = updatedEventName {
            updateData["name"] = updatedEventName
        }
        if let updatedEventDate = updatedEventDate {
            updateData["date_time"] = updatedEventDate
        }
        if let updatedEventAddress = updatedEventAddress {
            updateData["address"] = updatedEventAddress
        }
        if let updatedEventLocation = updatedEventLocation {
            updateData["location_name"] = updatedEventLocation
        }
        if let updatedEventLat = updatedEventLat {
            updateData["lat"] = updatedEventLat
        }
        if let updatedEventLon = updatedEventLon {
            updateData["lon"] = updatedEventLon
        }
        if let updatedEventOwner = updatedEventOwner {
            updateData["ownerID"] = updatedEventOwner
        }
        if let updatedEventDescription = updatedEventDescription {
            updateData["description"] = updatedEventDescription
        }
        if !updateData.isEmpty {
            eventRef.updateData(updateData) { error in
                if let error = error {
                    print("Error updating event in Firestore: \(error.localizedDescription)")
                } else {
                    print("Event updated in Firestore successfully!")
                }
            }
        } else {
            print("No data provided for update")
        }
        return
    }
    static func retrieveUserFromFirestore(userID: String, completion: @escaping (UserData?) -> Void) {
        let db = Firestore.firestore()
        
        let userRef = db.collection("users").document(userID)
        userRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let gradYear = data["graduation_year"] as? String ?? ""
                    let igprof = data["ig_profile"] as? String ?? ""
                    let bio = data["bio"] as? String ?? ""
                    let pfp = data["profile_pic"] as? URL ?? nil
                    let school = data["school"] as? String ?? ""
                    let user = UserData(url: pfp, uid: userID, name: name, email: email, gradYear: gradYear, bio: bio, igprof: igprof, school: school)
                    completion(user)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        return
    }
    static func retrieveAttendeesFromEvent(eventID: String, completion: @escaping ([String]?) -> Void){
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        var attendeeUserIDs: [String] = []
        
        eventRef.getDocument{ (document, error) in
            if let attendees = document?["attendees"] as? [DocumentReference] {
                // Iterate over the attendees array
                for attendeeRef in attendees {
                    // Get the document ID (user ID) from the reference
                    let userID = attendeeRef.documentID
                    // Add it to the attendeeUserIDs array
                    attendeeUserIDs.append(userID)
                }
                completion(attendeeUserIDs)
            }
            else{
                completion(nil)
            }
        }
        return
    }
    
    static func retrieveEventFromFirestore(eventID: String, completion: @escaping (Event?) -> Void) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        eventRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    let name = data["name"] as? String ?? ""
                    let location_name = data["location_name"] as? String ?? ""
                    let address = data["address"] as? String ?? ""
                    let date_time = data["date_time"] as? String ?? ""
                    let lat = data["profile_pic"] as? Double ?? 0
                    let lon = data["school"] as? Double ?? 0
                    let ownerID = data["ownerID"] as? String ?? ""
                    var attendees: [String] = []
                    let description = data["description"] as? String ?? "No description"
                    retrieveAttendeesFromEvent(eventID: eventID) {attendeeUserIds in
                        for id in attendeeUserIds! {
                            attendees.append(id)
                        }
                    }
                    
                    let event = Event(id: eventID, eventName: name, eventDate: date_time, eventAddress: address, eventLocation: location_name, eventLon: lon, eventLat: lat, eventOwner: ownerID, attendees: attendees, eventDescription: description)
                    completion(event)
                } else {
                    completion(nil)
                }
            } else {
                print("Event not found")
                completion(nil)
            }
        }
        return
    }
    
    static func addAttendeeToEvent(eventID: String, userID: String) {
        guard !userID.isEmpty else {
            print("Invalid userID")
            return
        }
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        let userRef = db.collection("users").document(userID)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Check if user is already an attendee
                eventRef.getDocument { (eventDocument, eventError) in
                    if let eventDocument = eventDocument, eventDocument.exists {
                        let attendees = eventDocument.data()?["attendees"] as? [DocumentReference] ?? []
                        if attendees.contains(userRef) {
                            print("User is already an attendee")
                        } else {
                            // Add user reference to attendees array
                            eventRef.updateData([
                                "attendees": FieldValue.arrayUnion([userRef])
                            ]) { error in
                                if let error = error {
                                    print("Error adding attendee to event: \(error.localizedDescription)")
                                } else {
                                    print("Attendee added to event successfully!")
                                }
                            }
                        }
                    } else {
                        print("Event document does not exist")
                    }
                }
            } else {
                print("User document with userID \(userID) does not exist in the users collection")
            }
        }
        return
    }
    //            }
    //        let attendeeRef = attendeesCollectionRef.document(userID)
    //        attendeeRef.getDocument { (document, error) in
    //            if let document = document, document.exists {
    //                print("User is already an attendee")
    //                return
    //            }
    //        }
    //        let attendeeData: [String: Any] = [
    //            "userRef": userRef
    //        ]
    //
    //        attendeesCollectionRef.addDocument(data: attendeeData) { error in
    //            if let error = error {
    //                print("Error adding attendee to event subcollection: \(error.localizedDescription)")
    //            } else {
    //                print("Attendee added to event subcollection successfully!")
    //            }
    //        }
    //    }
    static func deleteEventFromFirestore(userID: String, eventID: String, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        var isDeleted = false
        eventRef.getDocument { (document, error) in
            if let document = document {
                let data = document.data()
                let ownerID = data?["ownerID"] as? String ?? ""
                if ownerID != userID {
                    print("User is not the owner")
                    completion(isDeleted)
                    return
                } else {
                    eventRef.delete { error in
                        if let error = error {
                            completion(isDeleted)
                            print("Error deleting event from Firestore: \(error.localizedDescription)")
                            return
                        } else {
                            isDeleted = true
                            completion(isDeleted)
                            print("Event deleted from Firestore successfully!")
                        }
                    }
                }
                
            }
        }
    
        return
    }
    
    static func deleteAttendeeFromEvent(eventID: String, attendeeID: String) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventID)
        let userRef = db.collection("users").document(attendeeID)
        
        // Remove the attendee reference from the array
        eventRef.updateData([
            "attendees": FieldValue.arrayRemove([userRef])
        ]) { err in
            if let err = err {
                print("Error removing attendee from event: \(err.localizedDescription)")
            } else {
                print("Attendee removed from event successfully!")
            }
        }
        return
    }
}
