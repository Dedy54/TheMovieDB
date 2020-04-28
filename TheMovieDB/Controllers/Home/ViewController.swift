//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Dedy Yuristiawan on 28/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import UIKit

struct HomeSection {
    static let popular = 0
    static let toprated = 1
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createTitleView()
        self.setupLayoutCollectionView()
    }
    
    private func createTitleView() {
        self.navigationController?.title = "Home"
    }
    
    private func setupLayoutCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = .white
        self.collectionView.register(UINib(nibName: "HomePopularCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomePopularCollectionCell")
        self.collectionView.register(UINib(nibName: "HomeTopRatedCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeTopRatedCollectionCell")
        self.collectionView.register(UINib(nibName: "HomeHeaderSection", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeaderSection")
    }
    
    //MARK: Util function
    private func renderImgOriginal(named: String) -> UIImage {
        let imageView = UIImageView(image: UIImage(named: named))
        imageView.image = imageView.image!.withRenderingMode(.alwaysOriginal)
        imageView.tintColor = UIColor.clear
        return imageView.image ?? UIImage()
    }

    // MARK: Action button
    @objc private func profileClicked() {
    }
    
    @objc private func searchClicked() {
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == HomeSection.popular {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePopularCollectionCell", for: indexPath) as? HomePopularCollectionCell else {
                fatalError()
            }
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTopRatedCollectionCell", for: indexPath) as? HomeTopRatedCollectionCell else {
            fatalError()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeaderSection", for: indexPath) as? HomeHeaderSection else {
                    fatalError("Invalid view type")
            }
            headerView.backgroundColor = .white
            if indexPath.section == HomeSection.popular {
                headerView.configure(title: "Popular", homeSection: HomeSection.popular, homeHeaderSectionDelegate: self)
            }
            else if indexPath.section == HomeSection.toprated {
                headerView.configure(title: "Top Rate", homeSection: HomeSection.toprated, homeHeaderSectionDelegate: self)
            }
            
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: fullWidth, height: 30)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: fullWidth, height: 290)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension ViewController : HomeHeaderSectionDelegate {
    func didPressMore(withCell cell: HomeHeaderSection, withHomeSection homeSection: Int) {
        if homeSection == HomeSection.popular{
            let listView = ListMovieViewController.instantiateViewController(endPoint: .popular)
            UINavigationController.currentActiveNavigationController()?.pushViewController(listView, animated: true)
            return
        }
        
        let listView = ListMovieViewController.instantiateViewController(endPoint: .topRated)
        UINavigationController.currentActiveNavigationController()?.pushViewController(listView, animated: true)
    }
    
}
