//
//  FavoritesViewController.swift
//  Lab 1
//
//  Created by Ashley Cardot on 9/21/24.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMovieDetailFromFavorites", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetailFromFavorites",
            let destinationVC = segue.destination as? MovieDetailViewController,
            let indexPath = sender as? IndexPath {
                let selectedMovie = favoriteMovies[indexPath.row]
                destinationVC.movieManager = MovieManager.shared
                destinationVC.movieID = MovieManager.shared.allMovies.firstIndex(where: { $0.title == selectedMovie.title })
        }
    }

}
