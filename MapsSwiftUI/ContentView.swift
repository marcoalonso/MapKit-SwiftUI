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
    @State private var searchText = ""
    @State private var results : [MKMapItem] = []
    @State private var mapSelection: MKMapItem?
    @State private var shwoDetails = false
    
    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection) {
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
            
            ForEach(results, id: \.self) { item in
                let placemark = item.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
            }
        }
        .overlay(alignment: .top, content: {
            TextField("Search for location ...", text: $searchText)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .cornerRadius(12)
                .padding()
                .shadow(radius: 12)
        })
        .onSubmit(of: .text) {
            
            Task {
                await searchPlaces()
            }
        }
        .onChange(of: mapSelection, { oldValue, newValue in
            shwoDetails = newValue != nil
        })
        .sheet(isPresented: $shwoDetails, content: {
            LocationDetailsView(mapSelection: $mapSelection, show: $shwoDetails)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        })
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
}

extension ContentView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
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
