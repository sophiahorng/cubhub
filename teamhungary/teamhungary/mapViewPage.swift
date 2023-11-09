//
//  mapViewPage.swift
//  teamhungary
//
//  Created by Jas Shin on 11/9/23.
//

import SwiftUI
import MapKit

struct mapViewPage: View {
    @State private var region =
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.809312, longitude: -73.960413),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
        }
    }
}

#Preview {
    mapViewPage()
}
