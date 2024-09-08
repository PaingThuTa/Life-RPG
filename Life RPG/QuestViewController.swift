//
//  MainViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 1/9/2567 BE.
//

import UIKit

class QuestViewController: UIViewController {
    
    @IBOutlet weak var questsTableView: UITableView!
    var quests: [Quest] = []
    
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
                self?.quests.append(newQuest) // Add the new quest to the array
                
                self?.questsTableView.reloadData() // Reload the table to reflect the new data
                self?.saveQuests() // Save the updated quests to UserDefaults
            }
            
            navigationController?.pushViewController(addQuestVC, animated: true)
        }
    }
    
    // Save quests to UserDefaults
    func saveQuests() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(quests) {
            UserDefaults.standard.set(encoded, forKey: "savedQuests")
        }
    }
    
    // Load quests from UserDefaults
    func loadQuests() {
        if let savedQuestsData = UserDefaults.standard.object(forKey: "savedQuests") as? Data {
            let decoder = JSONDecoder()
            if let loadedQuests = try? decoder.decode([Quest].self, from: savedQuestsData) {
                quests = loadedQuests
                questsTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QuestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath) as? QuestCell else {
            return UITableViewCell()
        }
        
        let quest = quests[indexPath.row]
        cell.configure(with: quest) // Configure the cell with quest data
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Adjust the height as needed
    }
}
