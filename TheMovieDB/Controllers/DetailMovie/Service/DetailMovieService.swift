//
//  DetailMovieService.swift
//  TheMovieDB
//
//  Created by Dedy Yuristiawan on 28/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation

protocol DetailMovieService {
    
    func fetchDetailMovie(id: Int,
    successHandler: @escaping (_ response: Movie) -> Void,
    errorHandler: @escaping(_ error: Error) -> Void)
}
