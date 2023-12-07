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
    
    @Environment(\.presentationMode) var presentation
    @StateObject private var viewModel = AttendeeViewModel()
    let attendeeID: String
    var body: some View {
        VStack (spacing: 10){
            Spacer()
            
            if let attendeeData = viewModel.attendeeData {
                AsyncImage(url: attendeeData.url)
                    .imageScale(.small)
                    .frame(width: 180, height: 180, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                Text(attendeeData.name).frame(maxWidth: .infinity)
                Text(attendeeData.email)
                Text("\(attendeeData.school) \(attendeeData.gradYear)")
                
                if (!attendeeData.igprof.isEmpty) {
                    Button {
                        if let url = URL(string: "https://www.instagram.com/\(attendeeData.igprof)"),
                                       UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url)
                            }
                    } label: {
                        Image("InstagramIcon")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .zIndex(1)
                        
                        Text("Instagram")
                            .background(
                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .fill(Color.white)
                                    .scaleEffect(x: 1.5, y:1.4)
                            )
                            
                    }
                }
                
                Button (action: {self.presentation.wrappedValue.dismiss()}) {
                    Text("\(Image(systemName: "chevron.left"))Back to Attendees List")
                }
                .buttonStyle(GrowingButton())
            } else {
                Text("Loading user data...")
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Replace "exampleUserID" with the actual user ID you want to display
            viewModel.fetchAttendeeData(userID: attendeeID)
        }
        .background(Color("ColumbiaBlue"))
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
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
