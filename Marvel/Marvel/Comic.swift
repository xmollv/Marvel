//
//  Comic.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation

protocol JSONInitiable {
    init?(dict: JSONDictionary)
}

struct Comic {
    let id: Int?
    let title: String?
    let description: String?
    let pageCount: Int?
    let thumbnail: String?
    
}

extension Comic: JSONInitiable {
    init?(dict: JSONDictionary) {
        if let id = dict["id"] as? Int { self.id = id } else { self.id = nil }
        if let title = dict["title"] as? String { self.title = title } else { self.title = nil }
        if let description = dict["description"] as? String { self.description = description } else { self.description = nil }
        if let pageCount = dict["pageCount"] as? Int { self.pageCount = pageCount } else { self.pageCount = nil }
        if let thumbnailDict = dict["thumbnail"] as? JSONDictionary {
            if let path = thumbnailDict["path"] as? String, let thumbnailExtension = thumbnailDict["extension"] as? String {
                self.thumbnail = "\(path).\(thumbnailExtension)"
            } else {
                self.thumbnail = nil
            }
        } else {
            self.thumbnail = nil
        }
    }
}
