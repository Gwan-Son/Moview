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
                    ZStack(alignment: .leading) {
                        VStack(spacing: 10) {
                            KFImage(URL(string: movie.poster_path))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .shadow(radius: 10)
                            
                            Text(movie.title)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .multilineTextAlignment(.center)
                                .frame(width: 100)
                                .padding(.top, 1)
                        }
                        CircularProgressView(progress: movie.vote_average)
                            .padding(.top, 100)
                            .padding(.leading, 5)
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
