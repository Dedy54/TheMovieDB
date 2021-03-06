//
//  ListMovieViewController.swift
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

class ListMovieViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var nextPageLoadingSpinner: UIActivityIndicatorView?
    private var movieListViewViewModel: MovieListViewViewModel!
    private let disposeBag = DisposeBag()
    private var endPoint:Endpoint = .popular
    private var page : Int = 1
    
    lazy var refreshControls: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.systemGray
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControls: UIRefreshControl) {
        self.movieListViewViewModel.refreshListMovies()
    }
    
    static func instantiateViewController(endPoint: Endpoint) -> ListMovieViewController {
        let controller = R.storyboard.listMovie.listMovieViewController()!
        controller.endPoint = endPoint
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.getListMovies()
    }
    
    // MARK: API
    private func getListMovies() {
        movieListViewViewModel = MovieListViewViewModel(endpoint: self.endPoint
            , movieService: CoreStore.shared)
        
        movieListViewViewModel.movies.drive(onNext: {[weak self] (_) in
            self?.refreshControls.endRefreshing()
            self?.update(isLoadingNextPage: false)
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        movieListViewViewModel.error.drive(onNext: {(error) in
            print(error?.description ?? "")
        }).disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .gray
        self.title = self.endPoint.description
        self.createTableView()
    }
    
    private func createTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        self.tableView.register(UINib(nibName: "ListMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "ListMovieTableViewCell")
        self.tableView.addSubview(refreshControls)
    }
    
    // MARK: load more
    func update(isLoadingNextPage: Bool) {
        if isLoadingNextPage {
            self.nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = UIActivityIndicatorView(style: .medium)
            nextPageLoadingSpinner?.startAnimating()
            nextPageLoadingSpinner?.isHidden = false
            nextPageLoadingSpinner?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.frame.width, height: 44)
            tableView.tableFooterView = nextPageLoadingSpinner
            
            self.movieListViewViewModel.loadNextPage()
        } else {
            tableView.tableFooterView = nil
        }
    }
}

extension ListMovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 192
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewViewModel.numberOfMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListMovieTableViewCell", for: indexPath) as? ListMovieTableViewCell else {
            return UITableViewCell()
        }
        if let viewModel = movieListViewViewModel.viewModelForMovie(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        
        if indexPath.row == movieListViewViewModel.numberOfMovies - 1 {
            self.update(isLoadingNextPage: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let viewModel = movieListViewViewModel.viewModelForMovie(at: indexPath.row) {
            let detailView = DetailMovieViewController.instantiateViewController(viewModel: viewModel)
            UINavigationController.currentActiveNavigationController()?.pushViewController(detailView, animated: true)
        }
    }
}
