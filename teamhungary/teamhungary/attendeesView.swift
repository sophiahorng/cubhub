//
//  attendeesView.swift
//  teamhungary
//
//  Created by Nicole Men on 12/4/23.
//

// expands into a scroll view of list of attendees with back button
// includes name and profile pic?
// for user in list, can expand to their profile page



import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct attendeesView: View {
    let event: Event
    @State private var attendees: [String] = []
    @State private var events: [Event] = []
    @Binding var userData: UserData
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(attendees, id: \.self) { attendeeName in
                    Text(attendeeName)
                        .padding()
                        .border(Color.gray, width: 1) // Add border for better visibility
                    
                }
            }
        }
        .navigationBarTitle("Attendees")
        .onAppear {
            // Fetch attendees for the given eventID when the view appears
            fetchEventAttendees(eventID: event.id)
        }
    }
    
    func fetchEventAttendees(eventID: String) {
        let db = Firestore.firestore()
        
        // Get a reference to the event document in Firestore
        let eventRef = db.collection("events").document(eventID)
        
        // Use addSnapshotListener to listen for real-time updates on the event's attendees
        eventRef.addSnapshotListener { documentSnapshot, error in
            // Handle errors, if any
            if let error = error {
                print("Error fetching event attendees: \(error.localizedDescription)")
                return
            }
            
            // Check if the document exists
            guard let document = documentSnapshot, document.exists else {
                print("Event document not found")
                return
            }
            
            // Parse the document and update the event's attendees
            if let data = document.data(), let attendeesData = data["attendees"] as? [String] {
                // Fetch user data for each attendee using the retrieveUserFromFirestore function
                var fetchedAttendees: [String] = []
                
                for userID in attendeesData {
                    FirebaseUtilities.retrieveUserFromFirestore(userID: userID, completion: <#T##(UserData?) -> Void#>)
                    fetchedAttendees.append(userData.name)
                    
                }
                // Update the attendees array with user names
                self.attendees = fetchedAttendees
                
            }
        }
    }
    
}


