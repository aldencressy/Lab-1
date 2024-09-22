import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var watchedSwitch: UISwitch!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var watchCountLabel: UILabel!
    @IBOutlet weak var watchCountStepper: UIStepper!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var movieManager: MovieManager!
    var movieID: Int?
    var isWatched: Bool = false
    var movie: Movie?
    var movieMarker: WatchedMoviesMarker?
    var watchCount: Int = 1
    var movieRating: Int = 0

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
        
        loadMovieData()
        updateUI()
        
        updateUIForWatchedState(isWatched: isWatched)

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
        
        // Initialize the stepper and slider
        watchCountStepper.minimumValue = 1
        watchCountStepper.value = Double(watchCount)
        ratingSlider.minimumValue = 0
        ratingSlider.maximumValue = 100
        ratingSlider.value = Float(movieRating)
        ratingSlider.isContinuous = true
        
    }

    // Handle the switch toggle to mark a movie as watched/unwatched
    @IBAction func watchedSwitchToggled(sender: UISwitch) {
        guard let movieIndex = movieID, let movie = movieManager.getMovie(byID: movieIndex) else { return }

        isWatched = sender.isOn
        movieManager.setMovieWatchedStatus(movie: movie, watched: isWatched)
        
        updateUIForWatchedState(isWatched: isWatched)

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
    
    // Handle the stepper value change to update the watch count label
        @IBAction func watchCountStepperChanged(_ sender: UIStepper) {
            watchCount = Int(sender.value)  // Update the watch count
            watchCountLabel.text = "Watched: \(watchCount) times"  // Update the label
            saveMovieData()
        }

        // Handle the slider value change to update the rating label
        @IBAction func ratingSliderChanged(_ sender: UISlider) {
            movieRating = Int(sender.value)
            ratingLabel.text = "Rating: \(movieRating)/100"
            saveMovieData()
        }
    // Persist rating and watch count for the current movie using UserDefaults
    private func saveMovieData() {
        guard let movieID = movieID else { return }

        // Save watch count and rating using movieID as the key
        UserDefaults.standard.set(watchCount, forKey: "watchCount_\(movieID)")
        UserDefaults.standard.set(movieRating, forKey: "movieRating_\(movieID)")
    }

    // Load saved rating and watch count for the current movie from UserDefaults
    private func loadMovieData() {
        guard let movieID = movieID else { return }

        // Load watch count and rating using movieID as the key
        watchCount = UserDefaults.standard.integer(forKey: "watchCount_\(movieID)")
        movieRating = UserDefaults.standard.integer(forKey: "movieRating_\(movieID)")
    }
    
    private func updateUI() {
        // Set the stepper value and label
        watchCountStepper.value = Double(watchCount)
        watchCountLabel.text = "Watched: \(watchCount) times"

        // Set the slider value and label
        ratingSlider.value = Float(movieRating)
        ratingLabel.text = "Rating: \(movieRating)/100"
    }

    // Update the UI elements based on whether the movie is marked as watched
    private func updateUIForWatchedState(isWatched: Bool) {
        watchCountStepper.isHidden = !isWatched
        ratingSlider.isHidden = !isWatched
        watchCountLabel.isHidden = !isWatched
        ratingLabel.isHidden = !isWatched
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
        saveMovieData()
        
    }

}
