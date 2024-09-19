import UIKit

class MovieDetailViewController: UIViewController, UIScrollViewDelegate {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var watchedSwitch: UISwitch!
    
    var movieManager: MovieManager!
    var movieID: Int?
    var isWatched: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movieID = movieID, let movie = movieManager.getMovie(byID: movieID) else {
            print("Movie not found")
            return
        }
        
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return movieImageView
    }
    
}
