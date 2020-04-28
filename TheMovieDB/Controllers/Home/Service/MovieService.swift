//
//  MovieService.swift
//  TheMovieDB
//
//  Created by Dedy Yuristiawan on 28/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation

protocol MovieService {
    
    func fetchMovies(from endpoint: Endpoint,
                     page: Int,
                     params: [String: String]?,
                     successHandler: @escaping (_ response: MoviesResponse) -> Void,
                     errorHandler: @escaping(_ error: Error) -> Void)
}

public enum Endpoint: String, CaseIterable, CustomStringConvertible {
    case popular = "popular"
    case topRated = "top_rated"
    
    public var description: String {
        switch self {
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        }
    }
    
    public init?(index: Int) {
        switch index {
        case 0: self = .popular
        case 1: self = .topRated
        default: return nil
        }
    }
}

public enum MovieError: Error {
    case apiError
    case invalidURL
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
