import UIKit

class FavoritesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var favoriteMovies = [Movie]() // Array of favorite movies

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch favorite movies from the FavoritesManager
        favoriteMovies = FavoritesManager.shared.getFavorites()
        
        print("Made it to custom view")
        
        // Reload the collection view to display the data
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMovieCell", for: indexPath) as! CustomMovieCollectionViewCell
        
        let movie = favoriteMovies[indexPath.row]
        
        // Set the movie title
        cell.titleLabel.text = movie.title
        
        // Load the movie image asynchronously
        if let url = URL(string: movie.imageURL) {
            loadImage(from: url, into: cell.imageView)
        }
        
        return cell
    }
    
    // Function to load images asynchronously
    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    // Set size for each item (cell)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10  // Padding between cells
        let numberOfItemsPerRow: CGFloat = 2 // Number of cells per row
        let availableWidth = collectionView.frame.width - (padding * (numberOfItemsPerRow + 1)) // Total width minus padding
        let widthPerItem = availableWidth / numberOfItemsPerRow // Width for each cell
        
        // Return size for each item, with width and height adjusted
        let heightPerItem = widthPerItem * 1.5 + 30 // Assuming aspect ratio for image and height for label
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    
}
