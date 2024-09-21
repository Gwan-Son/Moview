//
//  SeeAllViewModel.swift
//  Moview
//
//  Created by 심관혁 on 9/20/24.
//

import Foundation

class SeeAllViewModel: ObservableObject {
    @Published var movies: [MovieModel] = []
    @Published var isLoading: Bool = false
    
    private let movieService: MovieService
    var page: Int = 1
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    private func fetchMovies(with page: Int, for category: MovieCategory) {
        isLoading = true
        
        let completion: (MovieResponse?) -> Void = { [weak self] response in
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
                    self.movies = movies
                } else {
                    self.movies.append(contentsOf: movies)
                }
                self.isLoading = false
            }
        }
        
        switch category {
        case .popular:
            if page == 0 {
                movieService.getPopularMovie(completion: completion)
            } else {
                movieService.getPopularMovie(page: page, completion: completion)
            }
        case .nowPlaying:
            if page == 0 {
                movieService.getNowPlayingMovie(completion: completion)
            } else {
                movieService.getNowPlayingMovie(page: page, completion: completion)
            }
        }
    }
    
    func fetchPopularMovie() {
        fetchMovies(with: 0, for: .popular)
    }
    
    func fetchNowPlaying() {
        fetchMovies(with: 0, for: .nowPlaying)
    }
    
    func addItem(category: MovieCategory) {
        page += 1
        switch category {
        case .popular:
            fetchMovies(with: page, for: .popular)
        case .nowPlaying:
            fetchMovies(with: page, for: .nowPlaying)
        }
    }
}
