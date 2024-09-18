import UIKit

class MovieDetailViewController: UIViewController {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    var movieManager: MovieManager!
    var movieID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movieID = movieID, let movie = movieManager.getMovie(byID: movieID) else {
            print("Movie not found")
            return
        }

        self.title = movie.title
        
        titleLabel.text = "Title: \(movie.title)"
        genreLabel.text = "Genre: \(movie.genre)"
        
        if let url = URL(string: movie.imageURL) {
            loadImage(from: url)
        } else {
            movieImageView.image = UIImage(named: "placeholder_image") // Optional placeholder
        }
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
