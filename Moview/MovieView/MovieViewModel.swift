//
//  MovieViewModel.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var movies = [MovieModel]()
    @Published var isLoading: Bool = false
    
    private let movieService = MovieService()
    
    init() {
        fetchMovie()
    }
    
    func fetchMovie() {
        movieService.getMovie { [weak self] response in
            guard let self = self else { return }
            guard let items = response?.results else { return }
            
            self.isLoading = true
            
            for item in items {
                let movie = MovieModel(
                    id: item.id,
                    original_language: item.originalLanguage,
                    original_title: item.originalTitle,
                    overview: item.overview,
                    popularity: item.popularity,
                    poster_path: item.posterPath,
                    release_date: item.releaseDate,
                    title: item.title,
                    vote_average: item.voteAverage,
                    vote_count: item.voteCount
                )
                self.movies.append(movie)
            }
            
            self.isLoading = false
        }
    }
    
}
