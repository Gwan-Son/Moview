//
//  ContentView.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel()
    
    let genres: [(String, Int)] = [("액션",28),("모험",12),("애니메이션",16),("코미디",35),("범죄",80),("다큐멘터리",99),("드라마",18),("가족",10751),("판타지",14),("역사",36),("공포",27),("음악",10402),("미스터리",9648),("로맨스",10749),("SF",878),("TV 영화",10770),("스릴러",53),("전쟁",10752),("서부",37)]
    
    var body: some View {
        VStack {
            // 추천 영화
            CardView(viewModel: viewModel)
            
            // TODO: - Category Tab
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(genres, id: \.1) { genre in
                        Button {
                            // TODO: - See Category Tab
                            print("선택된 장르: \(genre)")
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 100, height: 80)
                                    .foregroundColor(Color.random)
                                    .cornerRadius(10)
                                Text(genre.0)
                                    .font(.system(size: 18))
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .frame(height: 100)
            .padding(.leading, 10)
            
            // TODO: - Divide Subview
            HStack {
                Rectangle()
                    .frame(width: 5, height: 40)
                    .foregroundColor(.orange)
                
                Text("인기 영화")
                    .font(.system(size: 20))
                    .bold()
                
                Spacer()
                
                Button {
                    // TODO: - See All Movie List
                    print("모두 보기 클릭!")
                } label: {
                    Text("모두 보기")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                }
            }
            .padding(.horizontal, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(viewModel.movies) { movie in
                        VStack(spacing: 10) {
                            KFImage(URL(string: movie.poster_path))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .shadow(radius: 10)
                            
                            VStack {
                                Text(movie.title)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 100)
                                
                                Text(movie.original_title)
                                    .font(.system(size: 10))
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 100)
                                
                                Text(movie.vote_average)
                                    .font(.system(size: 10))
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
}

#Preview {
    ContentView()
}
