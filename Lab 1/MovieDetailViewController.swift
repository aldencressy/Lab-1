import UIKit

class MovieDetailViewController: UIViewController {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    var movieTitle: String?
    var movieGenre: String?
    var movieImageURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Title: \(movieTitle ?? "Unknown")"
        genreLabel.text = "Genre: \(movieGenre ?? "Unknown")"
        
        if let imageUrlString = movieImageURL, let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        // Set the image on the main thread
                        self.movieImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

}

