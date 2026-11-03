//
//  ViewController.swift
//  favcountries
//
//  Created by Адель Кикбай on 03.11.2026.
//
import UIKit

struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let items: [FavoriteItem] = [
        FavoriteItem(title: "South Korea", subtitle: "Capital: Seoul • Asia", imageName: "korea", rating: 5),
        FavoriteItem(title: "United Kingdom", subtitle: "Capital: London • Europe", imageName: "uk", rating: 4),
        FavoriteItem(title: "France", subtitle: "Capital: Paris • Europe", imageName: "france", rating: 5),
        FavoriteItem(title: "Italy", subtitle: "Capital: Rome • Europe", imageName: "italy", rating: 5),
        FavoriteItem(title: "Spain", subtitle: "Capital: Madrid • Europe", imageName: "spain", rating: 4),
        FavoriteItem(title: "USA", subtitle: "Capital: Washington, D.C. • North America", imageName: "usa", rating: 5),
        FavoriteItem(title: "Canada", subtitle: "Capital: Ottawa • North America", imageName: "canada", rating: 4),
        FavoriteItem(title: "Switzerland", subtitle: "Capital: Bern • Europe", imageName: "switzerland", rating: 5),
        FavoriteItem(title: "China", subtitle: "Capital: Beijing • Asia", imageName: "china", rating: 4),
        FavoriteItem(title: "Japan", subtitle: "Capital: Tokyo • Asia", imageName: "japan", rating: 5),
        FavoriteItem(title: "Turkey", subtitle: "Capital: Ankara • Europe/Asia", imageName: "turkey", rating: 4),
        FavoriteItem(title: "Thailand", subtitle: "Capital: Bangkok • Asia", imageName: "thailand", rating: 4),
        FavoriteItem(title: "Vietnam", subtitle: "Capital: Hanoi • Asia", imageName: "vietnam", rating: 4),
        FavoriteItem(title: "UAE", subtitle: "Сapital: Abu Dhabi • Middle East", imageName: "uae", rating: 5),
        FavoriteItem(title: "Qatar", subtitle: "Capital: Doha • Middle East", imageName: "qatar", rating: 4),
        FavoriteItem(title: "Greece", subtitle: "Capital: Athens • Europe", imageName: "greece", rating: 5),
        FavoriteItem(title: "Germany", subtitle: "Capital: Berlin • Europe", imageName: "germany", rating: 4),
        FavoriteItem(title: "Belgium", subtitle: "Capital: Brussels • Europe", imageName: "belgium", rating: 3),
        FavoriteItem(title: "Argentina", subtitle: "Capital: Buenos Aires • South America", imageName: "argentina", rating: 4),
        FavoriteItem(title: "Portugal", subtitle: "Capital: Lisbon • Europe", imageName: "portugal", rating: 3)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}
