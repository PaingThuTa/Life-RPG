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
    func loadQuests() {
        guard let savedData = UserDefaults.standard.data(forKey: allQuestsKey) else {
            print("Error: No data found in UserDefaults")
            // Optionally, update the UI to reflect that no data was loaded
            return
        }

        let decoder = JSONDecoder()
        do {
            let loadedQuests = try decoder.decode([Quest].self, from: savedData)
            quests = loadedQuests.reversed()  // Reverse the order of quests to show the newest ones at the top
        } catch {
            print("Error decoding quests: \(error)")
            // Handle the error appropriately, possibly showing an alert to the user
            displayLoadError()
        }
    }

    func displayLoadError() {
        let alert = UIAlertController(title: "Load Error", message: "Failed to load quest history.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func clearHistoryTapped(_ sender: UIButton) {
        // Create an alert controller to confirm the clearing of history
        let alert = UIAlertController(title: "Clear History", message: "Are you sure you want to delete all quest history?", preferredStyle: .alert)

        // Add a cancel action to allow the user to back out
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Add a clear action that will remove the data
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { [weak self] _ in
            self?.clearQuestHistory()
        }))

        // Present the alert to the user
        present(alert, animated: true, completion: nil)
    }

    // This function will clear the history from UserDefaults and update the UI
    func clearQuestHistory() {
        // Remove quests from UserDefaults
        UserDefaults.standard.removeObject(forKey: allQuestsKey)

        // Clear the local quests array
        quests = []

        // Reload the table view to reflect that history has been cleared
        tableView.reloadData()

        // Optionally, provide feedback that history has been cleared
        let feedbackAlert = UIAlertController(title: "Done", message: "Quest history has been successfully cleared.", preferredStyle: .alert)
        feedbackAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(feedbackAlert, animated: true, completion: nil)
    }

    


    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let detailsVC = storyboard?.instantiateViewController(identifier: "HistoryDetailsViewController") as? HistoryDetailsViewController {
            let selectedQuest = quests[indexPath.row]
            detailsVC.quest = selectedQuest

            navigationController?.pushViewController(detailsVC, animated: true)
        }

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

