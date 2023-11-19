
import UIKit
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    @State private var isSignedIn = false
    @State private var userData: UserData = UserData(url: nil, name: "", email: "")
    @State private var isAlert = false
    
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
                    
                    HStack {
                        Spacer().frame( width: 80 )
                        GoogleSignInButton(action: handleSignInButton)
                        Spacer().frame( width: 80 )
                    } // HStack
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
            .navigationDestination(isPresented: $isSignedIn) {
                MyPageView(userData: $userData)
            }
        } // NavigationStack
        .onAppear {
            self.checkState()
        }
        .alert(LocalizedStringKey("login fail"), isPresented: $isAlert) {
            Button("OK", role: .cancel) { print("tap ok") }
        } message: {
            Text("try again")
        }
    }
    
    func checkState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            guard error != nil || user == nil else {
                print("Not Sign In")
                return
            }
            
            guard let profile = user?.profile else {
                return
            }
            
            userData = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
            isSignedIn = true
            
        }
    }
    
    func handleSignInButton() {
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController ) { signInResult, error in
                guard let result = signInResult else {
                    isAlert = true
                    return
                }
                guard let profile = result.user.profile else {
                    isAlert = true
                    return
                }
                
                userData = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
                isSignedIn = true
            }
        
    }
}
