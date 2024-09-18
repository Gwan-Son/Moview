//
//  MovieService.swift
//  Moview
//
//  Created by 심관혁 on 9/14/24.
//

import Foundation
import Alamofire

class MovieService {
    let apiKey = Bundle.main.infoDictionary?["APIKEY"] as! String
    
    func getMovie(completion: @escaping (MovieResponse?) -> Void) {
        let additionalParams = [
            "include_adult": "false",
            "include_video": "false",
            "sort_by": "popularity.desc"
        ]
        
        fetchMovie(from: "/discover/movie", with: additionalParams, completion: completion)
    }
    
    func getPopularMovie(completion: @escaping (MovieResponse?) -> Void) {
        fetchMovie(from: "/movie/popular", completion: completion)
    }
    
    func getNowPlayingMovie(completion: @escaping (MovieResponse?) -> Void) {
        fetchMovie(from: "/movie/now_playing", completion: completion)
    }
    
    func getTopRatedMovie(completion: @escaping (MovieResponse?) -> Void) {
        fetchMovie(from: "movie/top_rated", completion: completion)
    }
    
    
    func fetchMovie(from endpoint: String, with additionalParams: [String: String] = [:], completion: @escaping (MovieResponse?) -> Void) {
        let baseURL = "https://api.themoviedb.org/3"
        let url = baseURL + endpoint
        
        var params: [String: String] = [
            "api_key": apiKey,
            "language": "ko-KR",
            "page": "1"
        ]
        
        params.merge(additionalParams) { (_, new) in new }
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default)
            .responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
