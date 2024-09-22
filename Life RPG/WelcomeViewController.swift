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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocalizeDefaultLanguage = UserDefaults.standard.string(forKey: LocalizeUserDefaultKey) ?? "en"
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
        guard let defaultVC = storyboard?.instantiateViewController(withIdentifier: "DefaultViewController") else { return  }
        navigationController?.pushViewController(defaultVC, animated: true)
    }
    
    @objc func updateLocalizationUI() {
        // To access another language
        titleOneLabel.text = "Life RPG".localized()
        titleTwoLabel.text = "Task Management".localized()
        titleThreeLabel.text = "Application".localized()
        subtitleLabel.text = "Let's boost up your productivity!".localized()
        
    }
}
