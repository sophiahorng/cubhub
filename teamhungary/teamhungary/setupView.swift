//
//  setupView.swift
//  teamhungary
//
//  Created by Nicole Men on 12/1/23.
//


import SwiftUI

struct User: Identifiable{
    var id: ObjectIdentifier
    
    var imageName : String
    var userName: String
    var userMajor: String
    var userGradYear: String
    var userBio: String
}

struct setupView: View {
    
    @State var users: [User] = [User(id: <#ObjectIdentifier#>, imageName: "photo", userName: "Roaree", userMajor: "Computer Science", userGradYear: "2025", userBio: "Roaree the Lion")]
    @State private var userName = ""
    @State private var userMajor = ""
    @State private var userGradYear = ""
    @State private var userBio = ""
    var saveProfile:() -> Void
    
    var body: some View {
        ZStack {
            Image("BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Spacer()
                Spacer()
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 170, height: 170)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541), lineWidth: 5))
                    .padding()
                
                TextField("Name", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .padding()
                
                TextField("Major", text: $userMajor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .padding()
                
                TextField("Graduation Year", text: $userGradYear)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .padding()
                
                ScrollView{
                    TextField("Bio", text: $userBio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                HStack{
                    Spacer()
                    Button(action: {
                        let newUser = User(
                            id: <#ObjectIdentifier#>, imageName: "photo",
                            userName: userName,
                            userMajor: userMajor,
                            userGradYear: userGradYear,
                            userBio: userBio
                        )
                        users.append(newUser)
                        userName = ""
                        userMajor = ""
                        userGradYear = ""
                        userBio = ""
                        saveProfile()
                    }) {
                        Text("Save")
                    }
                }
            }
        }
    }
    
    
}

struct setupView_Preview: PreviewProvider{
    static var previews: some View{
        let practiceUser: [User] = []
        return setupView(users: practiceUser, saveProfile: {})
    }
}

