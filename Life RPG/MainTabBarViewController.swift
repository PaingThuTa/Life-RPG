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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name here
            let questViewController = storyboard.instantiateViewController(withIdentifier: "QuestViewController") as! QuestViewController
            let rankViewController = storyboard.instantiateViewController(withIdentifier: "RankViewController") as! RankViewController
            let historyViewController = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        questViewController.tabBarItem = UITabBarItem(title: "Quests".localized(), image: UIImage(systemName: "square.stack.3d.up"), tag: 0)
        rankViewController.tabBarItem = UITabBarItem(title: "Rank".localized(), image: UIImage(systemName: "star"), tag: 1)
        historyViewController.tabBarItem = UITabBarItem(title: "History".localized(), image: UIImage(systemName: "list.clipboard"), tag: 2)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings".localized(), image: UIImage(systemName: "gearshape"), tag: 3)
        
//        self.viewControllers = [questViewController, rankViewController, historyViewController, settingsViewController]
        self.viewControllers = [
            UINavigationController(rootViewController: questViewController),
            UINavigationController(rootViewController: rankViewController),
            UINavigationController(rootViewController: historyViewController),
            UINavigationController(rootViewController: settingsViewController)
        ]
    }

}
