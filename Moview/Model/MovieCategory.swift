//
//  MovieCategory.swift
//  Moview
//
//  Created by 심관혁 on 9/18/24.
//

import Foundation

enum MovieCategory {
    case popular
    case nowPlaying
    
    var name: String {
        switch self {
        case .popular: return "인기영화"
        case .nowPlaying: return "현재 상영작"
        }
    }
}
