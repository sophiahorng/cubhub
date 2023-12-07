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
    @State private var newEventLocation = ""
    @State private var newEventLon = 0.0
    @State private var newEventLat = 0.0
    @State private var newEventDescription = ""
    @Binding var userData: UserData
    @State private var isSearchAddressViewActive = false
    @State private var isImagePickerPresented: Bool = false
    
    var doneAction: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            HStack{
                Text("Add New Event").font(Font.custom("Avenir-Black", size: 30.0))
                    .fontWeight(.bold)
                    .padding(20.0)
                Spacer()

                Button(action: {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd"
                    let dateString = dateFormatter.string(from: newEventDate)
                    
                
                    let newEvent = Event(
                                           eventName: newEventName,
                                           eventDate: dateString,
                                           eventAddress: newEventAddress,
                                           eventLocation: newEventLocation,
                                           eventLon: newEventLon,
                                           eventLat: newEventLat,
                                           eventOwner: userData.uid,
                                           attendees: [userData.uid],
                                           eventDescription: newEventDescription
                                       )
                    FirebaseUtilities.addEventToFirestore(event: newEvent, image: self.selectedImage)
//                    if let image = self.selectedImage {
//                        FirebaseUtilities.uploadEventPhoto(imageData: self.selectedImage!, eventID: newEvent.id) {url in
//                        }
//                    }


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
                    newEventLocation = ""
                    newEventAddress = ""
                    newEventDescription = ""

                    // Call the done action
                    doneAction()
                }) {
                    Text("Done")
                        .padding(20.0)
                        .font(Font.custom("Avenir", size: 16.0))
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
                        .font(Font.custom("Avenir", size: 16.0))
                }
                
                Button("Select Image") {
                    isImagePickerPresented.toggle()
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                .font(Font.custom("Avenir", size: 16.0))
            }
            HStack {
                Text("Event Name")
                    .font(Font.custom("Avenir", size: 18.0))
                    .frame(width: 100, alignment: .leading)

                TextField("Event Name", text: $newEventName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(Font.custom("Avenir", size: 18.0))
                    .frame(width: 200)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 4)
            }
            .frame(width: 350)
            .padding(.vertical, -2.0)
//            TextField("Event Name", text: $newEventName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .frame(width: 300)
//                .multilineTextAlignment(.center)
//                .padding()
//                .font(Font.custom("Avenir", size: 16.0))
                //.background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                //.foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))

            DatePicker("Event Date", selection: $newEventDate, displayedComponents: [.date])
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .font(Font.custom("Avenir", size: 18.0))
//                .padding()
            
            HStack(/*spacing: 10*/) {
                Text(newEventAddress)
                    .padding(.leading, 15.0)
                    .frame(width: 150, alignment: .leading)
                    .lineLimit(2)
                    .font(Font.custom("Avenir", size: 18.0))
                Button {
                    isSearchAddressViewActive = true
                } label: {
                    Text("Search Address")
                        .font(Font.custom("Avenir", size: 16.0))
                        .frame(alignment: .trailing)
                        .lineLimit(2)
                        .padding(.trailing, 10.0)
                }.sheet(isPresented: $isSearchAddressViewActive) {
                    
                    SearchAddressView(dynamicText: $newEventAddress, latitude: $newEventLat, longitude: $newEventLon)
                }
                .padding()
                .frame(width: 200)

            }
            
            HStack {
                Text("Location Name")
                    .font(Font.custom("Avenir", size: 18.0))
                    .frame(width: 100, alignment: .leading)

                TextField("Location Name", text: $newEventLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(Font.custom("Avenir", size: 18.0))
                    .frame(width: 200)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 4)
            }
            .frame(width: 350)
            .padding(.vertical, -2.0)
//            TextField("Location Name", text: $newEventLocation)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .frame(width: 300)
//                .multilineTextAlignment(.center)
//                .padding()
//                .background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
//                .foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
            HStack {
                Text("Event Description")
                    .font(Font.custom("Avenir", size: 18.0))
                    .frame(width: 100, alignment: .leading)
                
                ScrollView {
                    TextEditor(text: $newEventDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(Font.custom("Avenir", size: 18.0))
                        .frame(minHeight: 100)
                        .frame(width: 200)
                        .padding(.vertical, 4)
                }
            }
            .padding(.vertical, -2.0)
//            ScrollView{
//                TextField("Event Description", text: $newEventDescription)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(width: 300)
//                    .multilineTextAlignment(.center)
//                    .padding()
//                    //.background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
//                    //.foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
//                    
//                    
//            }

            Spacer().frame(height: 10.0)
            
        }
        .background(
            Color("ColumbiaBlue")
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyEvents: [Event] = []

        return AddEventView(events: .constant(dummyEvents), userData: .constant(UserData(url: URL(string: "gmail.com"), uid: "kMLv7myZh9PBLijrvy3hP6NZjkA2", name: "Sophia Horng", email: "sh4230@columbia.edu", gradYear: "2025", bio: ":D", igprof: "sophiaah8", school: "SEAS", major: "Computer Science")), doneAction: {})
    }
}
