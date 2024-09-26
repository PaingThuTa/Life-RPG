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
    
    @IBOutlet weak var questInfoLabel: UILabel!
    @IBOutlet weak var headTitleLabel: UILabel!
    @IBOutlet weak var headDetailsLabel: UILabel!
    @IBOutlet weak var headDueDateLabel: UILabel!
    @IBOutlet weak var headRepeatLabel: UILabel!
    @IBOutlet weak var headQuestExpValueLabel: UILabel!
    @IBOutlet weak var headDifficultyLabel: UILabel!
    @IBOutlet weak var headStatusLabel: UILabel!
    

    var quest: Quest? // The quest object to display

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateLocalizationUI()
    }

    func updateUI() {
        guard let quest = quest else { return }
        titleLabel.text = quest.title
        detailsLabel.text = quest.details
        dueDateLabel.text = formatDate(quest.dueDate)
        repeatLabel.text = quest.repeats.localized()
        expValueLabel.text = "\(quest.expValue)"
        difficultyLabel.text = quest.difficulty.localized()
        statusLabel.text = quest.status.localized
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    @objc func updateLocalizationUI() {
        questInfoLabel.text = "Quest Info".localized()
        headTitleLabel.text = "Title".localized()
        headDetailsLabel.text = "Details".localized()
        headDueDateLabel.text = "Due Date".localized()
        headRepeatLabel.text = "Repeat".localized()
        headQuestExpValueLabel.text = "Quest EXP Value".localized()
        headDifficultyLabel.text = "Difficulty".localized()
        headStatusLabel.text = "Status".localized()
        
    }
}

