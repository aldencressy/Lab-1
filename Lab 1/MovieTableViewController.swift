import UIKit

class MovieTableViewController: UITableViewController {
    let movies = ["Inception", "Interstellar", "The Matrix", "The Dark Knight", "Oppenheimer"]
    let genres = ["Sci-Fi", "Action", "Fiction", "SuperHero", "History"]
    let movieImages = ["https://i.ebayimg.com/images/g/LTQAAOSw~gxfU1Rd/s-l1200.jpg", "https://i.etsystatic.com/23402008/r/il/b658b2/2327469308/il_570xN.2327469308_492n.jpg",
    "https://m.media-amazon.com/images/I/71PfZFFz9yL._AC_UF894,1000_QL80_.jpg", "https://m.media-amazon.com/images/I/818hyvdVfvL._AC_UF894,1000_QL80_.jpg",
    "https://m.media-amazon.com/images/I/719W5aAI5NL._AC_UF894,1000_QL80_.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        cell.textLabel?.text = movies[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedMovie = movies[indexPath.row]
                let selectedGenre = genres[indexPath.row]
                let selectedImageURL = movieImages[indexPath.row]
                let destinationVC = segue.destination as! MovieDetailViewController
                
                destinationVC.movieTitle = selectedMovie
                destinationVC.movieGenre = selectedGenre
                destinationVC.movieImageURL = selectedImageURL
            }
        }
    }

}
