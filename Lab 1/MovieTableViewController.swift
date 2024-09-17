import UIKit

class MovieTableViewController: UITableViewController {
    let movies = ["Inception", "Interstellar", "The Matrix", "The Dark Knight", "Pulp Fiction"]
    let genres = ["Sci-Fi", "Action", "Fiction", "SuperHero", "Comedy"]

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
                let destinationVC = segue.destination as! MovieDetailViewController
                
                destinationVC.movieTitle = selectedMovie
                destinationVC.movieGenre = selectedGenre
            }
        }
    }

}
