//
//  SeeAllView.swift
//  Moview
//
//  Created by 심관혁 on 9/20/24.
//

import SwiftUI

struct SeeAllView: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
//                ForEach(viewModel.genreMovies, id: \.id) { movie in
//                    NavigationLink(destination: DetailView(movie: movie)) {
//                        MoviePosterView(movie: movie)
//                            .foregroundColor(.black)
//                    }
//                }
            }
        }
//        .navigationTitle(genre.0)
    }
}

#Preview {
    SeeAllView()
}
