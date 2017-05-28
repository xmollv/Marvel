//
//  DataProvider.swift
//  Marvel
//
//  Created by Xavi Moll on 26/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation

final class DataProvider {
    
    let marvelAPI = MarvelAPI()
    
    /// This method recieves an Endpoint object that describes the URL that's going to be called
    /// and a completion that will be called when the API returns a response. The Type of the completion
    /// is generic, this way we can use the same function to perform every network call, by just
    /// changing the Type in the call site. The Type of T must be JSONInitiable, that means that
    /// has to conform the JSONInitiable protocol.
    func get<T: JSONInitiable>(_ endpoint: MarvelEndpoint, completion: @escaping CompletionType<[T]>) {
        marvelAPI.request(endpoint: endpoint) { result in
            switch result {
            case .isSuccess(let json):
                guard let json = json as? JSONDictionary, let data = json["data"] as? JSONDictionary, let results = data["results"] as? JSONArray else {
                    completion(Result.isFailure(MarvelError.malformedJSON))
                    return
                }
                let comics = results.flatMap{ T(dict: $0) }
                completion(Result.isSuccess(comics))
            case .isFailure(let error):
                completion(Result.isFailure(error))
                
            }
        }
    }
    
}
