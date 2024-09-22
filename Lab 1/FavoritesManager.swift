//
//  FavoritesManager.swift
//  Lab 1
//
//  Created by Ashley Cardot on 9/21/24.
//


class FavoritesManager {
    static let shared = FavoritesManager() 
    
    private var favoriteMovies = [Movie]()
    
    func addFavorite(_ movie: Movie) {
        if !favoriteMovies.contains(where: { $0.title == movie.title }) {
            favoriteMovies.append(movie)
        }
    }
    
    func removeFavorite(_ movie: Movie) {
        favoriteMovies.removeAll { $0.title == movie.title }
    }
    
    func getFavorites() -> [Movie] {
        return favoriteMovies
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        return favoriteMovies.contains(where: { $0.title == movie.title })
    }
}
