//
//  DefaultViewController.swift
//  Life RPG
//
//  Created by Beau on 22/9/2567 BE.
//

import UIKit

class DefaultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}
