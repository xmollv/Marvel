//
//  TabBarViewController.swift
//  Marvel
//
//  Created by Xavi Moll on 26/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var dataProvider: DataProvider!
    
    lazy var navControllerForComics: UINavigationController = {
        let comicsViewController = ComicsViewController.instantiateFrom(storyboard: .ComicsViewController)
        comicsViewController.tabBarItem.image = UIImage(named: "spiderman")
        comicsViewController.dataProvider = self.dataProvider
        let navViewController = UINavigationController(rootViewController: comicsViewController)
        return navViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([navControllerForComics], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
