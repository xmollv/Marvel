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
    
    lazy var navController: NavigationViewController = {
        let vc = NavigationViewController.instantiateFrom(storyboard: .NavigationViewController)
        vc.tabBarItem = UITabBarItem(title: "Comics", image: nil, selectedImage: nil)
        vc.dataProvider = self.dataProvider
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([navController], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
