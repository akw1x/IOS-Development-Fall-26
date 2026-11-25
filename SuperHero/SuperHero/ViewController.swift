//
//  ViewController.swift
//  SuperHero
//
//  Created by Адель Кикбай on 25.11.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var heroes: [Hero] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heroes"
        tableView.dataSource = self
        tableView.delegate = self
        fetchHeroes()
    }

    private func fetchHeroes() {
        let urlString = "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/all.json"
        guard let url = URL(string: urlString) else { return }

        activityIndicator.startAnimating()

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }

            if let error {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showError(error)
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode),
                  let data else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }

            do {
                let decodedHeroes = try JSONDecoder().decode([Hero].self, from: data)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.heroes = decodedHeroes
                    self.tableView.reloadData()
                }
            } catch {
                debugPrint("Decoding Error: \(error)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }

        task.resume()
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.fetchHeroes()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let detailVC = segue.destination as? DetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            detailVC.hero = heroes[indexPath.row]
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        heroes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as? HeroCell else {
            return UITableViewCell()
        }
        cell.configure(with: heroes[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class HeroCell: UITableViewCell {

    @IBOutlet private weak var genderImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        genderImageView.image = nil
        transform = .identity
    }

    func configure(with hero: Hero) {
        nameLabel.text = hero.name

        let gender = (hero.appearance.gender ?? "").lowercased()
        switch gender {
        case "male":
            genderImageView.image = UIImage(systemName: "figure.stand")
            genderImageView.tintColor = .systemBlue
        case "female":
            genderImageView.image = UIImage(systemName: "figure.stand.dress")
            genderImageView.tintColor = .systemPink
        default:
            genderImageView.image = UIImage(systemName: "questionmark.circle.fill")
            genderImageView.tintColor = .systemGray
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.15) {
            self.transform = highlighted ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
            self.contentView.backgroundColor = highlighted ? .systemGray6 : .systemBackground
        }
    }
}

struct Hero: Decodable {
    let id: Int
    let name: String
    let powerstats: Powerstats
    let appearance: Appearance
    let biography: Biography
    let images: Images

    struct Powerstats: Decodable {
        let intelligence: Int
        let strength: Int
        let speed: Int
        let durability: Int
        let power: Int
        let combat: Int
    }

    struct Appearance: Decodable {
        let gender: String?
        let race: String?
        let height: [String]?
    }

    struct Biography: Decodable {
        let fullName: String?
        let publisher: String?
    }

    struct Images: Decodable {
        let md: String
    }
}

func cleanText(_ text: String?) -> String {
    guard let value = text?.trimmingCharacters(in: .whitespacesAndNewlines),
          !value.isEmpty,
          value != "-",
          value != "0 cm" else {
        return "Unknown"
    }
    return value
}
