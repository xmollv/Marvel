//
//  MarvelError.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation

// This are the custom errors handled by the app
enum MarvelError: Error {
    case malformedJSON
    case request(RequestError)
    case response(ResponseError)
    
    enum RequestError {
        case malformedURL
    }
    
    enum ResponseError {
        case invalidStatusCode
        case noHTTPURLResponse
        case badRequest
        case internalServerError
    }
}
