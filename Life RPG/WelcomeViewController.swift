//
//  WelcomeViewController.swift
//  Life RPG
//
//  Created by Beau on 22/9/2567 BE.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func englishButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func thaiButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard let defaultVC = storyboard?.instantiateViewController(withIdentifier: "DefaultViewController") else { return  }
        navigationController?.pushViewController(defaultVC, animated: true)
    }
}
