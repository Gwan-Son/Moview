//
//  MovieModel.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import Foundation

struct MovieModel: Hashable, Identifiable {
    var id: Int
    var original_language: OriginalLanguage
    var original_title: String
    var overview: String
    var popularity: Double
    var poster_path: String
    var release_date: String
    var title: String
    var vote_average: String
    var vote_count: Int
}
