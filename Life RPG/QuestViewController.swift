//
//  MainViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 1/9/2567 BE.
//

import UIKit

// MARK: - QuestViewController
class QuestViewController: UIViewController {
    
    @IBOutlet weak var questsTableView: UITableView!
    
    // Array to store quests
    var quests: [Quest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate and data source for the table view
        questsTableView.delegate = self
        questsTableView.dataSource = self
        
        // Register the custom cell if using one
        // questsTableView.register(UINib(nibName: "QuestCell", bundle: nil), forCellReuseIdentifier: "QuestCell")
    }
    
    // Function to navigate to AddQuestViewController
    @IBAction func addNewQuestButtonTapped(_ sender: UIButton) {
        if let addQuestVC = storyboard?.instantiateViewController(withIdentifier: "AddQuestViewController") as? AddQuestViewController {
            
            // Set the completion handler for passing data back
            addQuestVC.addQuestCompletion = { [weak self] newQuest in
                self?.quests.append(newQuest) // Add the new quest to the array
                
                self?.questsTableView.reloadData() // Reload the table to reflect the new data
            }
            
            navigationController?.pushViewController(addQuestVC, animated: true)
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
