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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
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
    
//    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
//        print("item type: \(shortcutItem.type)")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var viewController: UIViewController?
//
//        switch shortcutItem.type {
////        case "AddQuest":
////            viewController = storyboard.instantiateViewController(withIdentifier: "AddQuestViewController")
//        case "Quests":
//            viewController = storyboard.instantiateViewController(withIdentifier: "QuestViewController")
//        case "Rank":
//            viewController = storyboard.instantiateViewController(withIdentifier: "RankViewController")
//        default:
//            completionHandler(false) // If the type is not recognized, complete with false
//            return
//        }
//
//        // Create a UINavigationController with the desired view controller
//        let navigationController = UINavigationController(rootViewController: viewController!)
//        
//        // Ensure window is not nil and set the rootViewController
//        if let window = window {
//            window.rootViewController = navigationController
//            window.makeKeyAndVisible()
//            completionHandler(true) // Successful navigation
//        } else {
//            completionHandler(false) // Failure, window is nil
//        }
//    }
    
//    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
//        print("item type: \(shortcutItem.type)")
//        switch shortcutItem.type {
//        case "AddQuest":
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let AddQuestVC = storyboard.instantiateViewController(withIdentifier: "AddQuestViewController")
//            window?.rootViewController = AddQuestVC
//            break
//        case "Quests":
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let QuestsVC = storyboard.instantiateViewController(withIdentifier: "QuestViewController")
//            window?.rootViewController = QuestsVC
//            break
//        case "Rank":
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let RankVC = storyboard.instantiateViewController(withIdentifier: "RankViewController")
//            window?.rootViewController = RankVC
//            break
//        default:
//            break
//        }
//    }
    
//    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
//        print("item type: \(shortcutItem.type)")
//        
//        guard let tabBarController = window?.rootViewController as? UITabBarController else {
//            completionHandler(false)
//            return
//        }
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        switch shortcutItem.type {
//        case "AddQuest":
//            let AddQuestVC = storyboard.instantiateViewController(withIdentifier: "AddQuestViewController")
//            tabBarController.selectedIndex = 0 // Adjust index to your tab's order
//            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
//                navigationController.pushViewController(AddQuestVC, animated: true)
//            }
//        case "Quests":
//            tabBarController.selectedIndex = 0 // Adjust index to your tab's order
//            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
//                let QuestsVC = storyboard.instantiateViewController(withIdentifier: "QuestViewController")
//                navigationController.pushViewController(QuestsVC, animated: true)
//            }
//        case "Rank":
//            tabBarController.selectedIndex = 1 // Adjust index to your tab's order
//            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
//                let RankVC = storyboard.instantiateViewController(withIdentifier: "RankViewController")
//                navigationController.pushViewController(RankVC, animated: true)
//            }
//        default:
//            completionHandler(false)
//            return
//        }
//        
//        completionHandler(true)
//    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        print("item type: \(shortcutItem.type)")
        
        guard let tabBarController = window?.rootViewController as? UITabBarController else {
            print("Root view controller is not UITabBarController")
            completionHandler(false)
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch shortcutItem.type {
        case "AddQuest":
            print("Navigating to AddQuestViewController")
            tabBarController.selectedIndex = 0 // Quests tab index
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                let AddQuestVC = storyboard.instantiateViewController(withIdentifier: "AddQuestViewController")
                navigationController.pushViewController(AddQuestVC, animated: true)
            } else {
                print("Selected view controller is not UINavigationController")
            }
        case "Quests":
            print("Navigating to QuestViewController")
            tabBarController.selectedIndex = 0 // Quests tab index
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                let QuestsVC = storyboard.instantiateViewController(withIdentifier: "QuestViewController")
                navigationController.pushViewController(QuestsVC, animated: true)
            } else {
                print("Selected view controller is not UINavigationController")
            }
        case "Rank":
            print("Navigating to RankViewController")
            tabBarController.selectedIndex = 1 // Rank tab index
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                let RankVC = storyboard.instantiateViewController(withIdentifier: "RankViewController")
                navigationController.pushViewController(RankVC, animated: true)
            } else {
                print("Selected view controller is not UINavigationController")
            }
        default:
            print("Unknown item type: \(shortcutItem.type)")
            completionHandler(false)
            return
        }
        
        completionHandler(true)
    }




}

