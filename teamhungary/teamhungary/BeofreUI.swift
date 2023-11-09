//
//  BeofreUI.swift
//  team_project
//
//  Created by super on 2023/11/08.
//

import UIKit
//import GoogleSignIn

class ViewController: UIViewController//, GIDSignInDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Google Sign-In
      //  GIDSignIn.sharedInstance().delegate = self
    }

    // Implement GoogleSignInDelegate methods
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        if let error = error {
//            // Handle error
//            print("Google Sign-In Error: \(error.localizedDescription)")
//            return
//        }
//
//        // Successfully signed in with Google
//        let userId = user.userID                  // For client-side use only!
//        let idToken = user.authentication.idToken // Safe to send to your server
//        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
//        
//        // You can now use the user's information as needed.
//
//        // Optionally, you can sign the user out when they're done.
//        // GIDSignIn.sharedInstance().signOut()
//    }

    // Implement other view controller methods as needed
}

