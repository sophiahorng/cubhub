//
//  DefaultView.swift
//  teamhungary
//
//  Created by Sophia Horng on 12/1/23.
//

import Foundation
import SwiftUI

struct DefaultView: View {
    @Binding var userData: UserData
    @EnvironmentObject var loginState: LoginState
    var body: some View {
        TabView {
            // EventsView
            NavigationView {
                EventsView(userData: $userData)
            }
            .tabItem {
                Label("Events", systemImage: "list.bullet")
            }
            
            
            NavigationView {
                MyPlansView(userData: $userData)
            }
            .tabItem {
                Label("My Plans", systemImage: "star")
            }
            
            
            NavigationView {
                MyPageView(userData: $userData, loginState: _loginState)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

