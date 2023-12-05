//
//  EventsView.swift
//  teamhungary
//
//  Created by Sophia Horng on 11/9/23.
//
import SwiftUI
struct Event: Identifiable {
    var id: String = UUID().uuidString
    var eventName: String
    var eventDate: String
    var eventAddress: String
    var eventLocation: String
    var eventLon: Double
    var eventLat: Double
    var eventOwner: String
    var attendees: [String]
//    var eventDescription: String
}
struct EventsView: View {
    @State private var events: [Event] = [
        Event(eventName: "Jazz Night", eventDate: "10/31", eventAddress: "411 W 116th St, New York, NY 10027", eventLocation: "Columbia", eventLon: -73.9626, eventLat: 40.8075, eventOwner: "", attendees: []/*, eventDescription: "Jazz concert at Roone Arledge Auditorium featuring Christmas tunes"*/),
        Event(eventName: "Broadway Show Preview", eventDate: "11/20", eventAddress: "411 W 116th St, New York, NY 10027", eventLocation: "Theatre", eventLon: -73.9855, eventLat: 40.7580, eventOwner: "", attendees: []/*, eventDescription: "Preview of Broadway show Phantom of the Opera"*/),
        Event(eventName: "Art Walk", eventDate: "12/23", eventAddress: "411 W 116th St, New York, NY 10027", eventLocation: "Central Park", eventLon: -73.935242, eventLat: 40.730610, eventOwner: "", attendees: []/*, eventDescription: "Take a walk through Central Park to see  art pieces"*/)
    ]
    @State private var isAddEventViewPresented = false
    @Binding var userData: UserData
    @State private var editMode: EditMode = .inactive
    var body: some View {
//            TabView {
                VStack {
                    HStack {
                        Text("Events")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                        Button(action: {
                            isAddEventViewPresented.toggle()
                        }) {
                            Image(systemName: "plus")
                                .padding()
                        }
                        .sheet(isPresented: $isAddEventViewPresented) {
                            AddEventView(events: $events, userData: $userData, doneAction: {
                                    isAddEventViewPresented.toggle()
                                })
                        }
                    }
                    HStack {
                        Button(action: {
                            // Filter
                        }) {
                            Text("Filter by...")
                                .padding()
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        // MapView
                        NavigationStack {
                            NavigationLink(destination: NewMapView(events: events)) {
                            Text("See Map View")
                                .padding()
                                .foregroundColor(.blue)
                            }
                        } // NavigationStack end

                    }
                    NavigationStack{
                        List {
                            ForEach(events) { event in
                                //NavigationView{
                                NavigationLink(destination: EventView(event: event)) {
                                    HStack {
//                                        Image(systemName: event.imageName)
//                                            .resizable()
//                                            .frame(width: 50, height: 50)
//                                            .clipShape(Circle())
//                                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
//                                            .padding()
                                        
                                        VStack(alignment: .leading) {
                                            Text(event.eventName + " on " + event.eventDate)
                                                .font(.headline)
                                            Text(event.eventLocation)
                                                .font(.subheadline)
                                                .foregroundColor(.black)
//                                            Text(event.eventSubtitle)
//                                                .font(.subheadline)
//                                                .foregroundColor(.gray)
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
                                    //}
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
                        }
                    }
                    Spacer()
                }
//                .navigationBarHidden(true)
//                .tabItem {
//                    Image(systemName: "list.bullet")
//                    Text("Events")
//                }
//
//                Text("My Plans")
//                    .tabItem {
//                        Image(systemName: "calendar")
//                        Text("My Plans")
//                    }
//
//                Text("Account")
//                    .tabItem {
//                        Image(systemName: "person")
//                        Text("Account")
//                    }
//            }
//
//            .background(
//                Image("Background")
//                    .resizable()
//                    .scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
//            )
        
        }
    
    func deleteEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        }
    }
}
//struct EventsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventsView()
//    }
//}
