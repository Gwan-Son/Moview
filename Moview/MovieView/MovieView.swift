//
//  ContentView.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    @StateObject var viewModel = MovieViewModel(movieService: MovieService()
    )
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // 추천 영화
                    CardView(viewModel: viewModel)
                    
                    GenreCardView()
                    
                    DividerCategoryView(dividerText: "인기 영화")
                    
                    MovieSlideView(viewModel: viewModel, type: 0)
                        .padding(.bottom, 10)
                    
                    DividerCategoryView(dividerText: "현재 상영작")
                    
                    MovieSlideView(viewModel: viewModel, type: 1)
                    
                    Spacer()
                }
            }
            
        }
        .task {
            viewModel.fetchNowPlaying()
            viewModel.fetchPopularMovie()
        }
    }
    
    
}

#Preview {
    MovieView()
}



