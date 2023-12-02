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
                EventsView()
            }
            .tabItem {
                Label("Events", systemImage: "calendar")
            }
            
            
            // MyEventsView
            NavigationView {
                MyEventsView()
            }
            .tabItem {
                Label("My Events", systemImage: "star")
            }
            
            
            // MyPageView
            NavigationView {
                MyPageView(userData: $userData, isLogin: $isLogin)
            }
            .tabItem {
                Label("My Page", systemImage: "person")
            }
        }
    }
}
