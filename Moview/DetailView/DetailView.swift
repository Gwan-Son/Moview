//
//  MovieDetailView.swift
//  Moview
//
//  Created by 심관혁 on 9/19/24.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    @EnvironmentObject private var firestoreManager: FirestoreManager
    @Environment(\.auth) private var authManager
    @StateObject var viewModel = DetailViewModel(movieService: MovieService())
    
    var movie: MovieModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack {
                    if viewModel.movie?.backdropPath == "https://image.tmdb.org/t/p/original" {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .padding(.top, 20)
                        Text("No Image")
                            .font(.system(size: 20))
                    } else {
                        KFImage(URL(string: viewModel.movie?.backdropPath ?? ""))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width)
                            .padding(.top, 1)
                    }
                    
                    
                    Spacer()
                }
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(viewModel.movie?.title ?? "정보없음")
                                .font(.system(size: 16))
                                .bold()
                            
                            Text(viewModel.movie?.releaseDate ?? "정보없음")
                                .font(.system(size: 12))
                            
                            Text(viewModel.movie?.productionCompanies.first?.name ?? "정보없음")
                                .font(.system(size: 14))
                            
                            Text(viewModel.changeTime(runtime: viewModel.movie?.runtime ?? 0))
                                .font(.system(size: 12))
                                .padding(.bottom, 10)
                            
                            DetailGenreView(genres: viewModel.movie?.genres ?? [])
                        }
                        CircularProgressView(progress: viewModel.movie?.voteAverage ?? 0)
                            .offset(x: 0, y: -50)
                        
                        Spacer()
                        
                        KFImage(URL(string: viewModel.movie?.posterPath ?? ""))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 5))
                    
                    VStack(spacing: 10) {
                        if viewModel.movie?.overview == "" {
                            Text("줄거리 없음")
                                .font(.system(size: 14))
                        } else {
                            Text(viewModel.movie?.overview ?? "정보없음")
                                .font(.system(size: 14))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    
                    
                }
                .background(.white)
                .cornerRadius(10)
                .padding(.horizontal, -15)
                .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 2.5)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2.35)
            }
            
        }
        .toolbar {
            Button {
                firestoreManager.updateFavorite(authManager.currentUser.userId!, id: viewModel.movie!.id, title: viewModel.movie!.title, poster_path: viewModel.movie!.posterPath, vote_average: viewModel.movie!.voteAverage)
                viewModel.isFavorite.toggle()
            } label: {
                viewModel.isFavorite ? Image(systemName: "star.fill") :    Image(systemName: "star")
            }
            .disabled(authManager.currentUser.userId == nil)
        }
        .task {
            viewModel.fetchMovie(id: movie.id)
            viewModel.fetchFavorite(isFavorite: firestoreManager.userData.movies.contains(where: { $0.id == movie.id }))
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
    DetailView(movie: MovieModel(backdrop_path: "https://image.tmdb.org/t/p/w500/jr8tSoJGj33XLgFBy6lmZhpGQNu.jpg", id: 315162, original_language: "en", original_title: "Puss in Boots: The Last Wish", overview: "아홉 개의 목숨 중 단 하나의 목숨만 남은 장화신은 고양이.  마지막 남은 목숨을 지키기 위해 히어로의 삶 대신 반려묘의 삶을 선택한 그에게 찾아온 마지막 기회, 바로 소원을 들어주는 소원별이 있는 곳을 알려주는 지도!  잃어버린 목숨을 되찾고 다시 히어로가 되기를 꿈꾸는 장화신은 고양이는 뜻밖에 동료가 된 앙숙 파트너 \'키티 말랑손\', 그저 친구들과 함께라면 모든 게 행복한 강아지 \'페로\'와 함께 소원별을 찾기 위해 길을 떠난다.  그리고 소원별을 노리는 또 다른 빌런들과 마주치게 되는데…", popularity: 152.013, poster_path: "https://image.tmdb.org/t/p/w500/rKgvctIuPXyuqOzCQ16VGdnHxKx.jpg", release_date: "2022-12-07", title: "장화신은 고양이: 끝내주는 모험", vote_average: 0.8226000000000001, vote_count: 7592))
}
