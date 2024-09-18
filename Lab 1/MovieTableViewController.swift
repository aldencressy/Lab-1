import UIKit

class MovieTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var genrePickerView: UIPickerView!
    
    var movieManager = MovieManager()
    var filteredMovies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()

        genrePickerView.delegate = self
        genrePickerView.dataSource = self

        filteredMovies = movieManager.getMovies(forGenre: "All")
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return movieManager.getGenres().count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return movieManager.getGenres()[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedGenre = movieManager.getGenres()[row]
        filteredMovies = movieManager.getMovies(forGenre: selectedGenre)
        tableView.reloadData()
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = filteredMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail",
           let destinationVC = segue.destination as? MovieDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.movieManager = self.movieManager
            destinationVC.movieID = indexPath.row
        }
    }
}
