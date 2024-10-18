//
//  FavoriteViewModel.swift
//  Moview
//
//  Created by 심관혁 on 10/17/24.
//

import Foundation

class FavoriteViewModel: ObservableObject {
    @Published var movies: [MovieModel] = []
    
    func loadFavorite(_ data: [UserFavorite]) {
        movies = []
        for favorite in data {
            movies.append(MovieModel(backdrop_path: "", id: Int(favorite.id!)!, original_language: "", original_title: "", overview: "", popularity: 0, poster_path: favorite.poster_path, release_date: "", title: favorite.title, vote_average: favorite.vote_average, vote_count: 0))
        }
    }
}
