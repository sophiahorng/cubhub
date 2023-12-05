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

struct attendeeView: View {
    
    
    @Binding var userData: UserData
    var body: some View {
        VStack{
            Spacer()
            
            AsyncImage(url: userData.url)
                .imageScale(.small)
                .frame(width: 180, height: 180, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            Text(userData.name)
            Text(userData.email)
            Text("\(userData.school) \(userData.gradYear)")
            if (!userData.igprof.isEmpty) {
                Link("Instagram", destination: URL(string: "https://www.instagram.com/\(userData.igprof)")!)
            }
            Spacer()
        }
    }
}
