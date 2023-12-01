//
//  EventsView.swift
//  teamhungary
//
//  Created by Sophia Horng on 11/9/23.
//

import SwiftUI

struct Event: Identifiable {
    var id = UUID()
    var imageName: String
    var eventName: String
    var eventDate: String
    var eventSubtitle: String
}

struct EventsView: View {
    let events: [Event] = [
        Event(imageName: "event1", eventName: "Event 1", eventDate: "10/31", eventSubtitle: "#concert #rap"),
            Event(imageName: "event2", eventName: "Event 2", eventDate: "11/20", eventSubtitle: "#art #exhibit"),
            Event(imageName: "event3", eventName: "Event 3", eventDate: "12/23", eventSubtitle: "#ballet #dance")
    ]

    var body: some View {
            TabView {
                VStack {
                    HStack {
                        Text("Events")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()

                        Spacer()

                        Button(action: {
                            
                        }) {
                            Image(systemName: "plus")
                                .padding()
                        }
                    }

                    HStack {
                        Button(action: {
                            // Filter action
                        }) {
                            Text("Filter by...")
                                .padding()
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Button(action: {
                            // See map view action
                        }) {
                            Text("See Map View")
                                .padding()
                                .foregroundColor(.blue)
                        }
                    }
                    List(events) { event in
                        HStack {
                            Image(systemName: event.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                .padding()

                            VStack(alignment: .leading) {
                                Text(event.eventName + " on " + event.eventDate)
                                    .font(.headline)
                                Text(event.eventSubtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    Spacer()

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

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
