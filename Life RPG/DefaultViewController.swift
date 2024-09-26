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
        
        // Check if the nickname is already saved
        if UserDefaults.standard.string(forKey: UserDefaultsKeys.userNickname) != nil {
            // Skip this screen and go to the MainTabBarController
            navigateToMainTabBar()
        } else {
            // Update the UI for entering nickname
            updateLocalizationUI()
        }
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        // Check if the nickname is entered
        guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
            showAlert(message: "Please enter a nickname before continuing.".localized())
            return
        }

        // Save the nickname to UserDefaults
        UserDefaults.standard.set(nickname, forKey: UserDefaultsKeys.userNickname)
        
        // Navigate to the MainTabBarController
        navigateToMainTabBar()
    }
    
    @objc func updateLocalizationUI() {
        // Update UI elements for localization
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
    
    // Helper function to show an alert if nickname is empty
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    // Function to navigate to the MainTabBarController
    func navigateToMainTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarViewController
        
        // Set the TabBarController as the root view controller
        if let navigationController = self.navigationController {
            navigationController.setViewControllers([tabBarController], animated: true)
        }
    }
}
