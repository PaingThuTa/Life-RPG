//
//  AddTopicViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 1/9/2567 BE.
//

import UIKit

// MARK: - Topic Model
struct Topic {
    var title: String
    var goal: String
    var league: String
    var level: Int
    var expToLevelUp: Int
    var totalExp: Int
}

// MARK: - AddTopicViewController
class AddTopicViewController: UIViewController {

    // IBOutlets for UI elements
    @IBOutlet weak var topicTitleTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var expToLevelUpLabel: UILabel!
    @IBOutlet weak var totalExpLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!

    // This will be used to pass data back to the previous screen
    var addTopicCompletion: ((Topic) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaultValues()
    }

    private func configureDefaultValues() {
        // Set default values for league, level, exp, etc.
        leagueLabel.text = "Beginner"
        levelLabel.text = "Lvl 0"
        expToLevelUpLabel.text = "484"
        totalExpLabel.text = "0"
    }

    // Done button action to save the topic
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard let title = topicTitleTextField.text, !title.isEmpty,
              let goal = goalTextField.text, !goal.isEmpty else {
            // Show alert for missing required fields
            let alert = UIAlertController(title: "Error", message: "Please fill in all required fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        let newTopic = Topic(
            title: title,
            goal: goal,
            league: leagueLabel.text ?? "Beginner",
            level: Int(levelLabel.text?.replacingOccurrences(of: "Lvl ", with: "") ?? "0") ?? 0,
            expToLevelUp: Int(expToLevelUpLabel.text ?? "484") ?? 484,
            totalExp: Int(totalExpLabel.text ?? "0") ?? 0
        )

        // Call the completion handler to pass the data back
        addTopicCompletion?(newTopic)

        // Dismiss or pop back to the previous view controller
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TaskViewController
class TaskViewController: UIViewController {

    @IBOutlet weak var tasksTableView: UITableView!

    // Array to store tasks or topics
    var topics: [Topic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }

    // Function to navigate to AddTopicViewController
    @IBAction func addNewTopicButtonTapped(_ sender: UIButton) {
        if let addTopicVC = storyboard?.instantiateViewController(withIdentifier: "AddTopicViewController") as? AddTopicViewController {
            addTopicVC.addTopicCompletion = { [weak self] newTopic in
                self?.topics.append(newTopic)
                self?.tasksTableView.reloadData()
            }
            navigationController?.pushViewController(addTopicVC, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        let topic = topics[indexPath.row]
        cell.textLabel?.text = topic.title
        cell.detailTextLabel?.text = "Level: \(topic.level) | EXP: \(topic.totalExp)"
        return cell
    }
}
