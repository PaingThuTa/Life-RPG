//
//  WelcomeViewController.swift
//  Life RPG
//
//  Created by Beau on 22/9/2567 BE.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleOneLabel: UILabel!
    @IBOutlet weak var titleTwoLabel: UILabel!
    @IBOutlet weak var titleThreeLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var chooseLanguageLabel: UILabel!
    @IBOutlet weak var englishLanguageButton: UIButton!
    @IBOutlet weak var thaiLanguageButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the language is already saved
        if UserDefaults.standard.string(forKey: LocalizeUserDefaultKey) != nil {
            // If language is already set, navigate to MainTabBarViewController
            //navigateToMainTabBar()
        } else {
            // Set default language if not found in UserDefaults
            LocalizeDefaultLanguage = "en"
            

            
        }
        
        updateLocalizationUI()
    }

    @IBAction func englishButtonTapped(_ sender: UIButton) {
        LocalizeDefaultLanguage = "en"
        UserDefaults.standard.setValue(LocalizeDefaultLanguage, forKey: LocalizeUserDefaultKey)
        updateLocalizationUI()
    }
    
    @IBAction func thaiButtonTapped(_ sender: UIButton) {
        LocalizeDefaultLanguage = "th"
        UserDefaults.standard.setValue(LocalizeDefaultLanguage, forKey: LocalizeUserDefaultKey)
        updateLocalizationUI()
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        // Save language selection in UserDefaults if needed
        if LocalizeDefaultLanguage != nil {
            UserDefaults.standard.setValue(LocalizeDefaultLanguage, forKey: LocalizeUserDefaultKey)
        }
        
        // Navigate to nickname screen (DefaultViewController)
        guard let defaultVC = storyboard?.instantiateViewController(withIdentifier: "DefaultViewController") else { return  }
        navigationController?.pushViewController(defaultVC, animated: true)
    }
    
    @objc func updateLocalizationUI() {
        // To access another language
        titleOneLabel.text = "Life RPG".localized()
        titleTwoLabel.text = "Task Management".localized()
        titleThreeLabel.text = "Application".localized()
        subtitleLabel.text = "Let's boost up your productivity!".localized()
        chooseLanguageLabel.text = "Choose a language".localized()
        englishLanguageButton.setTitle("🇺🇸   English(US)".localized(), for: .normal)
        thaiLanguageButton.setTitle("🇹🇭   Thai".localized(), for: .normal)
        continueButton.setTitle("Continue".localized(), for: .normal)
    }
    
    // Function to navigate to the MainTabBarViewController
    func navigateToMainTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarViewController
        
        // Set the TabBarController as the root view controller
        if let navigationController = self.navigationController {
            navigationController.setViewControllers([tabBarController], animated: true)
        }
    }
}
