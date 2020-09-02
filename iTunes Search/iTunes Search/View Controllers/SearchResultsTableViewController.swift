//
//  SearchResultsTableViewController.swift
//  iTunes Search
//
//  Created by Michael Stoffer on 5/24/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    // MARK: - @IBOutlets and Variables
    @IBOutlet var searchTypeSegment: UISegmentedControl!
    @IBOutlet var searchBar: UISearchBar!
    
    let searchResultsController = SearchResultController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.searchResultsController.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)

        let searchResult = self.searchResultsController.searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.creator

        return cell
    }
}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = self.searchBar.text else { return }
        
        var resultType: ResultType!
        switch self.searchTypeSegment.selectedSegmentIndex {
            case 0:
                resultType = .software
            case 1:
                resultType = .musicTrack
            case 2:
                resultType = .movie
            default:
                resultType = .software
        }
        
        self.searchResultsController.performSearch(searchTerm: searchTerm, resultType: resultType) { (error) in
            if let error = error {
                NSLog("Search was not able to return any results: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
