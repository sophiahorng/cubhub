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
    init(event: Event) {
        self.event = event
    }
    let images: [photo] = [photo(name: "photo"), photo(name: "photo"), photo(name: "photo"), photo(name: "photo")]
    let users: [user] = [user(name: "Name", photo: "photo"), user(name: "Name", photo: "photo")]
    var body: some View {
        TabView {
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
                            //.padding()
                            //.frame(maxWidth: .infinity, alignment: .center)
                        Text("on \(event.eventDate) at \(event.eventLocation)")
                            .font(.subheadline)
                            //.padding()
                        
                    }
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("Add").padding(20)
                    }
                    .frame(alignment: .trailing)
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
                        Button(action: {
                            // Filter action
                        }) {
                            Text("See More")
                                .foregroundColor(.blue)
                        }
                        Button(action: {
                            // Filter action
                        }) {
                            Text("Invite Someone")
                                .foregroundColor(.blue)
                        }
                    }
                }
                //Button(action: {
                    
                //}) {
                //    Text("Add to Calendar")
                //}.padding()
            }
            .navigationBarHidden(true)
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Events")
            }

            Text("My Plans")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("My Plans")
                }

            Text("Account")
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
        }
    }
    
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: Event(imageName: "photo", eventName: "Jazz Night", eventDate: "10/31", eventSubtitle: "#concert #jazz", eventLocation: "Columbia", eventLon: -73.9626, eventLat: 40.8075, eventDescription: "Jazz concert at Roone Arledge Auditorium featuring Christmas tunes"))
    }
}
