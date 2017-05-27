//
//  ComicCharacterCell.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

class ComicCharacterCell: UICollectionViewCell {
    
    @IBOutlet var characterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        characterImageView.contentMode = .scaleAspectFill
        characterImageView.layer.cornerRadius = characterImageView.bounds.size.width / 2
        characterImageView.clipsToBounds = true
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    private func clearCell() {
        characterImageView.image = nil
    }
    
    func configure(with character: ComicCharacter) {
        characterImageView.sd_setImage(with: URL(string: character.thumbnail ?? ""))
    }
}
