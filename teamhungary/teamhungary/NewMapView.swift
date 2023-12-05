//
//  NewMapView.swift
//  teamhungary
//
//  Created by Seungyoon Paik 12/3/2023
//

import SwiftUI
import MapKit
import Combine

struct newMapData: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct NewMapView: View {
    
    private var annotations: [newMapData] = []
//    @State private var isDetailViewActive = false
    @State private var isShowing = false
    @State private var userLocation: CLLocationCoordinate2D?
    @StateObject private var viewModel = MapViewModel()
    
    init(events: [Event]) {
        events.forEach { event in
            let coordinate = CLLocationCoordinate2D(latitude: event.eventLat, longitude: event.eventLon)
            let data = newMapData(name: event.eventName, coordinate: coordinate)
            annotations.append(data)
            print(event)
        }
    }
    
    var body: some View {
//        NavigationStack {
            ZStack {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: annotations) { data in
                    MapAnnotation(coordinate: data.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1)) {
                        VStack {
                            Text(data.name)
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                            Image(systemName: "mappin")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                        .onTapGesture {
                            /*
                             https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
                             */
                            //
//                            isDetailViewActive = true
                            isShowing = true
                        }
                        .alert("Open in Apple Maps", isPresented: $isShowing) {
                            Button("go", role: .destructive) {
                                
                                let urlStr = "http://maps.apple.com/?ll=\(data.coordinate.latitude),\(data.coordinate.longitude)"
                                if let url = URL(string: urlStr) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                            Button("cancel", role: .cancel) {
                                
                            }
                        }
                    }
                }.onAppear {
//                    requestLocation()
                }
                .navigationTitle("map")
//                .navigationDestination(isPresented: $isDetailViewActive) {
//                    NewMapDetailView()
//                    AdressView()
//                }
            }
//        }
    }
}

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var userLocation: CLLocationCoordinate2D?

    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            region.center = location
            userLocation = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
