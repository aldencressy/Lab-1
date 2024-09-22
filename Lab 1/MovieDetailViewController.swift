import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var watchedSwitch: UISwitch!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var movieManager: MovieManager!
    var movieID: Int?
    var isWatched: Bool = false
    var movie: Movie?
    var movieMarker: WatchedMoviesMarker?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movieID = movieID, let movie = movieManager.getMovie(byID: movieID) else {
            print("Movie not found")
            return
        }

        self.movie = movie

        self.title = movie.title

        titleLabel.text = "Title: \(movie.title)"
        genreLabel.text = "Genre: \(movie.genre)"

        if let url = URL(string: movie.imageURL) {
            loadImage(from: url)
        } else {
            movieImageView.image = UIImage(named: "placeholder_image")
        }

        // Check if the movie is watched and update the switch
        isWatched = movieManager.isMovieWatched(movie: movie)
        watchedSwitch.isOn = isWatched

        // Start blinking if the movie is marked as watched
        if isWatched {
            startBlinking()
        }

        // Set up tap recognizer for the movie image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        movieImageView.isUserInteractionEnabled = true
        movieImageView.addGestureRecognizer(tapGestureRecognizer)

        // Style the favorite button
        favoriteButton.layer.borderWidth = 2.0
        favoriteButton.layer.borderColor = UIColor.black.cgColor
        favoriteButton.layer.cornerRadius = 10
        favoriteButton.layoutIfNeeded()
        
        // Update the favorite button title
        updateFavoriteButton()
    }

    // Handle the switch toggle to mark a movie as watched/unwatched
    @IBAction func watchedSwitchToggled(sender: UISwitch) {
        guard let movieIndex = movieID, let movie = movieManager.getMovie(byID: movieIndex) else { return }

        isWatched = sender.isOn
        movieManager.setMovieWatchedStatus(movie: movie, watched: isWatched)

        if isWatched {
            startBlinking()
        } else {
            stopBlinking()
        }
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

    // Handle image tap to zoom
    @objc func imageTapped() {
        guard let image = movieImageView.image else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let imageZoomVC = storyboard.instantiateViewController(withIdentifier: "ImageZoomViewController") as? ImageZoomViewController {
            imageZoomVC.image = image
            self.navigationController?.pushViewController(imageZoomVC, animated: true)
        }
    }

    // Load image from the URL
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self?.movieImageView.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self?.movieImageView.image = UIImage(named: "error_image")
                }
            }
        }.resume()
    }

    // Scroll view zooming delegate method
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return movieImageView
    }

    
    private func startBlinking() {
        if movieMarker == nil, let label = titleLabel {
            movieMarker = WatchedMoviesMarker(label: label)
            movieMarker?.startBlinking()
        }
    }

    private func stopBlinking() {
        movieMarker?.stopBlinking()
        movieMarker = nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBlinking()
    }

}
