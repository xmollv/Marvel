//
//  ComicCreatorsDataSource.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

class ComicCreatorsDataSource: NSObject, UITableViewDataSource {
    
    private var creators: [Creator]?
    
    override init() {
        self.creators = nil
    }
    
    func updateCreators(creators: [Creator]?) {
        self.creators = creators
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let creatorsCount = creators?.count else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            tableView.backgroundView = activityIndicator
            return 0
        }
        
        if creatorsCount == 0 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = "No creators found."
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
        
        return creatorsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let character = creators?[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComicCreatorCell", for: indexPath) as! ComicCreatorCell
        cell.configure(with: character)
        return cell
    }

}
