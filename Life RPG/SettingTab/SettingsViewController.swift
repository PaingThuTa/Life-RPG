//
//  SettingsViewController.swift
//  Life RPG
//
//  Created by Beau on 19/9/2567 BE.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var nicknameValueLabel: UILabel!
    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var notiLabel: UILabel!
    @IBOutlet weak var enableNotiLabel: UILabel!
    @IBOutlet weak var notiToggleButton: UISwitch!
//    @IBOutlet weak var musicLabel: UILabel!
//    @IBOutlet weak var backgroundMusicLabel: UILabel!
    @IBOutlet weak var changeLanguageLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var thaiButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nicknameValueLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nicknameValueLabelTapped))
        
        nicknameValueLabel.addGestureRecognizer(tapGesture)
        
        // Set the nickname label from UserDefaults
        if let userNickname = UserDefaults.standard.string(forKey: UserDefaultsKeys.userNickname) {
            nicknameValueLabel.text = userNickname
        } else {
            nicknameValueLabel.text = "No nickname. Tap to set.".localized()
        }
        
        // Update UI with localized text
        updateLocalizationUI()
        
        notiToggleButton.isEnabled = false
    }
    @objc func nicknameValueLabelTapped() {
        // Create an alert controller with a text field for entering a new nickname
        let alertController = UIAlertController(title: "Change Nickname".localized(), message: "Enter your new nickname".localized(), preferredStyle: .alert)
        
        // Add a text field to the alert
        alertController.addTextField { textField in
            textField.placeholder = "Enter nickname".localized()
            textField.text = self.nicknameValueLabel.text // Pre-fill with the current nickname
        }
        
        // Add a Cancel action
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Add a Save action
        let saveAction = UIAlertAction(title: "Save".localized(), style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            // Get the input from the text field
            if let newNickname = alertController.textFields?.first?.text, !newNickname.isEmpty {
                // Save the new nickname to UserDefaults
                UserDefaults.standard.set(newNickname, forKey: UserDefaultsKeys.userNickname)
                
                // Update the label with the new nickname
                self.nicknameValueLabel.text = newNickname
            }
        }
        alertController.addAction(saveAction)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func notiButtonToggled(_ sender: UIButton) {
        // Handle local (in-app) notification toggle
    }
    
    @IBAction func backgroundMusicButtonToggled(_ sender: UIButton) {
        // Handle background music toggle
    }
    
    @IBAction func englishButtonTapped(_ sender: UIButton) {
        setLanguage("en")
    }
    
    @IBAction func thaiButtonTapped(_ sender: UIButton) {
        setLanguage("th")
    }
    
    // Language change logic
    private func setLanguage(_ langCode: String) {
        
        let currentLanguage = LocalizeDefaultLanguage
        if currentLanguage == langCode {
            // If the same language is chosen, show an alert
            let languageName = langCode == "en" ? "English" : "ภาษาไทย"
            let sameLanguageAlert = UIAlertController(
                title: "No Change".localized(),
                message: String(format: "You are already using %@.".localized(), languageName),
                preferredStyle: .alert
            )
            sameLanguageAlert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
            present(sameLanguageAlert, animated: true, completion: nil)
            return
        }
        
        // Save the new language
        LocalizeDefaultLanguage = langCode
        
        // Show confirmation alert for language change
        let newLanguageName = langCode == "en" ? "English" : "ภาษาไทย"
        let message = String(format: "Language has been changed to %@.".localized(), newLanguageName)
        
        let alertController = UIAlertController(
            title: "Language Changed".localized(),
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { [weak self] _ in
            // Restart the app interface to apply the language change
            self?.restartAppForNewLanguage()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    // Helper method to update localized UI elements
    @objc func updateLocalizationUI() {
        settingsTitleLabel.text = "Settings".localized()
        personalInfoLabel.text = "Personal Information".localized()
        nicknameLabel.text = "Nickname".localized()
        notiLabel.text = "Notifications".localized()
        enableNotiLabel.text = "Enable Notifications".localized()
//        musicLabel.text = "Music".localized()
//        backgroundMusicLabel.text = "Background Music".localized()
        changeLanguageLabel.text = "Change Language".localized()
        englishButton.setTitle("🇺🇸   English(US)".localized(), for: .normal)
        thaiButton.setTitle("🇹🇭   Thai".localized(), for: .normal)
    }
    
    // Function to restart the app's root view controller for language changes to apply throughout the app
    private func restartAppForNewLanguage() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        // Instantiate the initial view controller (or MainTabBarController)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        
        // Set the new root view controller
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        // Optionally, add a transition animation
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.5
        window.layer.add(transition, forKey: kCATransition)
    }
}
