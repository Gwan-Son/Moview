//
//  MoviePosterView.swift
//  Moview
//
//  Created by 심관혁 on 9/19/24.
//

import SwiftUI
import Kingfisher

struct MoviePosterView: View {
    var movie: MovieModel
    var body: some View {
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

#Preview {
    MoviePosterView(movie: MovieModel(backdrop_path: "https://image.tmdb.org/t/p/w500/waPt1Dv5kWhbNna5rTv2NGfeb7O.jpg", id: 315162, original_language: "en", original_title: "Puss in Boots: The Last Wish", overview: "아홉 개의 목숨 중 단 하나의 목숨만 남은 장화신은 고양이.  마지막 남은 목숨을 지키기 위해 히어로의 삶 대신 반려묘의 삶을 선택한 그에게 찾아온 마지막 기회, 바로 소원을 들어주는 소원별이 있는 곳을 알려주는 지도!  잃어버린 목숨을 되찾고 다시 히어로가 되기를 꿈꾸는 장화신은 고양이는 뜻밖에 동료가 된 앙숙 파트너 \'키티 말랑손\', 그저 친구들과 함께라면 모든 게 행복한 강아지 \'페로\'와 함께 소원별을 찾기 위해 길을 떠난다.  그리고 소원별을 노리는 또 다른 빌런들과 마주치게 되는데…", popularity: 152.013, poster_path: "https://image.tmdb.org/t/p/w500/rKgvctIuPXyuqOzCQ16VGdnHxKx.jpg", release_date: "2022-12-07", title: "장화신은 고양이: 끝내주는 모험", vote_average: 0.8226000000000001, vote_count: 7592))
}
