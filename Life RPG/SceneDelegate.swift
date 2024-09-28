//
//  SceneDelegate.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 27/8/2567 BE.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Check if the user's nickname is set
        if UserDefaults.standard.string(forKey: "userNickname") != nil {
            // Nickname is set, so the user has completed the initial setup
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
                window?.rootViewController = tabBarController
            }
        } else {
            // No nickname set, start with WelcomeViewController for setup
            if let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
                let navigationController = UINavigationController(rootViewController: welcomeVC)
                window?.rootViewController = navigationController
            }
        }
        
        window?.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        print("item type: \(shortcutItem.type)")
        
        guard let tabBarController = window?.rootViewController as? UITabBarController else {
            print("Root view controller is not UITabBarController")
            completionHandler(false)
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)  // Instantiating the storyboard here

        switch shortcutItem.type {
//        case "AddQuest":
//            print("Navigating to AddQuestViewController")
//            tabBarController.selectedIndex = 0 // Quests tab
//            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
//                // Check if AddQuestViewController is already in the navigation stack
//                if !(navigationController.topViewController is AddQuestViewController) {
//                    let addQuestVC = storyboard.instantiateViewController(withIdentifier: "AddQuestViewController") as! AddQuestViewController
//                    navigationController.pushViewController(addQuestVC, animated: true)
//                }
//            }
        case "Quests":
            print("Navigating to QuestViewController")
            tabBarController.selectedIndex = 0 // Quests tab
            // No need to push the QuestViewController because it's already loaded with the tab
        case "Rank":
            print("Navigating to RankViewController")
            tabBarController.selectedIndex = 1 // Rank tab
            // No need to push the RankViewController because it's already loaded with the tab
        default:
            print("Unknown item type: \(shortcutItem.type)")
            completionHandler(false)
            return
        }

        completionHandler(true)
    }




}

