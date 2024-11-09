//
//  EditView.swift
//  CampingPoints
//
//  Created by Marat Fakhrizhanov on 09.11.2024.
//

import SwiftUI
import Foundation

struct EditView: View {
    
//    enum LoadingState {
//        case loading, loaded, failed // состояния сетевого запроса
//    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location

    @State private var viewModel = ViewModel()
    
    @State private var name: String
    @State private var description: String
    var onSave: (Location) -> Void
    
    @State private var loadingState = viewModel.loadingState
    @State private var pages = [Page]()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                Section("Nearby…") {
                    switch loadingState {
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") + // + обьеденят текстовые блоки 
                            Text(page.description)
                                .italic() // курсив 
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    init(location: Location,  onSave: @escaping(Location) -> Void) {
                self.location = location
        self.onSave = onSave

                _name = State(initialValue: location.name)
                _description = State(initialValue: location.description)
            }
    
    
    
}

#Preview {
    EditView(location: .example, onSave: {_ in} )
}
