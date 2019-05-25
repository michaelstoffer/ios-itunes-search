//
//  SearchResult.swift
//  iTunes Search
//
//  Created by Michael Stoffer on 5/24/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    var title: String
    var creator: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case creator = "artistName"
    }
}

struct SearchResults: Codable {
    var results: [SearchResult]
}
