//
//  MainTabBarViewController.swift
//  Life RPG
//
//  Created by Beau on 25/9/2567 BE.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questViewController = QuestViewController()
        let rankViewController = RankViewController()
        let historyViewController = HistoryViewController()
        let settingsViewController = SettingsViewController()
        
        questViewController.tabBarItem = UITabBarItem(title: "Quests".localized(), image: UIImage(systemName: "square.stack.3d.up"), tag: 0)
        rankViewController.tabBarItem = UITabBarItem(title: "Rank".localized(), image: UIImage(systemName: "star"), tag: 1)
        historyViewController.tabBarItem = UITabBarItem(title: "History".localized(), image: UIImage(systemName: "list.clipboard"), tag: 2)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings".localized(), image: UIImage(systemName: "gear"), tag: 3)
        
        self.viewControllers = [questViewController, rankViewController, historyViewController, settingsViewController]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
