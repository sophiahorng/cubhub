 
import UIKit
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
 

struct ContentView: View {
    @State private var isSignedIn = false
    @State private var gName = ""
    var body: some View {
        ZStack {
            
            let imagePath = Bundle.main.path(forResource: "bg", ofType: "png")
            let img = UIImage(contentsOfFile: imagePath! )
            
            Image(uiImage: img! )
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if isSignedIn {
                    Text("hi \(gName)")
                    
                    Button(action: {
                        
                        GIDSignIn.sharedInstance.signOut()
                        isSignedIn = false
                    }) {
                        Text("\(gName) google logout")
                    }
                    
                }else {
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
                        }
                        Spacer().frame( height: 300 )
                        
                        HStack {
                            Spacer().frame( width: 80 )
                            GoogleSignInButton(action: handleSignInButton)
                            Spacer().frame( width: 80 )
                        }
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
                            }
                            
                            HStack{
                                Spacer()
                                Text("Privacy Policy").bold()
                                    .font(.system(size: 12))
                                Spacer()
                            }
                            
                        }
                        
                    }
                }
            }
            .onAppear {
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    
                    if user != nil {""
                        isSignedIn = true
                        gName = user?.profile!.name ?? ""
                        NSLog( "goo \( user?.profile?.name )" )
                    }
                }
            }
        }
    }
    
    func handleSignInButton() {
      GIDSignIn.sharedInstance.signIn(
        withPresenting: UIApplication.shared.windows.first!.rootViewController! ) { signInResult, error in
          guard let result = signInResult else {
              isSignedIn = false
            return
          }
            isSignedIn = true
        }
       
    }
    
//    @IBAction func signOut(sender: Any) {
//      GIDSignIn.sharedInstance.signOut()
//    }
}
