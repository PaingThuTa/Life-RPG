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
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var backgroundMusicLabel: UILabel!
    @IBOutlet weak var changeLanguageLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var thaiButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocalizationUI()
        
    }
    
    @IBAction func notiButtonToggled(_ sender: UIButton) {
        // what happens when toggle (local (in-app) notification)
        print("notification toggle clicked")
    }
    
    @IBAction func backgroundMusicButtonToggled(_ sender: UIButton) {
        // what happens when toggle (play music (in collection viewcontroller))
        print("background music toggle clicked")
    }
    
    @IBAction func englishButtonTapped(_ sender: UIButton) {
        setLanguage("en")
        
    }
    
    @IBAction func thaiButtonTapped(_ sender: UIButton) {
        setLanguage("th")
    }

    
    private func setLanguage(_ langCode: String) {
        
        UserDefaults.standard.setValue(langCode, forKey: LocalizeUserDefaultKey)
        
        let languageName = langCode == "en" ? "English" : "ภาษาไทย"
        let message = String(format: "Language change message".localized(), languageName)
        
        let alertController = UIAlertController(
            title: "Language Changed".localized(),
            message: message,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
        updateLocalizationUI()
        
    }
    
    @objc func updateLocalizationUI() {
        settingsTitleLabel.text = "Settings".localized()
        personalInfoLabel.text = "Personal Information".localized()
        nicknameLabel.text = "Nickname".localized()
        notiLabel.text = "Notifications".localized()
        enableNotiLabel.text = "Enable Notifications".localized()
        musicLabel.text = "Music".localized()
        backgroundMusicLabel.text = "Background Music".localized()
        changeLanguageLabel.text = "Change Language".localized()
        englishButton.setTitle("🇺🇸   English(US)".localized(), for: .normal)
        thaiButton.setTitle("🇹🇭   Thai".localized(), for: .normal)
        
    }

}
