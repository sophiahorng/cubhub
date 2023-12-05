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
    
    @Binding var userData: UserData
    @Binding var showModal: Bool
    @State var userName: String
    @State var userMajor: String
    @State var userGradYear: String
    @State var userBio: String
    @State var selectedImage: UIImage?
    @State var isImagePickerPresented: Bool = false
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                    Spacer()
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 170, height: 170)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541), lineWidth: 5))
                            .padding()
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                            .sheet(isPresented: $isImagePickerPresented) {
                                ImagePicker(selectedImage: $selectedImage)
                            }
                    } else {
                        AsyncImage(url: userData.url)
                            .frame(width: 170, height: 170)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541), lineWidth: 5))
                            .padding()
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                            .sheet(isPresented: $isImagePickerPresented) {
                                ImagePicker(selectedImage: $selectedImage)
                            }
                    }
                    
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
                        let newUser = UserData(
                            url: userData.url,
                            uid: userData.uid,
                            name: userData.name,
                            email: userData.email,
                            gradYear: userGradYear,
                            bio: userBio,
                            igprof: userData.igprof,
                            school: userMajor
                        )
                        userData = newUser
                        FirebaseUtilities.updateUserInFirestore(uid: userData.uid, graduationYear: userGradYear, school: userMajor, bio: userBio)
//                        if (selectedImage != nil) {
//                            FirebaseUtilities.uploadProfilePicture(imageData: selectedImage!, userID: userData.uid) { downloadURL in
//                                if let downloadURL = downloadURL {
//                                    FirebaseUtilities.saveProfilePictureURL(downloadURL, for: userData.uid)
//                                }
//                            }
//                        }
//                            
                        self.showModal.toggle()
                    }) {
                        Text("Save")
                            .bold()
                            .font(Font.custom("Helvetica Neue", size: 24.0))
                            .padding(20)
                            .foregroundColor(Color.white)
                            .background(Color("ButtonColor"))
                            .cornerRadius(12)
                    }
                }
            }
        }
        .background(Color("ColumbiaBlue"))
    }
    
    
}

//struct setupView_Preview: PreviewProvider{
//    static var previews: some View{
//        let practiceUser: User = User(id: nil, imageName: "", userName: "jasmine", userMajor: "cs", userGradYear: "2025", userBio: "hi")
//        return setupView(user: practiceUser, showModal: .constant(true))
//    }
//}

