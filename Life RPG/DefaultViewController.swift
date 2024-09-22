//
//  DefaultViewController.swift
//  Life RPG
//
//  Created by Beau on 22/9/2567 BE.
//

import UIKit

class DefaultViewController: UIViewController {
    
    @IBOutlet weak var tellUsAboutYouLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var defaultRankingLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocalizationUI()
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        guard let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {
            return
        }
        // Present the tab bar controller
        // This will replace the current view controller with the tab bar controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
    @objc func updateLocalizationUI() {
        // To access another language
        tellUsAboutYouLabel.text = "Tell us about you!".localized()
        nicknameLabel.text = "Nickname".localized()
        defaultRankingLabel.text = "Your default ranking".localized()
        rankLabel.text = "Rank".localized()
        
    }
}
