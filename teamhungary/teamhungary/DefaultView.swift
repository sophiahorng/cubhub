//
//  DefaultView.swift
//  teamhungary
//
//  Created by Sophia Horng on 12/1/23.
//

import Foundation
import SwiftUI

struct DefaultView: View {
    @State var userData: UserData
    @State var isLogin: Bool
    var body: some View {
        TabView {
            // EventsView
            NavigationView {
                EventsView(userData: userData)
            }
            .tabItem {
                Label("Events", systemImage: "list.bullet")
            }
            
            
            // MyEventsView
            NavigationView {
                MyPlansView(userData: userData)
            }
            .tabItem {
                Label("My Plans", systemImage: "star")
            }
            
            
            // MyPageView
            NavigationView {
                MyPageView(userData: $userData, isLogin: $isLogin)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}
