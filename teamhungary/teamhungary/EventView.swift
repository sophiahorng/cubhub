//
//  EventView.swift
//  teamhungary
//
//  Created by Sophia Horng on 11/9/23.
//
import SwiftUI
import FirebaseFirestore
import FirebaseCore

struct photo: Identifiable {
    let id = UUID()
    let name: String
}
struct user: Identifiable {
    let id = UUID()
    let name: String
    let photo: String
}
struct EventView: View {
    @Environment(\.presentationMode) var presentationMode
    var event: Event
    init(event: Event, userData: Binding<UserData>) {
        self.event = event
        self._userData = userData
    }
    let images: [photo] = [photo(name: "photo"), photo(name: "photo"), photo(name: "photo"), photo(name: "photo")]
    let users: [user] = [user(name: "Name", photo: "photo"), user(name: "Name", photo: "photo")]
    
    @State private var attendees: [String] = []
    @Binding var userData: UserData
    @State private var isUserAttendee = false
    
    var body: some View {
        //        TabView {
        VStack (spacing: 2) {
            HStack {
                Button (action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }.padding()
                }
                .frame(alignment: .leading)
                Spacer()
                VStack {
                    Text(event.eventName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(3) // Set an appropriate line limit to avoid excessive text length
                    
                    Text("on \(event.eventDate) at \(event.eventLocation)")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .lineLimit(3) // Adjust line limit as needed
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                Spacer()
                // Use onAppear to check if the user is an attendee when the view appears
                    .onAppear {
                        DispatchQueue.main.async {
                            isUserAttendee = event.attendees.contains(userData.uid)
                        }
                    }
                // Conditionally show the "Add" button based on isUserAttendee
                if !isUserAttendee {
                    Button(action: {
                        FirebaseUtilities.addAttendeeToEvent(eventID: event.id, userID: userData.uid)
                    }) {
                        Text("Add").padding(20)
                    }
                    .frame(alignment: .trailing)
                }
            }
            Spacer()
            List {
                Section(header: Text("Event Photos")){
                    HStack {
                        ForEach(images) { image in
                            Image(systemName: image.name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .clipShape(Rectangle())
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                                .padding(8)
                        }
                    }.padding(8)
                    Button(action: {
                        // Filter action
                    }) {
                        Text("Open Photo Gallery")
                            .foregroundColor(.blue)
                    }.padding(8)
                }
            }
            .background(Color("ColumbiaBlue"))
            .scrollContentBackground(.hidden)
            VStack{
                NavigationLink(destination: attendeesView(event: event, userData: $userData)) {
                    Text("See All Attendees")
                        .foregroundColor(.white)
                }
                .buttonStyle(GrowingButton())
                .padding(5)
            }
            .background(Color("ColumbiaBlue"))
            .onAppear {
                // Fetch attendees for the given eventID when the view appears
                //fetchEventAttendees(eventID: event.id)
            }
        }
        .navigationBarHidden(true)
    }
    
    
    
    /*eventRef.getDocument{ (document, error) in
     if let document = document, document.exists {
     let data = document.data()
     if let data = data {
     let attendees = retrieveAttendeesFromEvent(eventID: eventID)
     
     let event = Event(id: eventID, eventName: name, eventDate: date_time, eventAddress: address, eventLocation: location_name, eventLon: lon, eventLat: lat, eventOwner: ownerID, attendees: attendees)
     completion(event)
     } else {
     completion(nil)
     }
     } else {
     print("Event not found")
     completion(nil)
     }
     
     */
    // Use addSnapshotListener to listen for real-time updates on the event's attendees
    /*attendeesRef.observe(.value) { snapshot in,
     if let attendeesData = snapshot.value as? [String]{
     //self.attendees = attendeesData
     
     // Fetch user data for each attendee using the retrieveUserFromFirestore function
     var fetchedAttendees: [String] = []
     
     for userID in attendeesData {
     FirebaseUtilities.retrieveUserFromFirestore(userID: userID){ user in
     fetchedAttendees.append(user!.name)
     }
     }
     self.attendees = fetchedAttendees
     */
    // Parse the document and update the event's attendees
    //if let data = document.data(), let attendeesData = data["attendees"] as? [String] {
    
    
    //}
    // Update the attendees array with user names
    // self.attendees = fetchedAttendees
    
    
}




struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
/*struct EventView_Previews: PreviewProvider {
 static var previews: some View {
 EventView(event: Event(eventName: "Jazz Night", eventDate: "10/31",/* eventSubtitle: "#concert #jazz", */ eventAddress: "411 W 116th St, New York, NY 10027",eventLocation: "Columbia", eventLon: -73.9626, eventLat: 40.8075, eventOwner: "", attendees: []/*, eventDescription: "Jazz concert at Roone Arledge Auditorium featuring Christmas tunes"*/))
 }
 }*/


