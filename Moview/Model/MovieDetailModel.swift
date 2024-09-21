//
//  MovieDetailModel.swift
//  Moview
//
//  Created by 심관혁 on 9/19/24.
//

import Foundation

struct MovieDetailModel: Identifiable {
    var backdropPath: String
    var belongsToCollection: BelongsToCollection
    var genres: [Genre]
    var id: Int
    var originCountry: [String]
    var originalLanguage, overview: String
    var posterPath: String
    var productionCompanies: [ProductionCompany]
    var productionCountries: [ProductionCountry]
    var releaseDate: String
    var runtime: Int
    var status, tagline, title: String
    var voteAverage: Double
    var voteCount: Int
}

extension MovieDetailModel {
    init(from result: MovieDetailResponse) {
        self.init(
            backdropPath: "https://image.tmdb.org/t/p/original\(result.backdropPath ?? "")",
            belongsToCollection: result.belongsToCollection ?? BelongsToCollection(id: 0, name: "", posterPath: "", backdropPath: ""),
            genres: result.genres,
            id: result.id,
            originCountry: result.originCountry,
            originalLanguage: result.originalLanguage,
            overview: result.overview,
            posterPath: "https://image.tmdb.org/t/p/w500\(result.posterPath ?? "")",
            productionCompanies: result.productionCompanies,
            productionCountries: result.productionCountries,
            releaseDate: result.releaseDate,
            runtime: result.runtime,
            status: result.status,
            tagline: result.tagline,
            title: result.title,
            voteAverage: result.voteAverage * 0.1,
            voteCount: result.voteCount
        )
    }
}
