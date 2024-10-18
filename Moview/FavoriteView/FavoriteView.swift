//
//  FavoriteView.swift
//  Moview
//
//  Created by 심관혁 on 10/15/24.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject private var firestoreManager: FirestoreManager
    @Environment(\.auth) private var authManager
    @StateObject var viewModel = FavoriteViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.movies, id: \.id) { favorite in
                    NavigationLink(destination: DetailView(movie: favorite)) {
                        MoviePosterView(movie: favorite)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .task {
            viewModel.loadFavorite(firestoreManager.favorites)
        }
    }
}

#Preview {
    FavoriteView()
        .environmentObject(FirestoreManager())
        .environment(\.auth, AuthManager(configuration: .mock(.signedIn)))
}
