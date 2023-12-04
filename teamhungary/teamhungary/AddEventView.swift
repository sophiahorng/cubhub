//
//  AddEventView.swift
//  teamhungary
//
//  Created by Sophia Horng on 11/9/23.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct AddEventView: View {
    @Binding var events: [Event]
    @State private var newEventName = ""
    @State private var newEventDate = ""
    @State private var newEventLocation = ""
    @State private var newEventSubtitle = ""
    @State private var newEventLon = 0.0
    @State private var newEventLat = 0.0
    @State private var newEventDescription = ""
    @State var userData: UserData
    @State private var isSearchAddressViewActive = false

    var doneAction: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            HStack{
                Text("Add New Event")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(20.0)
                Spacer()

                Button(action: {
                    // Add the new event to the Firebase database using FirebaseUtilities
                    FirebaseUtilities.addEventToFirestore(
                        uid: UUID().uuidString, // You can generate a unique ID for the event, or use any unique identifier
                        name: newEventName,
                        datetime: Timestamp(), // Use the current timestamp or set the date and time accordingly
                        address: newEventLocation,
                        locationName: "",
                        lat: newEventLat,
                        lon: newEventLon,
                        attendees: [userData.uid]
                    )

                    // Optionally, you can also add the new event to the local events array if needed
//                    let newEvent = Event(
//                        imageName: "photo",
//                        eventName: newEventName,
//                        eventDate: newEventDate,
//                        eventSubtitle: newEventSubtitle,
//                        eventLocation: newEventLocation,
//                        eventLon: newEventLon,
//                        eventLat: newEventLat,
//                        eventDescription: newEventDescription
//                    )
//                    events.append(newEvent)

                    // Clear the input fields
                    newEventName = ""
                    newEventDate = ""
                    newEventSubtitle = ""
                    newEventLocation = ""
                    newEventDescription = ""

                    // Call the done action
                    doneAction()
                }) {
                    Text("Done")
                        .padding(20.0)
                }
            }

            Image(systemName: "photo")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                //.padding()

            TextField("Event Name", text: $newEventName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .padding()
                //.background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                //.foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))

            TextField("Event Date", text: $newEventDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .padding()
                //.background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                //.foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
            
            HStack {
                TextField("Event Location", text: $newEventLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    isSearchAddressViewActive = true
                }) {
                    Text("search")
                }
                .sheet(isPresented: $isSearchAddressViewActive) {
                    SearchAddressView()
                }
                
            }
            .frame(width: 300)
            .multilineTextAlignment(.center)
            .padding()
            //.background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
            //.foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))


            
            TextField("Hashtags", text: $newEventSubtitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .padding()
                //.background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                //.foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
            
            ScrollView{
                TextField("Event Description", text: $newEventDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .padding()
                    //.background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                    //.foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                    
                    
            }

            Spacer().frame(height: 10.0)
            
        }
        .background(
            Color(hue: 0.521, saturation: 0.6, brightness: 0.8, opacity: 0.541)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

//struct AddEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dummyEvents: [Event] = []
//
//        return AddEventView(events: .constant(dummyEvents), doneAction: {})
//    }
//}
