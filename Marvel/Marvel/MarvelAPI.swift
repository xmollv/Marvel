//
//  MarvelAPI.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import CryptoSwift

final class MarvelAPI {
    fileprivate struct MarvelAPIConfig {
        static let privateKey = "73c7e99256c61901dc418726363093ae21875137"
        static let apiKey = "ad321125f046a097576f6f693ae69eef"
        static let timestamp = Date().timeIntervalSince1970.description
        static let hash = "\(timestamp)\(privateKey)\(apiKey)".md5()
    }
}
