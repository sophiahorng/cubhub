//
//  MapView.swift
//  teamhungary
//
//  Created by Sophia Horng on 11/9/23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    private let annotations = [
        MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.8075, longitude: -73.9626), title: "Jazz Night at Columbia"),
        MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855), title: "Broadway Show Preview"),
        MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242), title: "Central Park Art Walk")
    ]

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        uiView.setRegion(region, animated: true)

        uiView.addAnnotations(annotations)
    }
}

extension MKPointAnnotation {
    convenience init(coordinate: CLLocationCoordinate2D, title: String) {
        self.init()
        self.coordinate = coordinate
        self.title = title
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
    }
}
