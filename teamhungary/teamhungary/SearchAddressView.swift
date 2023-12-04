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
    
    @Binding var dynamicText: String
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var addressInput: String = ""
    @State private var locations: [CLPlacemark] = []
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var selectedItem: CLPlacemark?
//
    var geocoder = CLGeocoder()

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
                    /*
                     // address dictionary properties
                     @property (nonatomic, readonly, copy, nullable) NSString *name; // eg. Apple Inc.
                     @property (nonatomic, readonly, copy, nullable) NSString *thoroughfare; // street name, eg. Infinite Loop
                     @property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare; // eg. 1
                     @property (nonatomic, readonly, copy, nullable) NSString *locality; // city, eg. Cupertino
                     @property (nonatomic, readonly, copy, nullable) NSString *subLocality; // neighborhood, common name, eg. Mission District
                     @property (nonatomic, readonly, copy, nullable) NSString *administrativeArea; // state, eg. CA
                     @property (nonatomic, readonly, copy, nullable) NSString *subAdministrativeArea; // county, eg. Santa Clara
                     @property (nonatomic, readonly, copy, nullable) NSString *postalCode; // zip code, eg. 95014
                     @property (nonatomic, readonly, copy, nullable) NSString *ISOcountryCode; // eg. US
                     @property (nonatomic, readonly, copy, nullable) NSString *country; // eg. United States
                     @property (nonatomic, readonly, copy, nullable) NSString *inlandWater; // eg. Lake Tahoe
                     @property (nonatomic, readonly, copy, nullable) NSString *ocean; // eg. Pacific Ocean
                     */
                    

                    let address = "\(location.thoroughfare ?? "") \(location.locality ?? "") \(location.administrativeArea ?? "") \(location.postalCode ?? "") \(location.country ?? "")"
                    Text(address)
                        .onTapGesture {
                            self.dynamicText = address
                            self.latitude = location.location?.coordinate.latitude ?? 0.0
                            self.longitude = location.location?.coordinate.longitude ?? 0.0
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
        geocoder.geocodeAddressString(addressInput) { placemarks, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                locations = placemarks ?? []
            }
        }
    }
}
