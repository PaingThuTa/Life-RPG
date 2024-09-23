//
//  QuestCell.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 5/9/2567 BE.
//

import UIKit

class QuestCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var questDueLabel: UILabel!
    
    // Configure the cell with quest data
    func configure(with quest: Quest) {
        titleLabel.text = quest.title
        detailsLabel.text = quest.details
        questDueLabel.text = "Quest Due:".localized()
        
        // Set difficulty label with color
        difficultyLabel.text = quest.difficulty
        setDifficultyColor(for: quest.difficulty)

        
        // Set due date and days left
        let daysLeft = calculateDaysLeft(until: quest.dueDate)
        dueDateLabel.text = "\(daysLeft) days left"
    }
    
    // Helper function to calculate the days left
    private func calculateDaysLeft(until date: Date) -> Int {
        let currentDate = Date()
        let difference = Calendar.current.dateComponents([.day], from: currentDate, to: date)
        return difference.day ?? 0
    }
    
    // Set difficulty color based on the difficulty level
    private func setDifficultyColor(for difficulty: String) {
        switch difficulty {
        case "Easy".localized():
            difficultyLabel.textColor = .green
        case "Normal".localized():
            difficultyLabel.textColor = .blue
        case "Hard".localized():
            difficultyLabel.textColor = .purple
        case "Extreme".localized():
            difficultyLabel.textColor = .red
        case "Absurd".localized():
            difficultyLabel.textColor = .brown
        default:
            difficultyLabel.textColor = .black
        }
    }
    
}
