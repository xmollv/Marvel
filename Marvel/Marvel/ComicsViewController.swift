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
    var comics: [Comic]?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        dataProvider.getComics { [weak weakSelf = self] result in
            switch result {
            case .isSuccess(let comics):
                weakSelf?.comics = []
                comics?.forEach({ weakSelf?.comics?.append($0) })
            case .isFailure(let error):
                dump(error)
            }
            
            DispatchQueue.main.async {
                weakSelf?.collectionView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }

}

extension ComicsViewController: UICollectionViewDataSource {
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
}

extension ComicsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("The layout for the collection view was not a UICollectionViewFlowLayout")
        }
        
        let cellsForRow: CGFloat = 2.0 // This could be customized by the user or when the app is in landscape/iPad
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
        Logger.log(message: "Tapped: \(indexPath.row)", event: .debug)
        let detailViewController = ComicDetailsViewController.instantiateFrom(storyboard: .ComicDetailsViewController)
        detailViewController.dataProvider = dataProvider
        detailViewController.comic = comics?[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
