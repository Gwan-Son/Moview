//
//  DetailViewModel.swift
//  Moview
//
//  Created by 심관혁 on 9/19/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var movie: MovieDetailModel?
    
    private let movieService: MovieService
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func fetchMovie(id: Int) {
        movieService.getMovieDetail(id: id) { [weak self] response in
            guard let self = self else { return }
            guard let response = response else { return }
            self.movie = MovieDetailModel(from: response)
        }
    }
    
    func changeTime(runtime: Int) -> String {
        let hour = runtime / 60
        let minute = runtime % 60
        return "\(hour)시간 \(minute)분"
    }
    
}
