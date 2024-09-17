import UIKit

class MovieDetailViewController: UIViewController {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    var movieTitle: String?
    var movieGenre: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the labels with the passed data
        titleLabel.text = "Title: \(movieTitle ?? "Unknown")"
        genreLabel.text = "Genre: \(movieGenre ?? "Unknown")"
    }
}

