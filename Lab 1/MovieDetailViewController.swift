import UIKit

class MovieDetailViewController: UIViewController, UIScrollViewDelegate {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var watchedSwitch: UISwitch!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var movieManager: MovieManager!
    var movieID: Int?
    var isWatched: Bool = false
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movieID = movieID, let movie = movieManager.getMovie(byID: movieID) else {
            print("Movie not found")
            return
        }
        
        self.movie = movie
                
        updateFavoriteButton()  // Update the button title

        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0

        self.title = movie.title
        
        titleLabel.text = "Title: \(movie.title)"
        genreLabel.text = "Genre: \(movie.genre)"
        
        if let url = URL(string: movie.imageURL) {
            loadImage(from: url)
        } else {
            movieImageView.image = UIImage(named: "placeholder_image") // Optional placeholder
        }
        watchedSwitch.isOn = isWatched
    }
    
    @IBAction func watchedSwitchToggled(_ sender: UISwitch) {
            isWatched = sender.isOn
            print("Watched status is now: \(isWatched)") // so i could test if working ->maybe add more to this later 
            
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
    
    // Favorite button action to add/remove from favorites
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let movie = movie else { return }
            
        if FavoritesManager.shared.isFavorite(movie) {
            FavoritesManager.shared.removeFavorite(movie)
        } else {
            FavoritesManager.shared.addFavorite(movie)
        }
            
        updateFavoriteButton()  // Update button text after action
    }
        
        // Update favorite button based on the movie's favorite status
    private func updateFavoriteButton() {
        guard let movie = movie else { return }
            
        if FavoritesManager.shared.isFavorite(movie) {
            favoriteButton.setTitle("Remove from Favorites", for: .normal)
        } else {
            favoriteButton.setTitle("Add to Favorites", for: .normal)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return movieImageView
    }
    
}
