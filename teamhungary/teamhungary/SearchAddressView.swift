//
//  SearchAddressView.swift
//  teamhungary
//
//  Created by Seungyoon Paik 12/3/2023
//

import SwiftUI
import CoreLocation
import Combine

struct SearchAddressView: View {
    @State private var addressInput: String = ""
    @State private var locations: [CLPlacemark] = []
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false

    private var geocoder = CLGeocoder()
    private var cancellables: Set<AnyCancellable> = []

    var body: some View {
        VStack {
            TextField("Enter address", text: $addressInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Search") {
                searchAddress()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(errorMessage), dismissButton: .default(Text("OK")) {
                    showAlert = false
                })
            }

            List(locations, id: \.self) { location in
                Text("\(location.name ?? "") \(location.locality ?? "") \(location.country ?? "")")
                
                let latitude = location.location?.coordinate.latitude ?? 0.0
                let longitude = location.location?.coordinate.longitude ?? 0.0
                
                Text("latitude : \(latitude),longitude : \(longitude)")
                
            }
            .onAppear {
                
            }
            .background(.clear)
        }
        .padding()
    }

    private func searchAddress() {
        geocoder.geocodeAddressString(addressInput) { placemarks, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                locations = placemarks ?? []
            }
        }
    }
}
