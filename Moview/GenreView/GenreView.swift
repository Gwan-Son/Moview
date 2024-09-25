//
//  CategoryView.swift
//  Moview
//
//  Created by 심관혁 on 9/18/24.
//

import SwiftUI
import Kingfisher

struct GenreView: View {
    @ObservedObject var viewModel: GenreViewModel
    @State private var savedMovies: [MovieModel] = []
    var genre: (String, String)
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.genreMovies, id: \.id) { movie in
                    NavigationLink(destination: DetailView(movie: movie)) {
                        MoviePosterView(movie: movie)
                            .foregroundColor(.black)
                    }
                }
            }
            MoreButton()
                .refreshable {
                    viewModel.addItem(genre: genre.1)
                }
        }
        .navigationTitle(genre.0)
        .task {
            if savedMovies.isEmpty {
                viewModel.fetchGenreMovie(with: 0, for: genre.1)
            }
        }
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }
        }
        .onDisappear {
            savedMovies = viewModel.genreMovies
        }
    }
}

#Preview {
    GenreView(viewModel: GenreViewModel(movieService: MovieService()), genre: ("액션","16"))
}
