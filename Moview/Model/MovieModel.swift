//
//  MovieModel.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import Foundation

struct MovieModel: Hashable, Identifiable {
    var backdrop_path: String
    var id: Int
    var original_language: String
    var original_title: String
    var overview: String
    var popularity: Double
    var poster_path: String
    var release_date: String
    var title: String
    var vote_average: Double
    var vote_count: Int
}

extension MovieModel {
    init(from result: Result) {
        self.init(
            backdrop_path: "https://image.tmdb.org/t/p/original\(result.backdropPath)",
            id: result.id,
            original_language: result.originalLanguage,
            original_title: result.originalTitle,
            overview: result.overview,
            popularity: result.popularity,
            poster_path: "https://image.tmdb.org/t/p/w500\(result.posterPath)",
            release_date: result.releaseDate,
            title: result.title,
            vote_average: result.voteAverage * 0.1,
            vote_count: result.voteCount
        )
    }
}
