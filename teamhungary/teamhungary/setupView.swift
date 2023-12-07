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
    @Binding var currentPic: UIImage?
    @State var userName: String
    @State var userMajor: String
    @State var userSchool: String
    @State var userGradYear: String
    @State var userBio: String
    @State var userIg: String
    @State var selectedImage: UIImage?
    @State var isImagePickerPresented: Bool = false
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    Spacer()
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541), lineWidth: 5))
                            .padding(.vertical, 4)
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                            .sheet(isPresented: $isImagePickerPresented) {
                                ImagePicker(selectedImage: $selectedImage)
                            }
                    } else {
                        Image(uiImage: currentPic!)
                            .frame(width: 170, height: 170)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541), lineWidth: 5))
                            .padding(.vertical, 4)
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                            .sheet(isPresented: $isImagePickerPresented) {
                                ImagePicker(selectedImage: $selectedImage)
                            }
                    }
                    
                    HStack {
                        Text("Name")
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 100, alignment: .leading)

                        TextField("", text: $userName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 200)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 4)
                            .disabled(true)
                    }
                    .frame(width: 350)
                    .padding(.vertical, -2.0)
                    HStack {
                        Text("Major")
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 100, alignment: .leading)

                        TextField("Major", text: $userMajor)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 200)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 4)
                            .disabled(true)
                    }
                    .frame(width: 350)
                    .padding(.vertical, -2.0)
                    
                    HStack {
                        Text("School")
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 100, alignment: .leading)

                        TextField("School", text: $userSchool)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 200)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 4)
                            .disabled(true)
                    }
                    .frame(width: 350)
                    .padding(.vertical, -2.0)
                    HStack {
                        Text("Graduation Year")
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 100, alignment: .leading)

                        TextField("Graduation Year", text: $userGradYear)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 200)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 4)
                            .disabled(true)
                    }
                    .frame(width: 350)
                    .padding(.vertical, -2.0)
                    HStack {
                        Text("Bio")
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 100, alignment: .leading)

                        TextField("Bio", text: $userBio)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 200)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 4)
                            .disabled(true)
                    }
                    .frame(width: 350)
                    .padding(.vertical, -2.0)
                    
                    HStack {
                        Text("Instagram Username")
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 100, alignment: .leading)

                        TextField("Instagram Username", text: $userIg)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(Font.custom("Avenir", size: 18.0))
                            .frame(width: 200)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 4)
                            .disabled(true)
                            .autocapitalization(.none)
                        
                    }
                    .frame(width: 350)
                    .padding(.vertical, -2.0)
                    
                    Button(action: {
                        let newUser = UserData(
                            url: userData.url,
                            uid: userData.uid,
                            name: userData.name,
                            email: userData.email,
                            gradYear: userGradYear,
                            bio: userBio,
                            igprof: userIg,
                            school: userSchool,
                            major: userMajor
                        )
                        userData = newUser
                        FirebaseUtilities.updateUserInFirestore(uid: userData.uid, graduationYear: userGradYear, school: userSchool, major: userMajor, bio: userBio, igProfile: userIg)
                        
                        if let selectedImage = selectedImage {
                            updatePic(image: selectedImage, uid: userData.uid) {url in}
                        }
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
                        Text("save")
                            .bold()
                            .font(Font.custom("Avenir", size: 24.0))
                            .padding(20)
                            .foregroundColor(Color.white)
                            .background(Color("ButtonColor"))
                            .cornerRadius(12)
                    }.padding(.vertical, 10)
                }
            }
        }
        .frame(width: 500)
        .background(Color("ColumbiaBlue"))
    }
    func updatePic(image: UIImage, uid: String, completion: @escaping (String?) -> Void) {
        print("Image data read, uploading to Firebase...")
        // Upload the image data to Firebase Storage
        FirebaseUtilities.uploadProfilePicture(imageData: image, userID: uid) { downloadURL in
            guard let dURL = downloadURL else {
                print("Error: Unable to get download URL")
                completion(nil)
                return // Exit the function here
            }
            print("Image uploaded to Firebase, URL: \(dURL)")
            // Save the new profile picture URL
            FirebaseUtilities.saveProfilePictureURL(dURL, for: uid) { url in
                print("profile pic url saved")
                completion(url)
            }
        }
    }

}

struct setupView_Preview: PreviewProvider{
    static var userData = UserData(url: nil, uid: "1", name: "jasmine", email: "test", gradYear: "2015", bio: "hi", igprof: "link", school: "GSAS", major: "CS")
    static var previews: some View{
        setupView(userData: .constant(userData), showModal: .constant(true), currentPic: .constant(UIImage(systemName: "person")), userName: userData.name, userMajor: userData.major, userSchool: userData.school, userGradYear: userData.gradYear, userBio: userData.bio, userIg: userData.igprof)
    }
}

