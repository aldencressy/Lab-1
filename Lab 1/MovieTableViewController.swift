import UIKit

class MovieTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var genrePickerView: UIPickerView!
    
    
    @IBOutlet weak var SegmentedControlColor: UISegmentedControl!
    
    @IBAction func SegmentedControlAction(_ sender: UISegmentedControl) {
        switch SegmentedControlColor.selectedSegmentIndex
        {
        case 0: selectedTextColor = .green
        case 1: selectedTextColor = .red
        case 2: selectedTextColor = .blue
        case 3: selectedTextColor = .black
        default: break
        }
        tableView.reloadData()
        
    }
    var movieManager = MovieManager()
    var filteredMovies = [Movie]()
    var movieMarkers: [IndexPath: WatchedMoviesMarker] = [:]
    var selectedTextColor: UIColor = .white

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedTextColor = .black
        // Add Favorites button to navigation bar programmatically
        let favoritesButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(showFavorites))
        navigationItem.rightBarButtonItem = favoritesButton

        // Setup picker view delegate and data source
        genrePickerView.delegate = self
        genrePickerView.dataSource = self

        // Load all movies initially
        filteredMovies = movieManager.getMovies(forGenre: "All")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()  
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
       
        cell.textLabel?.textColor = selectedTextColor
        
        if movieManager.isMovieWatched(movie: movie) {
            cell.accessoryType = .checkmark
            startBlinking(for: cell.textLabel, at: indexPath)
        } else {
            cell.accessoryType = .none
            stopBlinking(at: indexPath)
        }
        
        return cell
    }

    // MARK: - Blinking Logic using WatchedMoviesMarker

    private func startBlinking(for label: UILabel?, at indexPath: IndexPath) {
        if let label = label, movieMarkers[indexPath] == nil {
            movieMarkers[indexPath] = WatchedMoviesMarker(label: label)
            movieMarkers[indexPath]?.startBlinking()
        }
    }

    private func stopBlinking(at indexPath: IndexPath) {
        if let marker = movieMarkers[indexPath] {
            marker.stopBlinking()
            movieMarkers.removeValue(forKey: indexPath)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        for marker in movieMarkers.values {
            marker.stopBlinking()
        }
        movieMarkers.removeAll()
    }

    // MARK: - Favorites Button Action

    @objc func showFavorites() {
        print("Favorites button tapped")
        performSegue(withIdentifier: "showFavoritesCollectionView", sender: nil)
    }

    // MARK: - Segue Handling

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail",
           let destinationVC = segue.destination as? MovieDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.movieManager = self.movieManager
            destinationVC.movieID = indexPath.row // Use index to pass selected movie
        }
    }
}
