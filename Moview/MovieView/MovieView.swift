//
//  ContentView.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//
// TODO: - 로그인, 게시판, 즐겨찾기, 개봉예정작

import SwiftUI
import Kingfisher

struct MovieView: View {
    @StateObject var viewModel = MovieViewModel(movieService: MovieService())
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // 추천 영화
                CardView(viewModel: viewModel)
                
                GenreCardView()
                
                DividerCategoryView(category: .popular)
                
                MovieSlideView(viewModel: viewModel, type: 0)
                    .padding(.bottom, 10)
                
                DividerCategoryView(category: .nowPlaying)
                
                MovieSlideView(viewModel: viewModel, type: 1)
                
                Spacer()
            }
        }
        .task {
            viewModel.fetchNowPlaying()
            viewModel.fetchPopularMovie()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }
        }
    }
    
    
}

#Preview {
    MovieView()
}



