//
//  MainViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 1/9/2567 BE.
//
import UIKit

class QuestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var welcomePlayerLabel: UILabel!
    @IBOutlet weak var letsMoveOnsubtitleLabel: UILabel!
    @IBOutlet weak var activeQuestLabel: UILabel!
    @IBOutlet weak var addQuestButton: UIButton!
    
    @IBOutlet weak var questsTableView: UITableView!
    
    var quests: [Quest] = [] // Array to store active quests

    // UserDefaults keys for active and all quests
    let activeQuestsKey = "activeQuests"
    let allQuestsKey = "allQuests"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questsTableView.delegate = self
        questsTableView.dataSource = self
        
        loadActiveQuests()  // Load active quests from UserDefaults
        updateQuestDisplay()  // Display only pending quests
        updateLocalizationUI() // App localization
    }

    func updateQuestDisplay() {
        // Display only pending (In Progress) quests
        quests = quests.filter { $0.status == .Inprogress }
        questsTableView.reloadData()
    }

    func questDidUpdate(_ quest: Quest) {
        // Update the quest in the array
        if let index = quests.firstIndex(where: { $0.title == quest.title }) {
            quests[index] = quest
        } else {
            // Add new quest if not found
            quests.append(quest)
        }
        
        saveActiveQuests()  // Save updated active quests
        saveAllQuests()  // Save updated quest in the full quest list
        updateQuestDisplay()  // Refresh the table view
    }

    // Save active quests to UserDefaults
    func saveActiveQuests() {
        let encoder = JSONEncoder()
        let activeQuests = quests.filter { $0.status == .Inprogress } // Only save active quests
        if let encodedData = try? encoder.encode(activeQuests) {
            UserDefaults.standard.set(encodedData, forKey: activeQuestsKey)
        }
    }

    // Save all quests to UserDefaults
    func saveAllQuests() {
        var currentQuests: [Quest] = []
        
        // Load existing quests from UserDefaults for the allQuestsKey
        if let savedData = UserDefaults.standard.data(forKey: allQuestsKey) {
            let decoder = JSONDecoder()
            if let loadedQuests = try? decoder.decode([Quest].self, from: savedData) {
                currentQuests = loadedQuests
            }
        }
        
        // Update or append the quest
        for quest in quests {
            if let index = currentQuests.firstIndex(where: { $0.title == quest.title }) {
                currentQuests[index] = quest // Update existing quest
            } else {
                currentQuests.append(quest) // Add new quest
            }
        }
        
        // Save the updated quest list
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(currentQuests) {
            UserDefaults.standard.set(encodedData, forKey: allQuestsKey)
        }
    }

    // Load active quests from UserDefaults
    func loadActiveQuests() {
        if let savedData = UserDefaults.standard.data(forKey: activeQuestsKey) {
            let decoder = JSONDecoder()
            if let loadedQuests = try? decoder.decode([Quest].self, from: savedData) {
                quests = loadedQuests
            }
        }
    }

    // Add New Quest
    @IBAction func addNewQuestButtonTapped(_ sender: UIButton) {
        if let addQuestVC = storyboard?.instantiateViewController(withIdentifier: "AddQuestViewController") as? AddQuestViewController {
            
            // Set the completion handler to add the new quest
            addQuestVC.addQuestCompletion = { [weak self] newQuest in
                self?.quests.append(newQuest)
                self?.saveActiveQuests() // Save the active quest
                self?.saveAllQuests() // Save all quests, including this new one
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

    // Handle quest selection
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
    
    @objc func updateLocalizationUI() {
        // To access another language
        welcomePlayerLabel.text = "Welcome player,".localized()
        letsMoveOnsubtitleLabel.text = "Subtitle".localized()
        activeQuestLabel.text = "Active Quests".localized()
        addQuestButton.setTitle("+ add new quest".localized(), for: .normal)

    }
}


