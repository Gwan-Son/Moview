//
//  MovieSlideView.swift
//  Moview
//
//  Created by 심관혁 on 9/18/24.
//

import SwiftUI
import Kingfisher

struct MovieSlideView: View {
    @ObservedObject var viewModel: MovieViewModel
    
    var type: Int // 0 - Popular 1 - NowPlaying
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach((type != 0) ? viewModel.nowPlayingMovies : viewModel.popularMovies) { movie in
                    NavigationLink(destination: DetailView(movie: movie)) {
                        MoviePosterView(movie: movie)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .padding(.leading, 15)
        .frame(height: 200)
    }
}

#Preview {
    MovieSlideView(viewModel: MovieViewModel(movieService: MovieService()), type: 0)
}
