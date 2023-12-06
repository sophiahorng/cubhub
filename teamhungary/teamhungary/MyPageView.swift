import SwiftUI
import GoogleSignIn

struct MyPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var userData: UserData
    @EnvironmentObject var loginState: LoginState
    @State private var showMapView = false
    @State var showModal: Bool = false
    @State private var profileImage: UIImage?
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView{
                    VStack (spacing: 30) {
                        HStack {
                            Spacer()
                            Button(action: {
                                showModal = true
                            }) {
                                Text("Edit Profile \(Image(systemName: "square.and.pencil"))")
                                    .padding([.top,.vertical], 5)
                                    .foregroundStyle(.gray)
                            }
                            .buttonStyle(.bordered)
                            .accentColor(Color("ColumbiaBlue"))
                            .frame(alignment: .trailing)
                            .sheet(
                                isPresented: $showModal,
                                content: {
                                    setupView(
                                        userData: $userData,
                                        showModal: $showModal,
                                        currentPic: $profileImage,
                                        userName: userData.name,
                                        userMajor: userData.major,
                                        userSchool: userData.school,
                                        userGradYear: userData.gradYear,
                                        userBio: userData.bio,
                                        userIg: userData.igprof
                                    )
                                }
                            )
                        }
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 180, height: 180)
                            // Add frame, aspectRatio, clipShape etc. as needed
                                .clipShape(Circle())
                        } else {
                            // Placeholder view or default image
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 180, height: 180)
                                .clipShape(Circle())
                        }
                        //                    if let urlWithTimestamp = URL(string: "\(String(describing: userData.url?.absoluteString))?timestamp=\(Date().timeIntervalSince1970)") {
                        //                        AsyncImage(url: urlWithTimestamp)
                        //                            .imageScale(.small)
                        //                            .frame(width: 180, height: 180, alignment: .center)
                        //                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        //                    } else {
                        //                        AsyncImage(url: userData.url)
                        //                            .imageScale(.small)
                        //                            .frame(width: 180, height: 180, alignment: .center)
                        //                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        //                    }
                        Text(userData.name)
                        Text(userData.email)
                        Text("\(userData.school) \(userData.gradYear)")
                        Text("Major: \(userData.major)")
                        if (!userData.igprof.isEmpty) {
                            Link("Instagram", destination: URL(string: "https://www.instagram.com/\(userData.igprof)")!)
                        }
                        //                    Spacer()
                        //                    Spacer()
                        HStack {
                            Spacer()
                            Button {
                                logout()
                            } label: {
                                Text("logout")
                                    .bold()
                                    .font(Font.custom("Helvetica Neue", size: 24.0))
                                    .padding(20)
                                    .foregroundColor(Color.white)
                                    .background(Color("ButtonColor"))
                                    .cornerRadius(12)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer(minLength: 100)
                    }
                }
                .background(Color("ColumbiaBlue"))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .scrollContentBackground(.hidden)
        .onAppear {
            fetchUserData()
            FirebaseUtilities.retrieveProfilePicture(for: userData.uid) { image in
                print("profile image changed")
                self.profileImage = image
            }
        }
        .refreshable {
            fetchUserData()
            FirebaseUtilities.retrieveProfilePicture(for: userData.uid) { image in
                print("profile image changed")
                self.profileImage = image
            }
        }
        .onReceive(loginState.$isLoggedIn) { newValue in
            // Handle login state changes here
            if !newValue {
                print("logout triggered")
            }
        }
    }
    private func fetchUserData() {
        FirebaseUtilities.retrieveUserFromFirestore(userID: userData.uid) { fetchedUserData in
            if let data = fetchedUserData {
                // Update the userData binding
                self.userData = data
            } else {
                // Handle the error or provide a default value
            }
        }
    }
    
    private func logout() {
        GIDSignIn.sharedInstance.signOut()
        loginState.isLoggedIn = false
        dismiss()
    }

}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView(userData: .constant(UserData(url: nil, uid: "yx2810", name: "jasmine xin", email: "yx2810@columbia.edu")))
//    }
//}
