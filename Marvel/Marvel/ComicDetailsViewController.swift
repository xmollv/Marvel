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
        creatorsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        charactersLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        creatorsLabel.text = "CREATORS"
        charactersLabel.text = "CHARACTERS"
    }
    
    private func setupComicDetails(comic: Comic) {
        title = comic.title ?? "Unknown"
        comicImageView.sd_setImage(with: URL(string: comic.thumbnail ?? ""))
        comicDescriptionTextView.text = comic.description ?? "Description not found."
    }

}
