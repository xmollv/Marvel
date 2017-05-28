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
    
    fileprivate let dataProvider: DataProvider
    fileprivate var comics: [Comic]?
    fileprivate var searchResults: [Comic]?
    var isSearchingComics = false
    weak var comicsViewController: ComicsViewController? = nil
    var offset: Int {
       return comics?.count ?? 0
    }
    
    init(in comicsViewController: ComicsViewController, using dataProvider: DataProvider) {
        self.comics = nil
        self.searchResults = nil
        self.comicsViewController = comicsViewController
        self.dataProvider = dataProvider
    }
    
    func updateComics(comics: [Comic]?) {
        if isSearchingComics {
            self.searchResults = comics
        } else {
            if self.comics == nil {
                self.comics = []
            }
            comics?.forEach({ self.comics?.append($0) })
        }
    }
    
    func comic(at index: Int) -> Comic? {
        if isSearchingComics {
            return searchResults?[index]
        } else {
            return comics?[index]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var optionalComicsCount: Int?
        if isSearchingComics {
            optionalComicsCount = searchResults?.count
        } else {
            optionalComicsCount = comics?.count
        }
        
        guard let comicsCount = optionalComicsCount else {
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
        var optionalComic: Comic?
        if isSearchingComics {
            optionalComic = searchResults?[indexPath.row]
        } else {
            optionalComic = comics?[indexPath.row]
        }
        guard let comic = optionalComic else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicsCell", for: indexPath) as! ComicsCell
        cell.configure(with: comic)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchBarHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchBarComics", for: indexPath) as! SearchBarComicsReusableView
        searchBarHeader.searchBar.delegate = comicsViewController
        return searchBarHeader
    }
}
