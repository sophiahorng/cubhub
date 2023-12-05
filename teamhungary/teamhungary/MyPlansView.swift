//
//  MyEventsView.swift
//  teamhungary
//
//  Created by Sophia Horng on 12/1/23.
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
// Define Firestore references
struct MyPlansView: View {
    @State private var events: [Event] = [
//        Event(imageName: "photo", eventName: "Jazz Night", eventDate: "10/31", eventSubtitle: "#concert #jazz", eventLocation: "Columbia", eventLon: -73.9626, eventLat: 40.8075, eventDescription: "Jazz concert at Roone Arledge Auditorium featuring Christmas tunes"),
//        Event(imageName: "photo", eventName: "Broadway Show Preview", eventDate: "11/20", eventSubtitle: "#broadway #musical #opera", eventLocation: "Theatre", eventLon: -73.9855, eventLat: 40.7580, eventDescription: "Preview of Broadway show Phantom of the Opera"),
//        Event(imageName: "photo", eventName: "Art Walk", eventDate: "12/23", eventSubtitle: "#art #nature #park", eventLocation: "Central Park", eventLon: -73.935242, eventLat: 40.730610, eventDescription: "Take a walk through Central Park to see  art pieces")
    ]
    @Binding var userData: UserData
    @State private var editMode: EditMode = .inactive
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(events) { event in
                        NavigationLink(destination: EventView(event: event)) {
                            HStack {
//                                Image(systemName: event.imageName)
//                                    .resizable()
//                                    .frame(width: 50, height: 50)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
//                                    .padding()
                                
                                VStack(alignment: .leading) {
                                    Text(event.eventName + " on " + event.eventDate)
                                        .font(.headline)
                                    Text(event.eventLocation)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
//                                    Text(event.eventSubtitle)
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
                                }
                                if editMode.isEditing {
                                    Button(action: {
                                        deleteEvent(event)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        events.remove(atOffsets: indexSet)
                    }
                }
                .environment(\.editMode, $editMode)  // Bind EditMode to the environment
                .animation(.default, value: editMode)
                .onAppear {
                    UITableView.appearance().allowsSelectionDuringEditing = true
                    fetchUserEvents()
                }
                .navigationBarTitle("My Plans")
            }//NavigationView
            
            Spacer()
        }//VStack
    }
    func fetchUserEvents() {
        let db = Firestore.firestore()
        let userId = userData.uid
        guard !userId.isEmpty else {
                print("Invalid userID")
                return
        }
        print("id: \(userId)")
        print("fetching user events, checking array contains /users/\(userId)")
        
        let userRef = db.collection("users").document(userId)
        db.collection("events")
            .whereField("attendees", arrayContains: userRef)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching events: \(error.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    return
                }
                print(documents)
                // Parse the documents into Event objects
                events = documents.compactMap { document in
                    let data = document.data()
                    let eventName = data["name"] as? String ?? ""
                    let eventDate = data["date_time"] as? String ?? ""
                    let eventLocation = data["location_name"] as? String ?? ""
                    let address = data["address"] as? String ?? ""
                    let eventLon = data["lat"] as? Double ?? 0
                    let eventLat = data["lon"] as? Double ?? 0
                    let eventOwner = data["ownerID"] as? String ?? ""
                    let newEvent = Event(eventName: eventName, eventDate: eventDate, eventAddress: address, eventLocation: eventLocation, eventLon: eventLon, eventLat: eventLat, eventOwner: eventOwner, attendees: []/*, eventDescription: ""*/)
                    return newEvent
                }
            }
    }
    func deleteEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        }
    }
}
//struct MyPlansView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPlansView()
//    }
//}
