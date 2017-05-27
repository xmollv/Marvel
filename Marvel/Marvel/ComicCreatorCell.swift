//
//  ComicCreatorCell.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

class ComicCreatorCell: UITableViewCell {
    
    @IBOutlet var creatorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Stylesheet.Color.clear
        creatorLabel.font = UIFont.systemFont(ofSize: 14)
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    private func clearCell() {
        creatorLabel.text = nil
    }
    
    func configure(with creator: Creator) {
        let name = creator.firstName ?? ""
        let lastName = creator.lastName ?? ""
        creatorLabel.text = "\(name) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
