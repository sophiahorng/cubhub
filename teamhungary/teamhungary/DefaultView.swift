//
//  DefaultView.swift
//  teamhungary
//
//  Created by Sophia Horng on 12/1/23.
//

import Foundation
import SwiftUI

struct DefaultView: View {
    @ObservedObject var userDataObservable: UserDataObservable
    @State var isLogin: Bool
    var body: some View {
        TabView {
            // EventsView
            NavigationView {
                EventsView(userDataObservable: userDataObservable)
            }
            .tabItem {
                Label("Events", systemImage: "list.bullet")
            }
            
            
            // MyEventsView
            NavigationView {
                MyPlansView(userDataObservable: userDataObservable)
            }
            .tabItem {
                Label("My Plans", systemImage: "star")
            }
            
            
            // MyPageView
            NavigationView {
                MyPageView(userDataObservable: userDataObservable, isLogin: $isLogin)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

