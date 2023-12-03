
import UIKit
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseStorage
import FirebaseFirestore

enum StackViewType {
    case MyPageView
    case MapView
    case EventView
    case EventsView
}

struct ContentView: View {
    @State private var userData: UserData = UserData(url: nil, name: "", email: "")
    @State private var isAlert = false
    @State private var isLogin = false
    
    
    @State private var isShownMyPageView = false
    @State private var isShownMapView = false
    @State private var isShownEventView = false
    @State private var isShownEventsView = false
    
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                let imagePath = Bundle.main.path(forResource: "bg", ofType: "png")
                let img = UIImage(contentsOfFile: imagePath! )
                
                Image(uiImage: img! )
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer().frame( height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/ )
                    HStack{
                        Spacer()
                        Text(" ")
                            .font(.system(size: 24))
                            .foregroundColor( Color(red: 137/255 , green: 199/255 , blue: 233/255 ) )
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text(" ")
                            .font(.system(size: 24))
                            .foregroundColor( Color(red: 137/255 , green: 199/255 , blue: 233/255 ) )
                        Spacer()
                    } // HStack
                    Spacer().frame( height: 300 )
                    //                    if self.isLogin == true {
                    //                        List {
                    //                            Button {
                    //                                self.isShownMyPageView.toggle()
                    //                            } label: {
                    //                                Text("Show My Page View")
                    //                            }
                    //                            .sheet(isPresented: $isShownMyPageView) {
                    //                                MyPageView(userData: $userData, isLogin: $isLogin)
                    //                            }
                    //                            Button {
                    //                                self.isShownMapView.toggle()
                    //                            } label: {
                    //                                Text("Show MapView")
                    //                            }
                    //                            .sheet(isPresented: $isShownMapView) {
                    //                                MapView()
                    //                            }
                    //                            Button {
                    //                                self.isShownEventView.toggle()
                    //                            } label: {
                    //                                Text("Show Event View")
                    //                            }
                    //                            .sheet(isPresented: $isShownEventView) {
                    //                                EventsView()
                    //                            }
                    //                            Button {
                    //                                self.isShownEventView.toggle()
                    //                            } label: {
                    //                                Text("Show Events View")
                    //                            }
                    //                            .sheet(isPresented: $isShownEventView) {
                    ////                                EventView()
                    //                            }
                    //                        }
                    //                        .background(.clear)
                    //                        .scrollContentBackground(.hidden)
                    //                    } else {
                    HStack {
                        Spacer().frame( width: 80 )
                        GoogleSignInButton(action: handleSignInButton)
                        Spacer().frame( width: 80 )
                    } // HStack
                    //                    }
                    Spacer().frame( height: 200 )
                    VStack{
                        HStack{
                            Spacer()
                            Text("By signing up, you agree to the ")
                                .font(.system(size: 10))
                            Text("User Agrement").bold()
                                .font(.system(size: 12))
                            Text("&").font(.system(size: 10))
                            Spacer()
                        } // HStack
                        
                        HStack{
                            Spacer()
                            Text("Privacy Policy").bold()
                                .font(.system(size: 12))
                            Spacer()
                        } // HStack
                    } // VStack
                } // VStack
                NavigationLink(
                    destination: DefaultView(userData: userData, isLogin: isLogin).navigationBarBackButtonHidden(true),
                    isActive: $isLogin,
                    label: {
                        EmptyView()
                    }
                )
            } // ZStack
        } // NavigationStack
        .onAppear {
            self.checkState()
        }
        .alert(LocalizedStringKey("Login Failed"), isPresented: $isAlert) {
            Button("OK", role: .cancel) { print("tap ok") }
        } message: {
            Text("Try Again")
        }
    }
    
    func checkState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            guard error != nil || user == nil else {
                print("Not Sign In")
                self.isLogin = false
                return
            }
            
            guard let profile = user?.profile else {
                return
            }
            
            userData = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
            self.isLogin = true
        }
    }
    
    
    
    func handleSignInButton() {
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard let result = signInResult else {
                isAlert = true
                return
            }
            guard let profile = result.user.profile else {
                isAlert = true
                return
            }
            
            // Use optional binding to safely unwrap the URL
            if let imageURL = profile.imageURL(withDimension: 180) {
                // Upload profile picture to Firebase Storage
                FirebaseUtilities.uploadProfilePicture(imageURL, userID: result.user.userID ?? "")
                
                // Add user data to Firestore
                FirebaseUtilities.addUsertoFirestore(
                    uni: result.user.userID ?? "",
                    name: profile.name,
                    email: profile.email,
                    profilePic: imageURL.absoluteString
                )
                
                userData = UserData(url: imageURL, name: profile.name, email: profile.email)
                self.isLogin = true
            } else {
                // Handle the case where imageURL is nil
                print("Error: Profile picture URL is nil")
            }
        }
    }
}
