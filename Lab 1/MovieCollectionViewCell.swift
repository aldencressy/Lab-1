//
//  MovieCollectionCollectionViewCell.swift
//  Lab 1
//
//  Created by Ashley Cardot on 9/22/24.
//
//
// meant to be same thing as movieDetailViewController, just need it to work with FavoritesCollectionViewCell
    

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var watchedSwitch: UISwitch!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        // Configure favorite button styling
        //favoriteButton.layer.borderWidth = 2.0
        //favoriteButton.layer.borderColor = UIColor.black.cgColor
        //favoriteButton.layer.cornerRadius = 10
        //favoriteButton.layoutIfNeeded()
    }
    
    func configure(with movie: Movie) {
        self.movie = movie
        //titleLabel.text = movie.title
        //genreLabel.text = movie.genre
        if let url = URL(string: movie.imageURL) {
            loadImage(from: url)
        } else {
            movieImageView.image = UIImage(named: "placeholder_image")
        }
        //updateFavoriteButton()
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self?.movieImageView.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self?.movieImageView.image = UIImage(named: "error_image") // Optional error placeholder
                }
            }
        }.resume()
    }

}
