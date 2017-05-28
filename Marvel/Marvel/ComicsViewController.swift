//
//  ComicsViewController.swift
//  Marvel
//
//  Created by Xavi Moll on 26/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class ComicsViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var dataProvider: DataProvider!
    // The DataSource has been extracted to it's own class
    var comicsCollectionViewDataProvider: ComicsDataProvider!
    var isFetchingData = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func configureViewController() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = Stylesheet.Color.grey1
        title = "Comics"
        customizeCollectionView()
    }
    
    private func customizeCollectionView() {
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        comicsCollectionViewDataProvider = ComicsDataProvider(in: self, using: self.dataProvider)
        collectionView.dataSource = comicsCollectionViewDataProvider
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 10, 10)
    }
    
    func fetchData() {
        dataProvider.get(.comics(offset: comicsCollectionViewDataProvider.offset)) { [weak weakSelf = self] (result: Result<[Comic]>) in
            switch result {
            case .isSuccess(let comics):
                weakSelf?.comicsCollectionViewDataProvider.updateComics(comics: comics)
            case .isFailure(let error):
                if let weakSelf = weakSelf { MarvelError.handle(error: error, onCurrentViewController: weakSelf) }
            }
            
            DispatchQueue.main.async {
                weakSelf?.collectionView.reloadData()
                weakSelf?.isFetchingData = false
            }
        }
    }

}

// The UICollectionViewDelegate & UICollectionViewDelegateFlowLayout should probably go into it's own class to avoid a massive view controller
// but because we are using just a few of them, i've just extracted the UICollectionViewDataSource
extension ComicsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("The layout for the collection view was not a UICollectionViewFlowLayout")
        }
        
        // The number of cells changes based on the device orientation
        var cellsForRow: CGFloat = 2.0
        if collectionView.bounds.size.width > collectionView.bounds.size.height {
            cellsForRow = 3.0
        }
        
        let cellSpacing = flowLayout.minimumInteritemSpacing
        let collectionViewInsetsWidth = collectionView.contentInset.left + collectionView.contentInset.right
        
        let collectionViewWidthMinusInsets = collectionView.bounds.size.width - collectionViewInsetsWidth
        let collectionViewWidthMinusCellSpacing = collectionViewWidthMinusInsets - (cellSpacing * (cellsForRow - 1))
        let widthCell = collectionViewWidthMinusCellSpacing / cellsForRow
        
        let sizeToReturn = CGSize(width: widthCell, height: 280)
        return sizeToReturn
    }
}

extension ComicsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = ComicDetailsViewController.instantiateFrom(storyboard: .ComicDetailsViewController)
        detailViewController.dataProvider = dataProvider
        detailViewController.comic = comicsCollectionViewDataProvider.comic(at: indexPath.row)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // This method enables the pagination for the API calls. We should display an UIActivityIndicator at the bottom
    // of the UICollectionView when the app is requesting more items. To ship the app earlier, I've avoided it.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView.contentOffset.y > (self.collectionView.contentSize.height - self.collectionView.bounds.size.height) {
            if !isFetchingData && !comicsCollectionViewDataProvider.isSearchingComics {
                isFetchingData = true
                fetchData()
            }
        }
    }
}
// The UISearchBarDelegate should probably go into it's own class to avoid a massive view controller
extension ComicsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let textQuery = searchBar.text else {
            searchBar.text = ""
            searchBar.resignFirstResponder()
            return
        }
        
        if textQuery.trimmingCharacters(in: .whitespaces) == "" {
            comicsCollectionViewDataProvider.isSearchingComics = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
            self.collectionView.reloadData()
        }
    }
    
    // I've decided to make the search only when the user types the entire search query instead of searching every time
    // the value changes, because i've experienced some queries taking up to 50s to process the first time. The next time
    // the same query is fired, it works way faster (i guess they are caching it in some Redis or something similar), but it's
    // unusable most of the time
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let textQuery = searchBar.text else { return }
        searchBar.resignFirstResponder()
        if textQuery.trimmingCharacters(in: .whitespaces) == "" {
            searchBar.text = ""
            return
        }
        
        dataProvider.get(MarvelEndpoint.searchComics(query: textQuery)) { [weak weakSelf = self] (result: Result<[Comic]>) in
            switch result {
            case .isSuccess(let comics):
                weakSelf?.comicsCollectionViewDataProvider.isSearchingComics = true
                weakSelf?.comicsCollectionViewDataProvider.updateComics(comics: comics)
            case .isFailure(let error):
                if let weakSelf = weakSelf { MarvelError.handle(error: error, onCurrentViewController: weakSelf) }
            }
            
            DispatchQueue.main.async {
                weakSelf?.collectionView.reloadData()
            }
        }
    }
}
