//
//  SearchResultController.swift
//  iTunes Search
//
//  Created by Michael Stoffer on 5/24/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

class SearchResultController {    
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    
    var searchResults: [SearchResult] = []
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchTermQueryItem = URLQueryItem(name: "term", value: searchTerm)
        let resultTypeQueryItem = URLQueryItem(name: "entity", value: resultType.rawValue)
        
        urlComponents?.queryItems = [searchTermQueryItem, resultTypeQueryItem]
        
        guard let requestURL = urlComponents?.url else { NSLog("requestURL is nil"); completion(NSError()); return }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(NSError()); return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let searchResult = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = searchResult.results
                completion(nil)
            } catch {
                NSLog("Unable to decode data into object of type [SearchResult]: \(error)")
                completion(error)
            }
        }.resume()
    }
}
