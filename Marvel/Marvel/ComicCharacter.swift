//
//  Character.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation

struct ComicCharacter {
    let id: Int?
    let name: String?
    let thumbnail: String?
}

extension ComicCharacter: JSONInitiable {
    init(dict: JSONDictionary) {
        if let id = dict["id"] as? Int { self.id = id } else { self.id = nil }
        if let name = dict["name"] as? String { self.name = name } else { self.name = nil }
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
