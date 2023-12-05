import UIKit
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

enum StackViewType {
    case MyPageView
    case MyPlansView
    case MapView
    case EventView
    case EventsView
}
class LoginState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
struct ContentView: View {
    @ObservedObject var userDataObservable = UserDataObservable()
//    @State private var userData: UserData = UserData(url: nil, uid: "", name: "", email: "", gradYear: "", igprof: "", school: "")
    @State private var isAlert = false
    @State private var navigationPath = NavigationPath()
    
    
    @State private var isShownMyPageView = false
    @State private var isShownMapView = false
    @State private var isShownEventView = false
    @State private var isShownEventsView = false
    @State private var isLogin = false
    @EnvironmentObject var loginState: LoginState
    
    var body: some View {
        if loginState.isLoggedIn {
            DefaultView(userData: $userDataObservable.userData, loginState: self._loginState)
                .navigationBarBackButtonHidden(true)
        } else {
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
                
            } // ZStack
            
            .alert(LocalizedStringKey("Login Failed"), isPresented: $isAlert) {
                Button("OK", role: .cancel) { print("tap ok") }
            } message: {
                Text("Try Again")
            }
            .onAppear {
                self.checkState()
            }
            .onChange(of: loginState.isLoggedIn) { newValue in
                if newValue {
                    navigationPath.append(userDataObservable.userData)
                }
            }
        }
    }
//    var body: some View {
//        
//        NavigationStack(path: $navigationPath) {
//            ZStack {
//                let imagePath = Bundle.main.path(forResource: "bg", ofType: "png")
//                let img = UIImage(contentsOfFile: imagePath! )
//                
//                Image(uiImage: img! )
//                    .resizable()
//                    .scaledToFill()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .edgesIgnoringSafeArea(.all)
//                
//                VStack {
//                    Spacer().frame( height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/ )
//                    HStack{
//                        Spacer()
//                        Text(" ")
//                            .font(.system(size: 24))
//                            .foregroundColor( Color(red: 137/255 , green: 199/255 , blue: 233/255 ) )
//                        Spacer()
//                    }
//                    
//                    HStack {
//                        Spacer()
//                        Text(" ")
//                            .font(.system(size: 24))
//                            .foregroundColor( Color(red: 137/255 , green: 199/255 , blue: 233/255 ) )
//                        Spacer()
//                    } // HStack
//                    Spacer().frame( height: 300 )
//                    
//                    HStack {
//                        Spacer().frame( width: 80 )
//                        GoogleSignInButton(action: handleSignInButton)
//                        Spacer().frame( width: 80 )
//                    } // HStack
//                    //                    }
//                    Spacer().frame( height: 200 )
//                    VStack{
//                        HStack{
//                            Spacer()
//                            Text("By signing up, you agree to the ")
//                                .font(.system(size: 10))
//                            Text("User Agrement").bold()
//                                .font(.system(size: 12))
//                            Text("&").font(.system(size: 10))
//                            Spacer()
//                        } // HStack
//                        
//                        HStack{
//                            Spacer()
//                            Text("Privacy Policy").bold()
//                                .font(.system(size: 12))
//                            Spacer()
//                        } // HStack
//                    } // VStack
//                } // VStack
//                
//            } // ZStack
//            .navigationDestination(for: UserData.self) { userData in
//                DefaultView(userData: $userDataObservable.userData, loginState: self._loginState)
//                    .navigationBarBackButtonHidden(true)
//            }
//        } // NavigationStack
//        .onAppear {
//            self.checkState()
//        }
//        .onChange(of: loginState.isLoggedIn) { newValue in
//            if newValue {
//                navigationPath.append(userDataObservable.userData)
//            }
//        }
//
//        .alert(LocalizedStringKey("Login Failed"), isPresented: $isAlert) {
//            Button("OK", role: .cancel) { print("tap ok") }
//        } message: {
//            Text("Try Again")
//        }
//    }
//    @ViewBuilder
//    func chooseDestination(userData: UserData) -> some View {
//        if self.loginState.isLoggedIn {
//            DefaultView(userDataObservable: $userDataObservable.userData, isLogin: self.$loginState.isLoggedIn)
//                .navigationBarBackButtonHidden(true)
//        } else {
//            EmptyView()
//        }
//    }
    func checkState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            guard error != nil || user == nil else {
                print("Not Sign In")
                loginState.isLoggedIn = false
                return
            }
            
            print("User data updated: \(userDataObservable.userData)")
            guard let profile = user?.profile else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: user?.idToken?.tokenString ?? "",
                                                           accessToken: user?.accessToken.tokenString ?? "")
            var uid = ""
            // Authenticate with Firebase using the credential
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    self.isAlert = true
                    return
                } else {
                    uid = authResult?.user.uid ?? ""
                    if uid.isEmpty{
                        self.isAlert = true
                        return
                    }
                }
            }
            DispatchQueue.main.async {
                FirebaseUtilities.retrieveUserFromFirestore(userID: uid) { user in
                    if let user = user {
                        self.userDataObservable.userData = user
                    } else {
                        self.userDataObservable.userData = UserData(url: profile.imageURL(withDimension: 180), uid: uid, name: profile.name, email: profile.email, gradYear: "", bio: "", igprof: "", school: "")
                    }
                }
//                self.isLoggedIn = true
                loginState.isLoggedIn = true
            }
        }
    }
    
    func showErrorMessage(message: String) {
        // Create an alert controller
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Find the current window scene
        let windowScene = UIApplication.shared.connectedScenes
            .first as? UIWindowScene
        
        // Get the top view controller from the window scene
        let rootViewController = windowScene?.windows
            .first(where: { $0.isKeyWindow })?.rootViewController
        
        // Present the alert
        rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func handleSignInButton() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let presentingViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard let result = signInResult else {
                isAlert = true
                return
            }
            guard let profile = result.user.profile else {
                isAlert = true
                return
            }
            
//            self.isLogin = true
            let googleUser = result.user
            
            let credential = GoogleAuthProvider.credential(withIDToken: googleUser.idToken?.tokenString ?? "",
                                                           accessToken: googleUser.accessToken.tokenString)
            // Authenticate with Firebase using the credential
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    self.isAlert = true
                    return
                } else {
                    let uid = authResult?.user.uid ?? ""
                    if uid.isEmpty{
                        self.isAlert = true
                        return
                    }
                    DispatchQueue.main.async {
                        FirebaseUtilities.retrieveUserFromFirestore(userID: uid) { user in
                            if let user = user {
                                self.userDataObservable.userData = user
                            } else {
                                self.userDataObservable.userData = UserData(url: profile.imageURL(withDimension: 180), uid: uid, name: profile.name, email: profile.email, gradYear: "", bio: "", igprof: "", school: "")
                            }
                        }
                        loginState.isLoggedIn = true
                    }
                    FirebaseUtilities.addUsertoFirestore(uid: uid, name: profile.name, email: profile.email)
                    if let imageURL = userDataObservable.userData.url {
                        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
                            if let error = error {
                                print("Error downloading image data: \(error.localizedDescription)")
                                return
                            }
                            
                            if let imageData = data {
                                // Upload the image data to Firebase Storage
                                if let image = UIImage(data: imageData) {
                                    DispatchQueue.main.async {
                                        FirebaseUtilities.uploadProfilePicture(imageData: image, userID: uid) { downloadURL in
                                            if let downloadURL = downloadURL {
                                                FirebaseUtilities.saveProfilePictureURL(downloadURL, for: uid)
                                                let user = UserData(url: downloadURL, uid: self.userDataObservable.userData.uid, name: self.userDataObservable.userData.name, email: self.userDataObservable.userData.email, gradYear: self.userDataObservable.userData.gradYear, bio: self.userDataObservable.userData.bio, igprof: self.userDataObservable.userData.igprof, school: self.userDataObservable.userData.school)
                                                self.userDataObservable.userData = user
                                            }
                                        }
                                    }
                                }
                            } else {
                                print("Error: Unable to convert image data")
                            }
                        }
                        
                        task.resume()
                    }
                }
            }
        }
    }
}
//            let email = profile.email
//            guard email.hasSuffix("@columbia.edu") else {
//                // Return an error or handle the invalid email scenario
//                showErrorMessage(message: "Error: Not a Columbia domain address")
//                return
//            }
//            // Use optional binding to safely unwrap the URL
//            let uni = email.components(separatedBy: "@").first
//            if let uni = uni, uni.isEmpty {
//                showErrorMessage(message: "Error: invalid UNI address")
//                return
//            }
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
