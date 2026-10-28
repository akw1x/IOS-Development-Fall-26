//
//  ViewController.swift
//  profile
//
//  Created by Адель Кикбай on 27.10.2026.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.layer.cornerRadius = 48
        avatarImageView.clipsToBounds = true
    }


}


