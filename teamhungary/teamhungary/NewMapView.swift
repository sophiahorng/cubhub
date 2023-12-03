//
//  NewMapView.swift
//  teamhungary
//
//  Created by Seungyoon Paik 12/3/2023
//

import SwiftUI
import MapKit

struct newMapData: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct NewMapView: View {
    
    private var annotations: [newMapData] = []
    @State private var isDetailViewActive = false
    @State private var isShowing = false
    
    init(events: [Event]) {
        events.forEach { event in
            let coordinate = CLLocationCoordinate2D(latitude: event.eventLat, longitude: event.eventLon)
            let data = newMapData(name: event.eventName, coordinate: coordinate)
            annotations.append(data)
            print(event)
        }
    }
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
//        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: annotations) { data in
                    MapAnnotation(coordinate: data.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1)) {
                        VStack {
                            Text(data.name)
                            Circle()
                                .stroke(.red, lineWidth: 2)
                                .foregroundColor(.red.opacity(0.3))
                                .frame(width: 26, height: 26)
                        }
                        .onTapGesture {
                            /*
                             https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
                             */
                            //
                            isDetailViewActive = true
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
                    setInitialLocation()
                }
                .navigationTitle("map")
                .navigationDestination(isPresented: $isDetailViewActive) {
//                    NewMapDetailView()
//                    AdressView()
                }
            }
//        }
    }
    
    func setInitialLocation() {
        LocationManager.shared.getLocation { location in
            guard let location = location else { return }
            region.center = location.coordinate
        }
    }
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    private override init() {
        super.init()
        setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getLocation(completion: @escaping (CLLocation?) -> Void) {
        completion(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
