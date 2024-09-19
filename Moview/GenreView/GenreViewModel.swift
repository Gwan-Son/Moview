//
//  GenreViewModel.swift
//  Moview
//
//  Created by 심관혁 on 9/18/24.
//

import Foundation

class GenreViewModel: ObservableObject {
    @Published var genreMovies = [MovieModel]()
    @Published var isLoading: Bool = false
    
    private let movieService: MovieService
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func fetchGenreMovie(for genre: String) {
        isLoading = true
        
        movieService.getGenreMovie(for: genre) { [weak self] response in
            guard let self = self else { return }
            guard let results = response?.results else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            let movies = results.map { MovieModel(from: $0) }
            
            DispatchQueue.main.async {
                self.genreMovies = movies
                self.isLoading = false
            }
        }
    }
}
