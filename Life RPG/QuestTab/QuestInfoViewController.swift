//
//  QuestInfoViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 12/9/24.
//

import UIKit

class QuestInfoViewController: UIViewController {

    // Outlets for displaying quest info
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var expValueLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!

    // Variable to hold the quest passed from QuestViewController
    var quest: Quest?

    // Completion handler to pass the updated quest back to QuestViewController
    var updateQuestCompletion: ((Quest) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI() // Call to update the UI with the quest details
        
    }

    // Action to edit the quest
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

    // Update the UI after editing the quest
    func updateUI() {
        if let quest = quest {
            // Update the UI with the new quest data
            titleLabel.text = quest.title
            detailsLabel.text = quest.details
            repeatLabel.text = quest.repeats

            // Format the date to display it properly
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dueDateLabel.text = dateFormatter.string(from: quest.dueDate)

            // Update expValueLabel and difficultyLabel with the updated values
            expValueLabel.text = "\(quest.expValue)"
            difficultyLabel.text = quest.difficulty
        }
    }
    


}
