//
//  QuestInfoViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 12/9/24.
//

import UIKit

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
        let currentRank = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentRank) ?? "F"
        return User(currentLevel: currentLevel, currentExp: currentExp, currentRank: currentRank)
    }()
    var updateQuestCompletion: ((Quest) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateLocalizationUI()
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
        
        // Add EXP to user
        user.addExp(quest.expValue)

        // Save the updated user EXP to persistent storage
        UserDefaults.standard.set(user.currentExp, forKey: UserDefaultsKeys.currentExp)

        // Update UI or perform any other necessary updates
        updateQuestCompletion?(quest)
        
        print("Quest completed, user gained \(quest.expValue) EXP. Total EXP: \(user.currentExp)")
        DispatchQueue.main.async {
                // Update UI or perform any other necessary updates
                self.updateUI()
                self.updateQuestCompletion?(quest)
                print("Quest completed, user gained \(quest.expValue) EXP. Total EXP: \(user.currentExp)")
                
                // Go back or update the UI after completing the quest
                self.navigationController?.popViewController(animated: true)
            }
        // Go back or update the UI after completing the quest
        navigationController?.popViewController(animated: true)
    }


    private func showCompletionConfirmation() {
        let alert = UIAlertController(title: "Quest Completed", message: "You've earned \(quest?.expValue ?? 0) EXP!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }


    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        quest?.status = .canceled
        if let updatedQuest = quest {
            updateQuestCompletion?(updatedQuest)
        }
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
