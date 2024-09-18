//
//  MovieViewModel.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var popularMovies = [MovieModel]()
    @Published var nowPlayingMovies = [MovieModel]()
    @Published var isLoading: Bool = false
    
    private let movieService: MovieService
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    private func fetchMovies(for category: MovieCategory) {
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
                switch category {
                case .popular:
                    self.popularMovies = movies
                case .nowPlaying:
                    self.nowPlayingMovies = movies
                }
                self.isLoading = false
            }
        }
        
        switch category {
        case .popular:
            movieService.getPopularMovie(completion: completion)
        case .nowPlaying:
            movieService.getNowPlayingMovie(completion: completion)
        }
    }
    
    func fetchPopularMovie() {
        fetchMovies(for: .popular)
    }
    
    func fetchNowPlaying() {
        fetchMovies(for: .nowPlaying)
    }
    
}
