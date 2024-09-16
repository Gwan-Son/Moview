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
        let url = "https://api.themoviedb.org/3/discover/movie"
        
        let params: [String: String] = [
            "api_key": apiKey,
            "include_adult": "false",
            "include_video": "false",
            "language": "ko-KR",
            "page": "1",
            "sort_by": "popularity.desc"
        ]
        
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
