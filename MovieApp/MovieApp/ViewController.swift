import UIKit

// 1. Data Model (Struct)
struct Movie {
    let title: String
    let description: String
    let imageName: String
}

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    

    // MARK: - Data (exactly 10 favorite movies)
    let movies: [Movie] = [
        Movie(title: "Harry Potter", description: "A young wizard discovers his magical heritage.", imageName: "poster1"),
        Movie(title: "Avatar", description: "A paraplegic Marine sent to the moon Pandora on a unique mission.", imageName: "poster2"),
        Movie(title: "Twilight", description: "A teenage girl falls in love with a vampire.", imageName: "poster3"),
        Movie(title: "Titanic", description: "A seventeen-year-old aristocrat falls in love with a kind artist.", imageName: "poster4"),
        Movie(title: "1+1", description: "An aristocrat hires a young man from the slums as his caregiver.", imageName: "poster5"),
        Movie(title: "Avengers", description: "Earth's mightiest heroes must come together to stop Loki.", imageName: "poster6"),
        Movie(title: "Spiderman", description: "A high school student gains spider-like abilities.", imageName: "poster7"),
        Movie(title: "Interstellar", description: "A team of explorers travel through a wormhole in space.", imageName: "poster8"),
        Movie(title: "La La Land", description: "A jazz pianist and an aspiring actress fall in love in Los Angeles.", imageName: "poster9"),
        Movie(title: "The Matrix", description: "A computer hacker learns about the true nature of his reality.", imageName: "poster10")
    ]
    var currentIndex: Int = -1

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showRandomMovie()
    }

    // MARK: - IBActions
    @IBAction func generateButtonTapped(_ sender: UIButton) {
        showRandomMovie()
    }

    // MARK: - Logic
    func showRandomMovie() {
        var randomIndex: Int
        
        // Pick a random index until it differs from the current one
        repeat {
            randomIndex = Int.random(in: 0..<movies.count)
        } while randomIndex == currentIndex && movies.count > 1

        currentIndex = randomIndex
        let selectedMovie = movies[randomIndex]

        if let image = UIImage(named: selectedMovie.imageName) {
            moviePosterImageView.image = image
        }
        
        movieTitleLabel.text = selectedMovie.title
        movieDescriptionLabel.text = selectedMovie.description
    }
}
