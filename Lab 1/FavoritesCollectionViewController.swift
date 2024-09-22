//
//  FavoritesViewController.swift
//  Lab 1
//
//  Created by Ashley Cardot on 9/21/24.
//

import UIKit

class FavoritesCollectionViewController: UICollectionViewController {
    
    var favoriteMovies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteMovies = FavoritesManager.shared.getFavorites()
        
        print("Favorite Movies Count: \(favoriteMovies.count)")
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        // Update the list when returning from detail view
        favoriteMovies = FavoritesManager.shared.getFavorites()
        collectionView.reloadData()
    }
    


    // MARK: - Navigation

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMovieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = favoriteMovies[indexPath.item]
        //cell.textLabel?.text = movie.title
        
        cell.configure(with: movie)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = favoriteMovies[indexPath.row]
        print("Selected movie: \(selectedMovie.title)")
        performSegue(withIdentifier: "showMovieDetailFromFavorites", sender: selectedMovie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetailFromFavorites",
            let destinationVC = segue.destination as? MovieDetailViewController,
            let movie = sender as? Movie {
            destinationVC.movie = movie
        }
    }

}
