//
//  HomeHeaderSection.swift
//  TheMovieDB
//
//  Created by Dedy Yuristiawan on 28/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import UIKit

protocol HomeHeaderSectionDelegate {
    func didPressMore(withCell cell: HomeHeaderSection, withHomeSection homeSection : Int)
}

class HomeHeaderSection: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func actionButtonMore(_ sender: Any) {
        self.homeHeaderSectionDelegate?.didPressMore(withCell: self, withHomeSection: self.homeSection)
    }
    var homeHeaderSectionDelegate: HomeHeaderSectionDelegate?
    var homeSection : Int = HomeSection.popular
    
    func configure(title: String, homeSection : Int, homeHeaderSectionDelegate : HomeHeaderSectionDelegate) {
        self.titleLabel.text = title
        self.homeSection = homeSection
        self.homeHeaderSectionDelegate = homeHeaderSectionDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
