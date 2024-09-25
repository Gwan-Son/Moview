//
//  SeeAllView.swift
//  Moview
//
//  Created by 심관혁 on 9/20/24.
//

import SwiftUI
import Kingfisher

struct SeeAllView: View {
    var category: MovieCategory
    @ObservedObject var viewModel: SeeAllViewModel
    @State private var savedMovies: [MovieModel] = []
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.movies, id: \.id) { movie in
                    NavigationLink(destination: DetailView(movie: movie)) {
                        MoviePosterView(movie: movie)
                            .foregroundColor(.black)
                    }
                }
            }
            MoreButton()
                .refreshable {
                    viewModel.addItem(category: category)
                }

        }
        .navigationTitle(category.name)
        .task {
            if savedMovies.isEmpty {
                switch category {
                case .popular:
                    viewModel.fetchPopularMovie()
                case .nowPlaying:
                    viewModel.fetchNowPlaying()
                }
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
            savedMovies = viewModel.movies
        }
    }
}

#Preview {
    SeeAllView(category: .nowPlaying, viewModel: SeeAllViewModel(movieService: MovieService()))
}
