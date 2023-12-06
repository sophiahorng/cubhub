//
//  attendeeView.swift
//  teamhungary
//
//  Created by Nicole Men on 12/4/23.
//

// should expand into view of a user's profile with back button

import SwiftUI

import FirebaseCore
import FirebaseFirestore

struct AttendeeView: View {
    
    @StateObject private var viewModel = AttendeeViewModel()
    let attendeeID: String
    var body: some View {
        VStack {
            Spacer()
            
            if let attendeeData = viewModel.attendeeData {
                AsyncImage(url: attendeeData.url)
                    .imageScale(.small)
                    .frame(width: 180, height: 180, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                Text(attendeeData.name)
                Text(attendeeData.email)
                Text("\(attendeeData.school) \(attendeeData.gradYear)")
                if (!attendeeData.igprof.isEmpty) {
                    Link("Instagram", destination: URL(string: "https://www.instagram.com/\(attendeeData.igprof)")!)
                }
            } else {
                Text("Loading user data...")
            }
            
            Spacer()
        }
        .onAppear {
            // Replace "exampleUserID" with the actual user ID you want to display
            viewModel.fetchAttendeeData(userID: attendeeID)
        }
    }
}

class AttendeeViewModel: ObservableObject {
    
    @Published var attendeeData: UserData?
    
    func fetchAttendeeData(userID: String) {
        FirebaseUtilities.retrieveUserFromFirestore(userID: userID) { user in
            DispatchQueue.main.async {
                self.attendeeData = user
            }
        }
    }
}
