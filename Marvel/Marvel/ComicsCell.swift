//
//  ComicsCell.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

class ComicsCell: UICollectionViewCell {
    
    @IBOutlet var comicImageView: UIImageView!
    @IBOutlet var comicTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isOpaque = true
        contentView.backgroundColor = Stylesheet.Color.white
        comicImageView.contentMode = .scaleAspectFill
        comicTitleLabel.textAlignment = .center
        comicTitleLabel.font = UIFont.systemFont(ofSize: 14)
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    private func clearCell() {
        comicImageView.image = nil
        comicTitleLabel.text = nil
    }
}
