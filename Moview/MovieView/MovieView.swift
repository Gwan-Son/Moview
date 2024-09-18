//
//  ContentView.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    @StateObject var viewModel = MovieViewModel(movieService: MovieService())
    
    let genres = Genres.allGenres
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // 추천 영화
                CardView(viewModel: viewModel)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(genres, id: \.1) { genre in
                            Button {
                                // TODO: - See Category Tab
                                print("선택된 장르: \(genre)")
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 100, height: 60)
                                        .foregroundColor(Color(hex: 0xE5E5E5))
                                        .cornerRadius(10)
                                    Text(genre.0)
                                        .font(.system(size: 16))
                                        .bold()
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                .frame(height: 70)
                .padding(.leading, 15)
                .padding(.bottom, 10)
                
                DividerCategoryView(dividerText: "인기 영화")
                
                MovieSlideView(viewModel: viewModel, type: 0)
                    .padding(.bottom, 10)
                
                DividerCategoryView(dividerText: "현재 상영작")
                
                MovieSlideView(viewModel: viewModel, type: 1)
                
                Spacer()
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


