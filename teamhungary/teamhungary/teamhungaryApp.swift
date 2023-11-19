 
 

import SwiftUI
import FirebaseCore
import GoogleSignIn
 
class teamhungaryApp: NSObject, UIApplicationDelegate {
    
    
    var window: UIWindow?
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        
        
      if let rootViewController = self.window?.rootViewController {
                  
          GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
              }


      GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
         if error != nil || user == nil {
           // Show the app's signed-out state.
         } else {
           // Show the app's signed-in state.
         }
       }

    return true
  }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(teamhungaryApp.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
            
        }
    }
}


