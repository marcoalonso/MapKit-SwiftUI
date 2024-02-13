//
//  LocationDetailsView.swift
//  MapsSwiftUI
//
//  Created by Marco Alonso Rodriguez on 12/02/24.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @State private var lookArroundScene: MKLookAroundScene?
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, content: {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                })
                
                Spacer()
                
                Button(action: {
                    show.toggle()
                    mapSelection = nil
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                })
            }
            
            if let scene = lookArroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
        }
        .onAppear(perform: {
            fetchLookAroundPreview()
            print("Debug: onAppear")

        })
        .onChange(of: mapSelection) { oldValue, newValue in
            fetchLookAroundPreview()
            print("Debug: onChange")
        }
        
    }
}

extension LocationDetailsView {
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookArroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookArroundScene = try? await request.scene
            }
        }
            
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil), show: .constant(false))
}
