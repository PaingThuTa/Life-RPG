//
//  MainViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 1/9/2567 BE.
//

import UIKit

class QuestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var questsTableView: UITableView!
    
    var quests: [Quest] = [] // Array to store all quests

    // UserDefaults key for saving and loading quests
    let questsKey = "savedQuests"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questsTableView.delegate = self
        questsTableView.dataSource = self
        
        loadQuests()  // Load quests from UserDefaults
        updateQuestDisplay()  // Display only pending quests
    }

    func updateQuestDisplay() {
        // Only display pending quests in QuestViewController
        quests = quests.filter { $0.status == .pending }
        questsTableView.reloadData()
    }

    func questDidUpdate(_ quest: Quest) {
        // Update the quest in the array
        if let index = quests.firstIndex(where: { $0.title == quest.title }) {
            quests[index] = quest
        }
        saveQuests()  // Save the updated quests to UserDefaults
        updateQuestDisplay()  // Refresh the table view
    }

    // Save quests to UserDefaults
    func saveQuests() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(quests) {
            UserDefaults.standard.set(encodedData, forKey: questsKey)
        }
    }

    // Load quests from UserDefaults
    func loadQuests() {
        if let savedData = UserDefaults.standard.data(forKey: questsKey) {
            let decoder = JSONDecoder()
            if let loadedQuests = try? decoder.decode([Quest].self, from: savedData) {
                quests = loadedQuests
            }
        }
    }

    // Add New Quest
    @IBAction func addNewQuestButtonTapped(_ sender: UIButton) {
        if let addQuestVC = storyboard?.instantiateViewController(withIdentifier: "AddQuestViewController") as? AddQuestViewController {
            
            // Set the completion handler for passing data back
            addQuestVC.addQuestCompletion = { [weak self] newQuest in
                self?.quests.append(newQuest)
                self?.saveQuests() // Save the new quest to UserDefaults
                self?.updateQuestDisplay() // Update quest list to show the new quest
            }
            
            navigationController?.pushViewController(addQuestVC, animated: true)
        }
    }

    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath) as! QuestCell
        let quest = quests[indexPath.row]
        cell.configure(with: quest)
        return cell
    }

    // Handle quest selection and segue to QuestInfoViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuest = quests[indexPath.row]
        if let questInfoVC = storyboard?.instantiateViewController(withIdentifier: "QuestInfoViewController") as? QuestInfoViewController {
            questInfoVC.quest = selectedQuest
            questInfoVC.updateQuestCompletion = { [weak self] updatedQuest in
                self?.questDidUpdate(updatedQuest)
            }
            navigationController?.pushViewController(questInfoVC, animated: true)
        }
    }
}

