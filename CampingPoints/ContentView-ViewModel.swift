//
//  ContentView-ViewModel.swift
//  CampingPoints
//
//  Created by Marat Fakhrizhanov on 09.11.2024.
//

import LocalAuthentication
import CoreLocation
import MapKit
import Foundation

enum MapStyle: String {
    case hybrid = "Hybrid"
    case standart = "Standart" 
}

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = false
        
        var mapStyle = MapStyle.standart
        
        var alertTitle = ""
        var alertMessage = ""
        var showAlert = false
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
                
            }catch {
                locations = []
                print("Error decod or path!")
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Error data encode")
            }
        }
        
        func addLocation( at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let selectedPlace else { return }
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location // изменяем св-во в существующем массиве по индексу на новое - скорректтированное сво во благодарая убегвющему замыканию
                save()
            }
        }
        
        func authinticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Pleace authenticate"
            
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else  {
                        self.alertTitle = "no face *)"
                        self.alertMessage = "give iphone her owner"
                        self.showAlert = true
                    }
                }
            } else {
                // no biometric
            }
            
        }
    }
}
