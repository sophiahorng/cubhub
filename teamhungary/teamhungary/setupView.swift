//
//  setupView.swift
//  teamhungary
//
//  Created by Nicole Men on 12/1/23.
//


import SwiftUI

struct User: Identifiable{
    var id: ObjectIdentifier?
    
    var imageName: String
    var userName: String
    var userMajor: String
    var userGradYear: String
    var userBio: String
}

struct setupView: View {
    
    @State var user: User = User(id: nil, imageName: "photo", userName: "Roaree", userMajor: "Computer Science", userGradYear: "2025", userBio: "Roaree the Lion")
    @State private var userName: String
    @State private var userMajor: String
    @State private var userGradYear: String
    @State private var userBio: String
    var saveProfile:() -> Void
    
    init(user: User) {
        self.user = user
        self.userName = user.userName
        self.userMajor = user.userMajor
        self.userGradYear = user.userGradYear
        self.userBio = user.userBio
        self.saveProfile = {}
    }
    
    var body: some View {
        ZStack {
            Image("loginPage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
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
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
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
                    
                    TextField("Bio", text: $userBio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button(action: {
                        let newUser = User(
                            id: nil, imageName: "photo",
                            userName: userName,
                            userMajor: userMajor,
                            userGradYear: userGradYear,
                            userBio: userBio
                        )
                        user = newUser
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
        let practiceUser: User = User(id: nil, imageName: "", userName: "jasmine", userMajor: "cs", userGradYear: "2025", userBio: "hi")
        return setupView(user: practiceUser)
    }
}

