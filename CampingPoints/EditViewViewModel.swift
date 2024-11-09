//
//  EditViewViewModel.swift
//  CampingPoints
//
//  Created by Marat Fakhrizhanov on 09.11.2024.
//

import SwiftUI
import Foundation

enum Loading {
    case loading, loaded, failed // состояния сетевого запроса
}

extension EditView {
    @Observable
    class ViewModel {
        
        var loadingState = Loading.loading
        var pages = [Page]()
        
        var location: Location = Location(id: UUID(), name: "loc", description: "disc", latitude: 234, longitude: 51)
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // we got some data back!
                let items = try JSONDecoder().decode(Result.self, from: data)

                // success – convert the array values to our pages array
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                // if we're still here it means the request failed somehow
                loadingState = .failed
            }
        }
        
        
    }
}
