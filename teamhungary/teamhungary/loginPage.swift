//
//  ContentView.swift
//  teamhungary
//
//  Created by Wenshuo Xie on 11/9/23.
//

import SwiftUI

struct loginPage: View {
    var body: some View {
        ZStack {
            Image("loginPage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            
            VStack {
                Spacer()
                googleLoginButton()
                    .padding()
                Spacer()
            }
        }
    }
}

struct googleLoginButton: View {
    var body: some View {
        Button(action: {
     
        }) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.white)
                Text("Login with Google")
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(width: 280, height: 50)
            .background(Color.blue)
            .cornerRadius(5)
        }
    }
}

struct loginPage_Previews: PreviewProvider {
    static var previews: some View {
        loginPage()
    }
}

