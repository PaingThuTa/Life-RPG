//
//  MainViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 1/9/2567 BE.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tasksTableView: UITableView!

    // Array to store tasks or topics
    var topics: [Topic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }

    // This function is called when "Add New Topic" is clicked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddTopic", let addTopicVC = segue.destination as? AddTopicViewController {
            addTopicVC.addTopicCompletion = { [weak self] newTopic in
                self?.topics.append(newTopic)
                self?.tasksTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
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
