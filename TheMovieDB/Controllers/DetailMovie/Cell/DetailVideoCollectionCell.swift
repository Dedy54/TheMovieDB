//
//  DetailVideoCollectionCell.swift
//  TheMovieDB
//
//  Created by Dedy Yuristiawan on 29/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import UIKit
import Foundation
import Nuke

class DetailVideoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(viewModel: MovieVideo) {
        Nuke.loadImage(
            with: viewModel.backdropURL,
            options: ImageLoadingOptions(
                transition: .fadeIn(duration: 0.33)
            ),
            into: self.videoImageView
        )
    }
    
}
