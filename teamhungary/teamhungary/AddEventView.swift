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
    @State private var selectedImage: UIImage?
    @State private var newEventName = ""
    @State private var newEventDate: Date = Date()
    @State private var newEventAddress = "Event Location"
    @State private var newEventSubtitle = ""
    @State private var newEventLon = 0.0
    @State private var newEventLat = 0.0
    @State private var newEventDescription = ""
    @State var userData: UserData
    @State private var isSearchAddressViewActive = false
    @State private var isImagePickerPresented: Bool = false
    
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
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd"
                    let dateString = dateFormatter.string(from: newEventDate)
                    
                    // TODO: IMAGE UPLOAD
                    let newEvent = Event(
                                           eventName: newEventName,
                                           eventDate: dateString,
                                           eventAddress: newEventAddress,
                                           eventLocation: "",
                                           eventLon: newEventLon,
                                           eventLat: newEventLat,
                                           eventOwner: userData.uid,
                                           attendees: [userData.uid]
                                       )
                    FirebaseUtilities.addEventToFirestore(event: newEvent)


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
                    newEventDate = Date()
                    newEventSubtitle = ""
                    newEventAddress = ""
                    newEventDescription = ""

                    // Call the done action
                    doneAction()
                }) {
                    Text("Done")
                        .padding(20.0)
                }
            }

            VStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } else {
                    Text("No Image Selected")
                }
                
                Button("Select Image") {
                    isImagePickerPresented.toggle()
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }

            TextField("Event Name", text: $newEventName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .padding()
                //.background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                //.foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))

            DatePicker("Event Date", selection: $newEventDate, displayedComponents: [.date])
                .frame(width: 300)
                .multilineTextAlignment(.center)
//                .padding()
            
            VStack(spacing: 10) {
                Text(newEventAddress)
                    .frame(width: 300)
                    .lineLimit(2)
                Button {
                    isSearchAddressViewActive = true
                } label: {
                    Text("Search Address")
                }.sheet(isPresented: $isSearchAddressViewActive) {
                    
                    SearchAddressView(dynamicText: $newEventAddress, latitude: $newEventLat, longitude: $newEventLon)
                }

            }
            

//            TextField("Hashtags", text: $newEventSubtitle)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .frame(width: 300)
//                .multilineTextAlignment(.center)
//                .padding()
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
