//
//  ComicDetailsViewController.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class ComicDetailsViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var comicImageView: UIImageView!
    @IBOutlet var creatorsLabel: UILabel!
    @IBOutlet var creatorsTableView: UITableView!
    @IBOutlet var comicDescriptionTextView: UITextView!
    @IBOutlet var charactersLabel: UILabel!
    @IBOutlet var charactersCollectionView: UICollectionView!
    
    var dataProvider: DataProvider!
    var comic: Comic!
    let charactersDataSource = ComicCharactersDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupComicDetails(comic: comic)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configureViewController() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = Stylesheet.Color.grey1
        containerView.backgroundColor = Stylesheet.Color.clear
        comicImageView.contentMode = .scaleAspectFill
        comicImageView.clipsToBounds = true
        comicImageView.layer.cornerRadius = 2
        
        comicDescriptionTextView.textAlignment = .justified
        comicDescriptionTextView.backgroundColor = Stylesheet.Color.clear
        // This fixes the unwanted padding in the UITextViews: https://stackoverflow.com/a/42333832/5683397
        comicDescriptionTextView.textContainerInset = UIEdgeInsets.zero
        comicDescriptionTextView.textContainer.lineFragmentPadding = 0
        
        creatorsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        charactersLabel.font = UIFont.boldSystemFont(ofSize: 14)
        creatorsLabel.text = "CREATORS"
        charactersLabel.text = "CHARACTERS"
        charactersCollectionView.dataSource = charactersDataSource
        charactersCollectionView.backgroundColor = Stylesheet.Color.clear
        // Let the cells scroll to the edge of the screen
        charactersCollectionView.clipsToBounds = false
        charactersCollectionView.showsHorizontalScrollIndicator = false
        // This enables the bounce even though there is only one item in the collection
        charactersCollectionView.alwaysBounceHorizontal = true
    }
    
    private func setupComicDetails(comic: Comic) {
        title = comic.title ?? "Unknown"
        comicImageView.sd_setImage(with: URL(string: comic.thumbnail ?? ""))
        comicDescriptionTextView.text = comic.description ?? "Description not found."
        setupComicCharacters(comicId: comic.id)
    }
    
    private func setupComicCharacters(comicId: Int?) {
        guard let comicId = comicId else { Logger.log(message: "The comic ID was nil", event: .warning); return }
        
        dataProvider.getComicCharacters(comicId: comicId) { [weak weakSelf = self] result in
            switch result {
            case .isSuccess(let characters):
                DispatchQueue.main.async {
                    weakSelf?.charactersDataSource.updateCharacters(characters: characters)
                    weakSelf?.charactersCollectionView.reloadData()
                }
            case .isFailure(let error):
                dump(error)
            }
        }
    }

}
