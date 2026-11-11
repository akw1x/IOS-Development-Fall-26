//
//  ViewController.swift
//  MoviesList
//
//  Created by Адель Кикбай on 11.11.2026.
//

import UIKit

// MARK: - Custom Prototype Cell
class MovieCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        posterImageView.image = UIImage(named: movie.imageName)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
    }
}

// MARK: - List Screen Controller
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private let movies = MovieStore.movies

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    // MARK: - Navigation & Data Passing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detailVC = segue.destination as? DetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            detailVC.movie = movies[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Detail Screen Controller
class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        setupDetails()
    }
    
    private func setupDetails() {
        guard let movie = movie else { return }
        
        title = movie.title
        
        posterImageView.image = UIImage(named: movie.imageName)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12
        
        titleLabel.text = movie.title
        subtitleLabel.text = movie.subtitle
        descriptionLabel.text = movie.description
        
        let stars = String(repeating: "★", count: movie.rating)
        let emptyStars = String(repeating: "☆", count: 5 - movie.rating)
        ratingLabel.text = stars + emptyStars
    }
}

