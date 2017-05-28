//
//  ComicsDataProvider.swift
//  Marvel
//
//  Created by Xavi Moll on 28/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

class ComicsDataProvider: NSObject, UICollectionViewDataSource {
    
    private var comics: [Comic]?
    
    override init() {
        self.comics = nil
    }
    
    func updateComics(comics: [Comic]?) {
        self.comics = comics
    }
    
    func comic(at index: Int) -> Comic? {
        return comics?[index]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let comicsCount = comics?.count else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            collectionView.backgroundView = activityIndicator
            return 0
        }
        
        if comicsCount == 0 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = "No comics found."
            collectionView.backgroundView = label
        } else {
            collectionView.backgroundView = nil
        }
        
        return comicsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let comic = comics?[indexPath.row] else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicsCell", for: indexPath) as! ComicsCell
        cell.configure(with: comic)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchBarHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchBarComics", for: indexPath) as! SearchBarComicsReusableView
        searchBarHeader.searchBar.delegate = self
        return searchBarHeader
    }
}

extension ComicsDataProvider: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
