import UIKit

class MovieTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var genrePickerView: UIPickerView!
    
    let movies = ["Inception", "Interstellar", "The Matrix", "The Dark Knight", "Oppenheimer"]
    let genres = ["All", "Sci-Fi", "Action", "Fiction", "SuperHero", "History"]
    let movieImages = ["https://i.ebayimg.com/images/g/LTQAAOSw~gxfU1Rd/s-l1200.jpg", "https://i.etsystatic.com/23402008/r/il/b658b2/2327469308/il_570xN.2327469308_492n.jpg",
    "https://m.media-amazon.com/images/I/71PfZFFz9yL._AC_UF894,1000_QL80_.jpg", "https://m.media-amazon.com/images/I/818hyvdVfvL._AC_UF894,1000_QL80_.jpg",
    "https://m.media-amazon.com/images/I/719W5aAI5NL._AC_UF894,1000_QL80_.jpg"]
    
    struct Movie {
        let title: String
        let genre: String
    }
    
    var allMovies = [
        Movie(title: "Inception", genre: "Sci-Fi"),
        Movie(title: "Interstellar", genre: "Action"),
        Movie(title: "The Matrix", genre: "Fiction"),
        Movie(title: "The Dark Knight", genre: "SuperHero"),
        Movie(title: "Oppenheimer", genre: "History")
    ]
    
    var filteredMovies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        genrePickerView.delegate = self
        genrePickerView.dataSource = self
        
        filteredMovies = allMovies
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        let movie = filteredMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedMovie = allMovies[indexPath.row].title
                let selectedGenre = allMovies[indexPath.row].genre
                let selectedImageURL = movieImages[indexPath.row]
                let destinationVC = segue.destination as! MovieDetailViewController
                
                destinationVC.movieTitle = selectedMovie
                destinationVC.movieGenre = selectedGenre
                destinationVC.movieImageURL = selectedImageURL
            }
        }
    }
    
    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genres.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genres[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedGenre = genres[row]
        
        if selectedGenre == "All" {
            filteredMovies = allMovies
        } else {
            filteredMovies = allMovies.filter { $0.genre == selectedGenre }
        }
        
        tableView.reloadData()
    }
    

}
