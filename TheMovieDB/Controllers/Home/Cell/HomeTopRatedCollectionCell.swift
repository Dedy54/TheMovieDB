//
//  HomeTopRatedCollectionCell.swift
//  TheMovieDB
//
//  Created by Dedy Yuristiawan on 28/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class HomeTopRatedCollectionCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    private var movieListViewViewModel: MovieListViewViewModel!
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupLayoutCollectionView()
        self.getListMovies()
    }

    private func setupLayoutCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = .white
        self.collectionView.register(UINib(nibName: "HomeFilmViewCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeFilmViewCellCollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    // MARK: API
    private func getListMovies() {
        movieListViewViewModel = MovieListViewViewModel(endpoint: .topRated
            , movieService: CoreStore.shared)
        
        movieListViewViewModel.movies.drive(onNext: {[weak self] (_) in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        movieListViewViewModel.error.drive(onNext: {(error) in
            print(error?.description ?? "")
        }).disposed(by: disposeBag)
    }

}

extension HomeTopRatedCollectionCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieListViewViewModel.numberOfMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeFilmViewCellCollectionViewCell.self), for: indexPath) as? HomeFilmViewCellCollectionViewCell else {
            fatalError()
        }
        if let viewModel = movieListViewViewModel.viewModelForMovie(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = movieListViewViewModel.viewModelForMovie(at: indexPath.row) {
            let detailView = DetailMovieViewController.instantiateViewController(viewModel: viewModel)
            UINavigationController.currentActiveNavigationController()?.pushViewController(detailView, animated: true)
        }
    }
    
}


extension HomeTopRatedCollectionCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: marginTopCell, left: marginCell, bottom: marginCell, right: marginCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return paddingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size_home_other
    }
}
