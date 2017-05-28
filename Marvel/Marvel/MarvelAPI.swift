//
//  MarvelAPI.swift
//  Marvel
//
//  Created by Xavi Moll on 27/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import CryptoSwift

// Handy typealiases to reduce the methods signature
typealias JSONDictionary = Dictionary<String,Any>
typealias JSONArray = Array<JSONDictionary>
typealias CompletionType<T> = (Result<T>) -> ()

// This is what the completion handlers will return, making it extremely
// easy to switch between the two states of an API response
enum Result<T> {
    case isSuccess(T)
    case isFailure(Error)
}

// This struct holds the needed data to call the Marvel API
// The API keys should not be saved in a public repo, but for now it'll do
fileprivate struct MarvelAPIConfig {
    static let baseUrl = "https://gateway.marvel.com/v1/public"
    static let privateKey = "73c7e99256c61901dc418726363093ae21875137"
    static let apiKey = "ad321125f046a097576f6f693ae69eef"
    static let timestamp = Date().timeIntervalSince1970.description
    static let hash = "\(timestamp)\(privateKey)\(apiKey)".md5()
}

// This enum describes the endpoints that will be called by the App, reducing the
// method signature at the call site
enum MarvelEndpoint {
    case comics(offset: Int)
    case searchComics(query: String)
    case comicCharacters(comicId: Int)
    case comicCreators(comicId: Int)
    
    var path: String {
        let baseUrl = MarvelAPIConfig.baseUrl
        let apiAuth = "ts=\(MarvelAPIConfig.timestamp)&apikey=\(MarvelAPIConfig.apiKey)&hash=\(MarvelAPIConfig.hash)"
        switch self {
        case .comics(let offset):
            return "\(baseUrl)/comics?\(apiAuth)&offset=\(offset)"
        case .searchComics(let query):
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { Logger.log(message: "The queryParam was not encoded correctly.", event: .error); return "" }
            return "\(baseUrl)/comics?\(apiAuth)&titleStartsWith=\(encodedQuery)"
        case .comicCharacters(let comicId):
            return "\(baseUrl)/comics/\(comicId)/characters?\(apiAuth)"
        case .comicCreators(let comicId):
            return "\(baseUrl)/comics/\(comicId)/creators?\(apiAuth)"
        }
    }
}

final class MarvelAPI {
    
    private enum HTTPMethod: String {
        case get = "GET"
    }
    
    // Network activity indicator count and queue
    private var numberOfCallsToSetVisible = 0
    private let activityIndicatorQueue = DispatchQueue(label: "com.marvel.networkIndicator")
    
    /// Base method to perform network requests
    private func load(url: String, httpMethod: HTTPMethod = .get, completion: @escaping CompletionType<Data?>) {
        Logger.log(message: url, event: .debug)
        activityIndicatorQueue.sync {
            self.setNetworkActivityVisible(true)
        }
        
        // Return an error if the URL string that the call site sends us can not be converted to an URL
        guard let endpoint = URL(string: url) else {
            completion(Result.isFailure(MarvelError.request(.malformedURL)))
            return
        }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = httpMethod.rawValue
        
        // Add aditional headers to the HTTP request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            self.activityIndicatorQueue.sync {
                self.setNetworkActivityVisible(false)
            }
            
            // Error found, return early
            if let error = error {
                completion(Result.isFailure(error))
                return
            }
            
            completion(self.parseHTTPCode(response: response, data: data))
        }
        
        task.resume()
    }
    
    //MARK:- Network activity indicator visibility
    /// Handles the network activity indicator using a serial queue in the background
    private func setNetworkActivityVisible(_ visible: Bool) {
        if visible {
            numberOfCallsToSetVisible += 1
        } else {
            numberOfCallsToSetVisible -= 1
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.numberOfCallsToSetVisible > 0
        }
    }
    
    //MARK:- Default HTTP code parser
    /// Checks the HTTP code and tries to return the data or create a custom error
    private func parseHTTPCode(response: URLResponse?, data: Data?) -> Result<Data?> {
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...299:
                return Result.isSuccess(data)
            case 400...499:
                return Result.isFailure(MarvelError.response(.badRequest))
            case 500...599:
                return Result.isFailure(MarvelError.response(.internalServerError))
            default:
                // Cases 100...199, 300...399 are not being handled right now to develop the app faster
                return Result.isFailure(MarvelError.response(.invalidStatusCode))
            }
        } else {
            return Result.isFailure(MarvelError.response(.noHTTPURLResponse))
        }
    }
    
    //MARK:- Default JSON parser
    /// Gets the response from the server and tries to parse it into a JSON object
    private func parseResponse(networkResult: Result<Data?>) -> Result<Any?> {
        switch networkResult {
        case .isSuccess(let data):
            guard let data = data else { return Result.isSuccess(nil) }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                return Result.isSuccess(json)
            } catch (let error) {
                return Result.isFailure(error)
            }
        case .isFailure(let error):
            return Result.isFailure(error)
        }
    }

    // Default method to perform network requests based on the endpoint provided
    func request(endpoint: MarvelEndpoint, completion: @escaping CompletionType<Any?>) {
        load(url: endpoint.path) { networkResult in
            completion(self.parseResponse(networkResult: networkResult))
        }
    }
}
