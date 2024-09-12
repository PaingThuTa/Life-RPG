//
//  MainViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 1/9/2567 BE.
//

import UIKit

class QuestViewController: UIViewController {
    
    @IBOutlet weak var questsTableView: UITableView!
    var quests: [Quest] = [] // Array to store all the quests

    // UserDefaults key for storing quests
    let questsKey = "savedQuests"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate and data source for the table view
        questsTableView.delegate = self
        questsTableView.dataSource = self
        
        // Load saved quests from UserDefaults
        loadQuests()
    }
    
    // Function to navigate to AddQuestViewController
    @IBAction func addNewQuestButtonTapped(_ sender: UIButton) {
        if let addQuestVC = storyboard?.instantiateViewController(withIdentifier: "AddQuestViewController") as? AddQuestViewController {
            
            // Set the completion handler for passing data back
            addQuestVC.addQuestCompletion = { [weak self] newQuest in
                self?.quests.append(newQuest)
                self?.saveQuests() // Save quests after adding a new one
                self?.questsTableView.reloadData()
            }
            
            navigationController?.pushViewController(addQuestVC, animated: true)
        }
    }
    
    // Load saved quests from UserDefaults
    func loadQuests() {
        let defaults = UserDefaults.standard
        
        // Check if there's data for the questsKey
        if let savedData = defaults.data(forKey: questsKey) {
            let decoder = JSONDecoder()
            do {
                quests = try decoder.decode([Quest].self, from: savedData) // Decode the saved data
                questsTableView.reloadData() // Reload the table view with the loaded quests
            } catch {
                print("Failed to load quests: \(error.localizedDescription)")
            }
        }
    }
    
    // Save quests to UserDefaults
    func saveQuests() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(quests) // Encode the quests array into data
            defaults.set(encodedData, forKey: questsKey) // Save the encoded data to UserDefaults
        } catch {
            print("Failed to save quests: \(error.localizedDescription)")
        }
    }
}

extension QuestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath) as! QuestCell
        let quest = quests[indexPath.row]
        cell.configure(with: quest)
        return cell
    }
    
    // Handle the quest selection and segue to QuestInfoViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuest = quests[indexPath.row]
        
        // Perform the segue to QuestInfoViewController
        if let questInfoVC = storyboard?.instantiateViewController(withIdentifier: "QuestInfoViewController") as? QuestInfoViewController {
            questInfoVC.quest = selectedQuest // Pass the selected quest to the next view controller
            
            // Set the completion handler to update the quest in the quests array
            questInfoVC.updateQuestCompletion = { [weak self] updatedQuest in
                self?.quests[indexPath.row] = updatedQuest // Update the quest in the array
                self?.saveQuests() // Save the updated quests to UserDefaults
                self?.questsTableView.reloadData() // Reload the table view to show the updated quest
            }
            
            navigationController?.pushViewController(questInfoVC, animated: true)
        }
    }
}
