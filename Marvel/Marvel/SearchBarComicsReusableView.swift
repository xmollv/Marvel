//
//  SearchBarComicsReusableView.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class SearchBarComicsReusableView: UICollectionReusableView {
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearReusableView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearReusableView()
    }
    
    func clearReusableView() {
        
    }
}
