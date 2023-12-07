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
    @State private var attendees: [(id: String, name: String)] = []
    @State private var events: [Event] = []
    
    
    @Binding var userData: UserData
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                NavigationView{
                    
                    List{
                        ForEach(attendees, id: \.id) { attendee in
                            NavigationLink(destination: AttendeeView(attendeeID: attendee.id)) {
                                
                                Text(attendee.name)
                                    .font(Font.custom("Avenir", size: 16.0))
                                    .padding()
//                                    .border(Color.gray, width: 1) // Add border for better visibility
                                
                            }
                        }
                    }
                    .onAppear {
                        // Fetch attendees for the given eventID when the view appears
                        fetchEventAttendees(eventID: event.id)
                    }
                }
            }
        }
        .navigationBarTitle("Attendees")
        
    }
    
    
    func fetchEventAttendees(eventID: String) {
        //let db = Firestore.firestore()
        //let eventID = event.id
        //print(eventID)
        // Get a reference to the event document in Firestore
        //let eventRef = db.collection("events").document(eventID)
        //let attendeesRef = eventRef.child("attendees")
        
        //let eventDocument = db.collection("events").document(eventID)
        
        
        print("Retrieving attendees")
        FirebaseUtilities.retrieveAttendeesFromEvent(eventID: eventID){
            attendeeUserIDs in
            print(attendeeUserIDs ?? "no attendees")
            if let attendeeIds = attendeeUserIDs {
                for id in attendeeIds {
                    FirebaseUtilities.retrieveUserFromFirestore(userID: id) {user in
                        if let userName = user?.name {
                            self.attendees.append((id:id, name: userName))
                        }
                    }
                }
            }
            
        }
    }
    
    
    
    
    /* eventDocument.addSnapshotListener { documentSnapshot, error in
     guard let document = documentSnapshot else {
     print("Error fetching document: \(error!)")
     return
     }
     print("snapshot added")
     var fetchedAttendees: [String] = []
     if let attendeesData = document.data()?["attendees"] as? [String] {
     for userID in attendeesData {
     print(userID)
     FirebaseUtilities.retrieveUserFromFirestore(userID: userID){ user in
     fetchedAttendees.append(user!.name)
     event.attendees = fetchedAttendees
     print(attendees)
     
     
     }
     }
     }
     }
     */
    
    
    
}
    
