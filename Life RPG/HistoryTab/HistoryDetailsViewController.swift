//
//  HistoryQuestViewController.swift
//  Life RPG
//
//  Created by Beau on 22/9/2567 BE.
//

import UIKit

class HistoryDetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var expValueLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    var quest: Quest? // The quest object to display

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI() {
        guard let quest = quest else { return }
        titleLabel.text = quest.title
        detailsLabel.text = quest.details
        dueDateLabel.text = formatDate(quest.dueDate)
        repeatLabel.text = quest.repeats
        expValueLabel.text = "\(quest.expValue)"
        difficultyLabel.text = quest.difficulty
        statusLabel.text = quest.status.rawValue
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
