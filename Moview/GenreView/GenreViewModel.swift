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
    var page: Int = 1
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func fetchGenreMovie(with page: Int, for genre: String) {
        isLoading = true
        
        movieService.getGenreMovie(with: page, for: genre) { [weak self] response in
            guard let self = self else { return }
            guard let results = response?.results else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            let movies = results.map { MovieModel(from: $0) }
            
            DispatchQueue.main.async {
                if page == 0 {
                    self.genreMovies = movies
                } else {
                    self.genreMovies.append(contentsOf: movies)
                }
                self.isLoading = false
            }
        }
    }
    
    func addItem(genre: String) {
        page += 1
        fetchGenreMovie(with: page, for: genre)
    }
}
