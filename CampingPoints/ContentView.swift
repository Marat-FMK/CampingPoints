//
//  ContentView.swift
//  CampingPoints
//
//  Created by Marat Fakhrizhanov on 09.11.2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))) 
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition){
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)){
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width:44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                            //                            .onLongPressGesture {
                            //                                selectedPlace = location
                            //                            } // не сработал, заменил этим >>>
                                .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in viewModel.selectedPlace = location })
                        }
                    }
                }
                .mapStyle(viewModel.mapStyle == MapStyle.hybrid ? .hybrid : .standard)
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) {
                        viewModel.updateLocation(location: $0)
                    }
                }
            }
            HStack{
                Button("Hybrd Style") {
                    viewModel.mapStyle = .hybrid
                }
                Spacer()
                Button("Standart Style") {
                    viewModel.mapStyle = .standart
                }
            }
            .padding(.horizontal,40)
        } else {
            Button("Unlock places", action: viewModel.authinticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
