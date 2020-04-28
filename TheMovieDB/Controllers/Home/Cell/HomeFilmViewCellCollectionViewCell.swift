//
//  HomeFilmViewCellCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Dedy Yuristiawan on 28/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Nuke

class HomeFilmViewCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filmImageView: UIImageView!{
        didSet{
            filmImageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(viewModel: MovieViewViewModel) {
        self.titleLabel.text = viewModel.title
        Nuke.loadImage(
            with: viewModel.posterURL,
            options: ImageLoadingOptions(
                transition: .fadeIn(duration: 0.33)
            ),
            into: self.filmImageView
        )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.viewShadow()
    }

}
