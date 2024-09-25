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
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var defaultRankingLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var EXPToLevelUpLabel: UILabel!
    @IBOutlet weak var TotalEXPLabel: UILabel!
    @IBOutlet weak var StartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocalizationUI()
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarViewController
        
        // Set the TabBarController as the root view controller
        if let navigationController = self.navigationController {
            // Replace the current view controllers with the TabBarController
            navigationController.setViewControllers([tabBarController], animated: true)
        }
    }
    
    @objc func updateLocalizationUI() {
        // To access another language
        tellUsAboutYouLabel.text = "Tell us about you!".localized()
        nicknameLabel.text = "Nickname".localized()
        nicknameTextField.placeholder = "Enter your nickname".localized()
        defaultRankingLabel.text = "Your default ranking".localized()
        rankLabel.text = "Rank".localized()
        levelLabel.text = "Level".localized()
        EXPToLevelUpLabel.text = "EXP To Level Up".localized()
        TotalEXPLabel.text = "Total EXP".localized()
        StartButton.setTitle("START LEVELING UP!".localized(), for: .normal)
    }
}
