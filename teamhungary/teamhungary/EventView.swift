//
//  EventView.swift
//  teamhungary
//
//  Created by Sophia Horng on 11/9/23.
//
import SwiftUI
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
    let event: Event
    init(event: Event, userData: Binding<UserData>) {
        self.event = event
        self._userData = userData
    }
    let images: [photo] = [photo(name: "photo"), photo(name: "photo"), photo(name: "photo"), photo(name: "photo")]
    let users: [user] = [user(name: "Name", photo: "photo"), user(name: "Name", photo: "photo")]
    
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
                        .lineLimit(2) // Set an appropriate line limit to avoid excessive text length
                    
                    Text("on \(event.eventDate) at \(event.eventLocation)")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .lineLimit(2) // Adjust line limit as needed
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
            List {
                Section(header: Text("Attendees")) {
                    VStack {
                        ForEach(users) { user in
                            HStack {
                                Image(systemName: user.photo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                    .padding(8)
                                Text(user.name)
                            }
                        }
                    }
                    
                }
            }
            .background(Color("ColumbiaBlue"))
            .scrollContentBackground(.hidden)
            
            NavigationLink(destination: attendeesView(event: event, userData: $userData)) {
                Text("See All Attendees")
                    .foregroundColor(.blue)
            }
        }
        .navigationBarHidden(true)
    }
    
}
/*struct EventView_Previews: PreviewProvider {
 static var previews: some View {
 EventView(event: Event(eventName: "Jazz Night", eventDate: "10/31",/* eventSubtitle: "#concert #jazz", */ eventAddress: "411 W 116th St, New York, NY 10027",eventLocation: "Columbia", eventLon: -73.9626, eventLat: 40.8075, eventOwner: "", attendees: []/*, eventDescription: "Jazz concert at Roone Arledge Auditorium featuring Christmas tunes"*/))
 }
 }*/
