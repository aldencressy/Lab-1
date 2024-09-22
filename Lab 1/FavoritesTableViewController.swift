//
//  FavoritesViewController.swift
//  Lab 1
//
//  Created by Ashley Cardot on 9/21/24.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    var favoriteMovies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteMovies = FavoritesManager.shared.getFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Update the list when returning from detail view
            favoriteMovies = FavoritesManager.shared.getFavorites()
            tableView.reloadData()
    }
    


    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieCell", for: indexPath)
        let movie = favoriteMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }

}
