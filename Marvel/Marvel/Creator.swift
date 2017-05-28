//
//  Creator.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation

struct Creator {
    let id: Int?
    let firstName: String?
    let lastName: String?
}

extension Creator: JSONInitiable {
    init(dict: JSONDictionary) {
        if let id = dict["id"] as? Int { self.id = id } else { self.id = nil }
        if let firstName = dict["firstName"] as? String { self.firstName = firstName } else { self.firstName = nil }
        if let lastName = dict["lastName"] as? String { self.lastName = lastName } else { self.lastName = nil }
    }
}
