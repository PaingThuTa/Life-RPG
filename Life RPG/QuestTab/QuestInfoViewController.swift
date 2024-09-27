//
//  QuestInfoViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 12/9/24.
//

import UIKit
import UserNotifications
import WidgetKit

class QuestInfoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var expValueLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var questInfoPageLabel: UILabel!
    @IBOutlet weak var headTitleLabel: UILabel!
    @IBOutlet weak var headDetailsLabel: UILabel!
    @IBOutlet weak var headDueDateLabel: UILabel!
    @IBOutlet weak var headRepeatLabel: UILabel!
    @IBOutlet weak var headEXPValueLabel: UILabel!
    @IBOutlet weak var headDifficultyLabel: UILabel!
    
    @IBOutlet weak var editQuestButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!

    var quest: Quest?
    var user: User? = {
        let currentLevel = UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentLevel)
        let currentExp = UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentExp)
        let totalExp = UserDefaults.standard.integer(forKey: UserDefaultsKeys.totalExp)
        let currentRank = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentRank) ?? "F"
        return User(currentLevel: currentLevel, currentExp: currentExp, currentRank: currentRank, totalExp: totalExp)
    }()
    var updateQuestCompletion: ((Quest) -> Void)?
    let appGroupID = "group.com.6530288.Life-RPG"

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateLocalizationUI()
        UNUserNotificationCenter.current().delegate = self

    }
    @IBAction func editQuestTapped(_ sender: UIButton) {
            // Navigate to QuestEditViewController
        if let editQuestVC = storyboard?.instantiateViewController(withIdentifier: "QuestEditViewController") as? QuestEditViewController {
            editQuestVC.quest = quest // Pass the current quest to edit
            
            // Set the completion handler to update the quest
            editQuestVC.updateQuestCompletion = { [weak self] updatedQuest in
                self?.quest = updatedQuest
                self?.updateUI() // Call the method to refresh the UI with the updated quest
                
                // Call the completion handler to pass the updated quest back to QuestViewController
                self?.updateQuestCompletion?(updatedQuest)
            }
            
            navigationController?.pushViewController(editQuestVC, animated: true)
        }
    }

    func updateUI() {
        if let quest = quest {
            titleLabel.text = quest.title
            detailsLabel.text = quest.details
            repeatLabel.text = quest.repeats
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dueDateLabel.text = dateFormatter.string(from: quest.dueDate)
            expValueLabel.text = "\(quest.expValue)"
            difficultyLabel.text = quest.difficulty
        }
    }
    
    func triggerLevelUpNotification(newLevel: Int) {
        let content = UNMutableNotificationContent()
        content.title = "notification_title_congratulations".localized()
        content.body = String(format: "You've reached Level %d! Keep up the great work.".localized(), newLevel)
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "LevelUpNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Level-up notification scheduled successfully.")
            }
        }
    }
    
    func updateQuestStatus(quest: Quest, newStatus: QuestStatus) {
        var updatedQuests = loadQuests() // Load existing quests
        if let index = updatedQuests.firstIndex(where: { $0.id == quest.id }) {
            updatedQuests[index].status = newStatus // Update the status
        }
        saveQuests(updatedQuests) // Save the updated list back to UserDefaults
        WidgetCenter.shared.reloadAllTimelines() // Refresh the widget
    }

    func loadQuests() -> [Quest] {
        guard let sharedDefaults = UserDefaults(suiteName: appGroupID),
              let savedData = sharedDefaults.data(forKey: UserDefaultsKeys.activeQuestsKey),
              let quests = try? JSONDecoder().decode([Quest].self, from: savedData) else {
            return []
        }
        return quests
    }

    func saveQuests(_ quests: [Quest]) {
        guard let sharedDefaults = UserDefaults(suiteName: appGroupID) else {
            print("Failed to fetch shared defaults for app group.")
            return
        }
        if let encodedData = try? JSONEncoder().encode(quests) {
            sharedDefaults.set(encodedData, forKey: UserDefaultsKeys.activeQuestsKey)
        }
    }

    
    

    @IBAction func completeButtontapped(_ sender: UIButton) {
        guard var quest = quest else {
            print("Error: Quest object is nil")
            return
        }
        
        guard let user = user else {
            print("Error: User object is nil")
            return
        }

        // Update quest status to completed
        quest.status = .completed
        
        updateQuestStatus(quest: quest, newStatus: .completed)
        WidgetCenter.shared.reloadAllTimelines() // Add this line
            
        print("Quest completed, widget should update.")
        
        // Add EXP to user
        let previousLevel = user.currentLevel
        user.addExp(quest.expValue)

        // Check if the user has leveled up (this is automatically handled in addExp)
        if user.currentLevel > previousLevel {
            print("User leveled up to Level \(user.currentLevel)")
            triggerLevelUpNotification(newLevel: user.currentLevel)
        } else {
            print("No level up.")
        }

        // Save the updated user EXP to persistent storage
        UserDefaults.standard.set(user.currentExp, forKey: UserDefaultsKeys.currentExp)
        
        // Save the total EXP to UserDefaults (new implementation)
        let currentTotalExp = UserDefaults.standard.integer(forKey: UserDefaultsKeys.totalExp) // Retrieve current total EXP
        let newTotalExp = currentTotalExp + quest.expValue // Add quest's EXP to total EXP
        UserDefaults.standard.set(newTotalExp, forKey: UserDefaultsKeys.totalExp) // Save the updated total EXP

        print("Quest completed, user gained \(quest.expValue) EXP. Total EXP: \(newTotalExp)")
        
        DispatchQueue.main.async {
            // Update UI or perform any other necessary updates
            self.updateUI()
            self.updateQuestCompletion?(quest)
            
            
            // Go back or update the UI after completing the quest
            self.navigationController?.popViewController(animated: true)
        }
    }



    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        guard var quest = quest else {
            print("Error: Quest object is nil")
            return
        }
        
        quest.status = .canceled
        updateQuestCompletion?(quest)
        
        
    
        updateQuestStatus(quest: quest, newStatus: .canceled)
        WidgetCenter.shared.reloadAllTimelines() // Add this line
            
        print("Quest completed, widget should update.")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func updateLocalizationUI() {
        // To access another language
        questInfoPageLabel.text = "Quest Info".localized()
        headTitleLabel.text = "Title".localized()
        headDetailsLabel.text = "Details".localized()
        headDueDateLabel.text = "Due Date".localized()
        headRepeatLabel.text = "Repeat".localized()
        headEXPValueLabel.text = "Quest EXP Value".localized()
        headDifficultyLabel.text = "Difficulty".localized()
        
        editQuestButton.setTitle("Edit Quest".localized(), for: .normal)
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        completeButton.setTitle("Complete".localized(), for: .normal)

    }

}

extension QuestInfoViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show the notification as a banner and play the sound even when the app is in foreground
        completionHandler([.banner, .sound])
    }
}
