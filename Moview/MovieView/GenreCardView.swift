//
//  CategoryCardView.swift
//  Moview
//
//  Created by 심관혁 on 9/18/24.
//

import SwiftUI

struct GenreCardView: View {
    @StateObject var viewModel = GenreViewModel(movieService: MovieService())
    let genres = Genres.allGenres
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(genres, id: \.1) { genre in
                    NavigationLink(destination: GenreView(viewModel: viewModel, genre: genre)) {
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
    }
}


#Preview {
    GenreCardView()
}
