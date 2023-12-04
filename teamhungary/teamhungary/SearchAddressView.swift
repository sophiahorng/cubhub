//
//  SearchAddressView.swift
//  teamhungary
//
//  Created by Seungyoon Paik 12/3/2023
//

import SwiftUI

struct GoogleGeocodingResponse: Decodable {
    var results: [Location] = []
}

struct Location: Decodable, Hashable {
    var formatted_address: String
    var geometry: Geometry

    struct Geometry: Decodable, Hashable {
        var location: Coordinates

        struct Coordinates: Decodable, Hashable {
            var lat: Double
            var lng: Double
        }
    }
}

struct SearchAddressView: View {
    
    @Binding var dynamicText: String
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var addressInput: String = ""
    @State private var locations: [Location] = []
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        
        VStack(spacing: 30) {
            HStack{
                Text("Search Address")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(20.0)
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .padding(20.0)
                }
            }
         
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

                    Text(location.formatted_address)
                        .onTapGesture {
                            self.dynamicText = location.formatted_address
                            self.latitude = location.geometry.location.lat
                            self.longitude = location.geometry.location.lng
                            dismiss()
                        }

                }
                .listStyle(.grouped)
                .onAppear {
                    
                }
                .background(.clear)
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
    }

    private func searchAddress() {
        let apiKey = "AIzaSyDG8KPuQyuTVC9sOh87zZqKU0gKdQD_zWA"

        // https://developers.google.com/maps/documentation/places/web-service/search-text?hl=en
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(addressInput)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                showAlert(message: "Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let response = try JSONDecoder().decode(GoogleGeocodingResponse.self, from: data)
                DispatchQueue.main.async {
                    self.locations = response.results

                    if self.locations.isEmpty {
                        self.showAlert(message: "No results found.")
                    }
                }
            } catch {
                showAlert(message: "Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func showAlert(message: String) {
        errorMessage = message
        showAlert = true
    }

}
