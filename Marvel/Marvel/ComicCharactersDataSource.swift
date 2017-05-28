//
//  ComicCharactersDataSource.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

class ComicCharactersDataSource: NSObject, UICollectionViewDataSource {
    
    private var characters: [ComicCharacter]?
    
    override init() {
        self.characters = nil
    }
    
    func updateCharacters(characters: [ComicCharacter]?) {
        self.characters = characters
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let charactersCount = characters?.count else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            collectionView.backgroundView = activityIndicator
            return 0
        }
        
        if charactersCount == 0 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = "No characters found."
            collectionView.backgroundView = label
        } else {
            collectionView.backgroundView = nil
        }
        
        
        return charactersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let character = characters?[indexPath.row] else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCharacterCell", for: indexPath) as! ComicCharacterCell
        cell.configure(with: character)
        return cell
    }
    
}
