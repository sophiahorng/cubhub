import SwiftUI
import GoogleSignIn

struct MyPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var userData: UserData
    @EnvironmentObject var loginState: LoginState
    @State private var showMapView = false
    @State var showModal: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                        .frame(alignment: .trailing)
                        .sheet(
                            isPresented: $showModal,
                            content: {
                                setupView(
                                    userData: $userData,
                                    showModal: $showModal,
                                    userName: userData.name,
                                    userMajor: userData.school,
                                    userGradYear: userData.gradYear,
                                    userBio: userData.bio,
                                    userIg: userData.igprof
                                )
                            }
                        )
                    }
                    
                    
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
                    Spacer()
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
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .onReceive(loginState.$isLoggedIn) { newValue in
                // Handle login state changes here
                if !newValue {
                    print("logout triggered")
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
