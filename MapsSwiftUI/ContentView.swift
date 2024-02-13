//
//  ContentView.swift
//  MapsSwiftUI
//
//  Created by Marco Alonso Rodriguez on 12/02/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    var body: some View {
        Map(position: $cameraPosition) {
            // Marker("My location", coordinate: .userLocation)
               // .tint(.blue)
            
            Annotation("My location", coordinate: .userLocation) {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.blue.opacity(0.25))
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.blue)
                }
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
}

#Preview {
    ContentView()
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 19.428345, longitude: -99.18173)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
}
