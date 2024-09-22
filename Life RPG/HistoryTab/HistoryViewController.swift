//
//  HistoryViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 20/9/24.
//
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var quests: [Quest] = []
    
    // Define the key for loading all quests
    let allQuestsKey = "allQuests"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadQuests()  // Initial loading of quests
    }

    // Reload quests every time the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadQuests()  // Reload quests when the view appears to ensure updated data
        tableView.reloadData()  // Refresh the table view
    }

    // Load quests from UserDefaults using the allQuestsKey
    // Load quests from UserDefaults using the allQuestsKey
    func loadQuests() {
        if let savedData = UserDefaults.standard.data(forKey: allQuestsKey) {
            let decoder = JSONDecoder()
            if let loadedQuests = try? decoder.decode([Quest].self, from: savedData) {
                quests = loadedQuests.reversed()  // Reverse the order of quests to show the newest ones at the top
            }
        }
    }


    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        let quest = quests[indexPath.row]
        cell.titleLabel.text = quest.title
        cell.detailsLabel.text = quest.details
        cell.difficultyLabel.text = quest.difficulty
        cell.statusLabel.text = quest.status.rawValue

        // Set difficulty color based on the quest's difficulty
        switch quest.difficulty {
            case "Easy":
                cell.difficultyLabel.textColor = UIColor.systemGreen
            case "Normal":
                cell.difficultyLabel.textColor = UIColor.systemBlue
            case "Hard":
                cell.difficultyLabel.textColor = UIColor.systemOrange
            case "Extreme":
                cell.difficultyLabel.textColor = UIColor.systemRed
            case "Absurd":
                cell.difficultyLabel.textColor = UIColor.systemPurple
            default:
                cell.difficultyLabel.textColor = UIColor.black // Default color
        }
        return cell
    }
}

