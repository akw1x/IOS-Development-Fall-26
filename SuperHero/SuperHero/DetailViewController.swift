//
//  DetailViewController.swift
//  SuperHero
//
//  Created by Адель Кикбай on 25.11.2026.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var heroImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    var hero: Hero?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        buildDetails()
    }

    private func setupHeader() {
        guard let hero else { return }
        title = hero.name
        contentStackView.spacing = 6

        nameLabel.text = hero.name
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center

        heroImageView.layer.cornerRadius = 14
        heroImageView.clipsToBounds = true
        heroImageView.contentMode = .scaleAspectFit
        heroImageView.image = UIImage(systemName: "person.crop.square.fill")
        heroImageView.tintColor = .systemGray3

        loadImage(from: hero.images.md)
    }

    private func buildDetails() {
        guard let hero else { return }

        // Group 1: Powerstats
        addSectionTitle("POWERSTATS")
        addRow("Intelligence", "\(hero.powerstats.intelligence)")
        addRow("Strength", "\(hero.powerstats.strength)")
        addRow("Speed", "\(hero.powerstats.speed)")
        addRow("Durability", "\(hero.powerstats.durability)")
        addRow("Power", "\(hero.powerstats.power)")
        addRow("Combat", "\(hero.powerstats.combat)")

        // Group 2: Biography
        addSectionTitle("BIOGRAPHY")
        addRow("Full Name", cleanText(hero.biography.fullName))
        addRow("Publisher", cleanText(hero.biography.publisher))

        // Group 3: Appearance
        addSectionTitle("APPEARANCE")
        addRow("Race", cleanText(hero.appearance.race))
        addRow("Height", cleanText(hero.appearance.height?.last))
    }

    private func addSectionTitle(_ text: String) {
        let label = UILabel()
        label.text = "\n\(text)"
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .systemIndigo
        label.numberOfLines = 0
        contentStackView.addArrangedSubview(label)
    }

    private func addRow(_ title: String, _ value: String) {
        let label = UILabel()
        label.numberOfLines = 0

        let attributed = NSMutableAttributedString(
            string: "\(title): ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                .foregroundColor: UIColor.label
            ]
        )
        attributed.append(NSAttributedString(
            string: value,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                .foregroundColor: UIColor.secondaryLabel
            ]
        ))

        label.attributedText = attributed
        contentStackView.addArrangedSubview(label)
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.heroImageView.image = image
            }
        }.resume()
    }
}
