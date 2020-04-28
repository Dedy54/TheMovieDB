//
//  DetailMovieViewController.swift
//  TheMovieDB
//
//  Created by Dedy Yuristiawan on 28/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Nuke
import AVKit
import YoutubeDirectLinkExtractor

class DetailMovieViewController: UIViewController {
    
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    
    private let extractor = LinkExtractor()
    var heightLabelReadMore : CGFloat = 120.0
    var viewModel: MovieViewViewModel!
    
    private var movieDetailViewViewModel: MovieDetailViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: API
    private func getDetailMovie() {
        movieDetailViewViewModel = MovieDetailViewModel(idMovie: self.viewModel.idMovie
            , detailMovieService: CoreStore.shared)
        
        movieDetailViewViewModel.movie.drive(onNext: {[weak self] (_) in
            self?.setupView()
        }).disposed(by: disposeBag)
        
        movieDetailViewViewModel.error.drive(onNext: {(error) in
            print(error?.description ?? "")
        }).disposed(by: disposeBag)
    }
    
    static func instantiateViewController(viewModel: MovieViewViewModel) -> DetailMovieViewController {
        let controller = R.storyboard.detailMovie.detailMovieViewController()!
        controller.viewModel = viewModel
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCollectionView()
        self.getDetailMovie()
    }
    
    func setupView(){
        if let model = movieDetailViewViewModel.viewModel() {
            self.titleLabel.text = model.title
            
            Nuke.loadImage(
                with: model.posterURL,
                options: ImageLoadingOptions(
                    transition: .fadeIn(duration: 0.33)
                ),
                into: self.filmImageView
            )
            
            self.videosCollectionView.reloadData()
        }
    }
    
    private func createCollectionView() {
        self.title = "Detail Movie"
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.videosCollectionView.collectionViewLayout = layout
        self.videosCollectionView.backgroundColor = .white
        self.videosCollectionView.register(UINib(nibName: "DetailVideoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "DetailVideoCollectionCell")
        self.videosCollectionView.delegate = self
        self.videosCollectionView.dataSource = self
    }

}

extension DetailMovieViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = movieDetailViewViewModel.viewModel() {
            return model.videos.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailVideoCollectionCell", for: indexPath) as? DetailVideoCollectionCell else {
            fatalError()
        }
        if let model = movieDetailViewViewModel.viewModel() {
            cell.configure(viewModel: model.videos[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = movieDetailViewViewModel.viewModel() {
            let movie = model.videos[indexPath.row]
            extractor.getUrlFromKey(key: movie.key) {(url) in
                let player = AVPlayer(url: url)
                let vc = AVPlayerViewController()
                vc.player = player
                UINavigationController.currentActiveNavigationController()?.topViewController?.present(vc, animated: true, completion: {
                    vc.player?.play()
                })
            }
        }
    }
    
}

extension DetailMovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: marginCell, bottom: 0, right: marginCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return paddingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 165)
    }
    
}
