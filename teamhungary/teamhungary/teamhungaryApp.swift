 
 

import SwiftUI
import FirebaseCore
import GoogleSignIn
 
class teamhungaryApp: NSObject, UIApplicationDelegate {
//    let databaseManager = DatabaseManager.shared
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Configure Firebase here
        FirebaseApp.configure()
            
        // Google Sign-In configuration and restoration of previous sign-in state
        if let rootViewController = self.window?.rootViewController {
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        }

        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
            }
        }

        return true
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(teamhungaryApp.self) var delegate
    
    var loginState = LoginState()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(Color("ColumbiaBlue")) // Replace with your desired color

        // You can also customize title text color, font, etc.
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(Color("ColumbiaBlue"))
        appearance.configureWithOpaqueBackground()
        UILabel.appearance().font = UIFont(name: "Avenir", size: UIFont.labelFontSize)
        UIButton.appearance().titleLabel?.font = UIFont(name: "Avenir", size: UIFont.buttonFontSize)
        appearance.titleTextAttributes = [.font: UIFont(name: "Avenir-Black", size: 36.0)!]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .environmentObject(loginState)
            
        }
    }
}


