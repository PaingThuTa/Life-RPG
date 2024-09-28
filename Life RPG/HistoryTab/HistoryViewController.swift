//
//  HistoryViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 20/9/24.
//
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var clearHistoryButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var quests: [Quest] = []
    
    // Define the key for loading all quests
    let allQuestsKey = "allQuests"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadQuests()  // Initial loading of quests
        updateLocalizationUI()
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
            print("No data found in UserDefaults")
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
        let alert = UIAlertController(
            title: "Clear History".localized(),
            message: "Are you sure you want to delete all quest history?".localized(),
            preferredStyle: .alert
        )

        // Add a cancel action to allow the user to back out
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))

        // Add a clear action that will remove the data
        alert.addAction(UIAlertAction(title: "Clear".localized(), style: .destructive, handler: { [weak self] _ in
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
        
        let feedbackAlert = UIAlertController(
            title: "Done".localized(), // Localized title
            message: "Quest history has been successfully cleared.".localized(), // Localized message
            preferredStyle: .alert
        )
        feedbackAlert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil)) // Localized button title
        present(feedbackAlert, animated: true, completion: nil)
    }

    @objc func updateLocalizationUI() {
        historyLabel.text = "History".localized()
        clearHistoryButton.setTitle("Clear history".localized(), for: .normal)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let quest = quests[indexPath.row]
        cell.titleLabel.text = quest.title
        cell.detailsLabel.text = quest.details
        cell.difficultyLabel.text = quest.difficulty.localized()
        cell.statusLabel.text = quest.status.localized
        cell.headStatusLabel.text = "Status:".localized()

        // Set difficulty color based on the quest's difficulty
        switch quest.difficulty {
        case "Easy".localized():
                cell.difficultyLabel.textColor = UIColor.black
        case "Normal".localized():
                cell.difficultyLabel.textColor = UIColor.black
        case "Hard".localized():
                cell.difficultyLabel.textColor = UIColor.black
        case "Extreme".localized():
                cell.difficultyLabel.textColor = UIColor.black
        case "Absurd".localized():
                cell.difficultyLabel.textColor = UIColor.black
            default:
                cell.difficultyLabel.textColor = UIColor.black // Default color
        }
        return cell
    }
}

