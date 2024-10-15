//
//  DetailViewModel.swift
//  Moview
//
//  Created by 심관혁 on 9/19/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var movie: MovieDetailModel?
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false
    
    private let movieService: MovieService
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func fetchMovie(id: Int) {
        isLoading = true
        movieService.getMovieDetail(id: id) { [weak self] response in
            guard let self = self else { return }
            guard let response = response else { return }
            DispatchQueue.main.async {
                self.movie = MovieDetailModel(from: response)
                self.isLoading = false
            }
        }
    }
    
    func fetchFavorite(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    func changeTime(runtime: Int) -> String {
        let hour = runtime / 60
        let minute = runtime % 60
        return "\(hour)시간 \(minute)분"
    }
    
}
