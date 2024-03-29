import SwiftUI
import Firebase

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
    var eventDescription: String
}

struct EventsView: View {
    @State private var events: [Event] = []
    @State private var isAddEventViewPresented = false
    @State private var isSearchBarExpanded = false
    @State private var showErrorAlert = false
    @State private var searchText = ""
    @Binding var userData: UserData
    @State private var editMode: EditMode = .inactive
    
    
    var body: some View {
        //        NavigationView {
        VStack(spacing: 0) {
            Spacer(minLength: 20)
            headerSection
            eventsListSection
        }
        .navigationBarTitle("Events", displayMode: .inline)
        .navigationBarItems(trailing: addEvent)
        .onAppear {
            fetchEvents()
        }
        //        }
    }
    private var addEvent: some View {
        Button(action: {
            isAddEventViewPresented.toggle()
        }) {
            Image(systemName: "plus")
                .padding()
        }
        .sheet(isPresented: $isAddEventViewPresented, onDismiss: fetchEvents) {
            AddEventView(events: $events, userData: $userData) {
                isAddEventViewPresented = false
            }
        }
    }
    private var searchBar: some View {
        HStack {
            if isSearchBarExpanded {
                TextField("Search events...", text: $searchText)
                    .font(Font.custom("Avenir", size: 16.0))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .transition(.move(edge: .trailing))
                    .animation(.default, value: isSearchBarExpanded)
                
                Button("Cancel") {
                    isSearchBarExpanded = false
                    searchText = ""
                }.padding()
                .font(Font.custom("Avenir", size: 16.0))
            } else {
                Image(systemName: "magnifyingglass")
                    .onTapGesture {
                        isSearchBarExpanded = true
                    }
                    .padding()
            }
        }
    }
    private var headerSection: some View {
        VStack(spacing: 0) {
//            HStack {
//                TextField("Search events...", text: $searchText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                    .font(Font.custom("Avenir", size: 16.0))
//                
//                Button("Search") {
//                    fetchEvents()
//                }
//                .padding(.trailing, 10)
//                .font(Font.custom("Avenir", size: 16.0))
//            }
            
            HStack {
                NavigationLink(destination: NewMapView(events: events)) {
                    Text("See Map")
                        .padding()
                        .font(Font.custom("Avenir", size: 16.0))
//                        .foregroundColor(Color("Columbia Blue"))
                }
                Spacer()
                searchBar
//                Button(action: {
//                    isAddEventViewPresented.toggle()
//                }) {
//                    Image(systemName: "plus")
//                        .padding()
//                }
//                .sheet(isPresented: $isAddEventViewPresented, onDismiss: fetchEvents) {
//                    AddEventView(events: $events, userData: $userData) {
//                        isAddEventViewPresented = false
//                    }
//                }
            }
        }
    }
    
    private var eventsListSection: some View {
        List {
            ForEach(filteredEvents) { event in
                NavigationLink(destination: EventView(event: event, userData: $userData)) {
                    HStack {
                        let (month, day) = formatEventDate(event.eventDate)
                        VStack {
                            Text(month)
                                .bold()
                                .font(Font.custom("Avenir", size: 16.0))
                            Text(day)
                                .font(Font.custom("Avenir", size: 14.0))
                        }
                        .padding(.trailing, 10)
                        VStack(alignment: .leading) {
                            Text(event.eventName)
                                .bold()
                                .font(Font.custom("Avenir", size: 18.0))
                            Text("\(event.eventLocation)")
                                .font(Font.custom("Avenir", size: 14.0))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    guard events.indices.contains(index) else { continue }
                    
                    let eventID = events[index].id
                    DispatchQueue.main.async{
                        FirebaseUtilities.deleteEventFromFirestore(userID: userData.uid, eventID: eventID) {isDeleted in
                            if isDeleted! {
                                events.remove(at: index)
                            }
                            else {
                                showErrorAlert = true
                            }
                        }
                    }
                    
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Failed to delete the event."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        //.listStyle(PlainListStyle())
        .environment(\.editMode, $editMode)
        .background(Color("ColumbiaBlue"))
        .scrollContentBackground(.hidden)
        .refreshable {
                fetchEvents()
            }

    }
    
    private var filteredEvents: [Event] {
        if searchText.isEmpty {
            return events
        } else {
            return events.filter { event in
                event.eventName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private func fetchEvents() {
        let db = Firestore.firestore()
        db.collection("events").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let snapshot = snapshot {
                    self.events = snapshot.documents.compactMap { doc -> Event? in
                        let data = doc.data()
                        return Event(
                            id: doc.documentID,
                            eventName: data["name"] as? String ?? "",
                            eventDate: data["date_time"] as? String ?? "",
                            eventAddress: data["address"] as? String ?? "",
                            eventLocation: data["location_name"] as? String ?? "",
                            eventLon: data["lon"] as? Double ?? 0.0,
                            eventLat: data["lat"] as? Double ?? 0.0,
                            eventOwner: data["ownerID"] as? String ?? "",
                            attendees: data["attendees"] as? [String] ?? [],
                            eventDescription: data["description"] as? String ?? "No description"
                        )
                    }
                    .sorted(by: { lhs, rhs in
                        guard let date1 = dateFormatter.date(from: lhs.eventDate),
                              let date2 = dateFormatter.date(from: rhs.eventDate) else {
                            return false
                        }
                        return date1 < date2
                    })
                }
            }
        }
    }
    
    private func deleteEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
            // Add logic to delete from Firebase
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
    func formatEventDate(_ dateString: String) -> (month: String, day: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        if let date = dateFormatter.date(from: dateString) {
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM" // Full month name
            let monthName = monthFormatter.string(from: date)
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd"
            let day = dayFormatter.string(from: date)
            
            return (monthName, day)
        }
        
        return ("", "")
    }
}

//struct EventsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventsView(userData: .constant(UserData(...)))
//    }
//}
