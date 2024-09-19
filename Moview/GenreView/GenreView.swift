//
//  CategoryView.swift
//  Moview
//
//  Created by 심관혁 on 9/18/24.
//

import SwiftUI
import Kingfisher

struct GenreView: View {
    @StateObject var viewModel = GenreViewModel(movieService: MovieService())
    var genre: (String, String)
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    // TODO: - More Button & Binding Data
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
        }
        .navigationTitle(genre.0)
        .task {
            viewModel.fetchGenreMovie(for: genre.1)
        }
    }
}

#Preview {
    GenreView(viewModel: GenreViewModel(movieService: MovieService()), genre: ("액션","16"))
}
