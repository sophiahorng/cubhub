//
//  AddEventView.swift
//  teamhungary
//
//  Created by Sophia Horng on 11/9/23.
//

import SwiftUI

struct AddEventView: View {
    var body: some View {
        VStack(spacing: 30) {
            HStack{
                Text("Add New Event")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(20.0)
                Spacer()

                Button(action: {}) {
                    Text("Done")
                        .padding(20.0)
                }
            }

            Image(systemName: "photo")
                .resizable()
                .frame(width: 170, height: 170)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .padding()

            TextField("Event Name", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                .foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))

            TextField("Event Date", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                .foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))

            TextField("Event Location", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                .foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
            
            ScrollView{
                TextField("Event Description", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                    .foregroundColor(Color(hue: 0.571, saturation: 1.0, brightness: 1.0, opacity: 0.541))
                    
                    
            }

            Spacer().frame(height: 13.0)
            
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
    }
}
