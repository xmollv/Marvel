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
    
    func getComics(completion: @escaping CompletionType<[Comic]?>) {
        marvelAPI.getComics { result in
            switch result {
            case .isSuccess(let json):
                guard let json = json as? JSONDictionary, let data = json["data"] as? JSONDictionary, let results = data["results"] as? JSONArray else {
                    completion(Result.isFailure(MarvelError.malformedJSON))
                    return
                }
                let comics = results.flatMap{ Comic(dict: $0) }
                completion(Result.isSuccess(comics))
            case .isFailure(let error):
                completion(Result.isFailure(error))
                
            }
        }
    }
    
}
