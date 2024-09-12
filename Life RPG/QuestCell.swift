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
//    @IBOutlet weak var expValueLabel: UILabel!
//    @IBOutlet weak var completionDateLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    // Configure the cell with quest data
    func configure(with quest: Quest) {
        titleLabel.text = quest.title
        detailsLabel.text = quest.details
        
        // Set difficulty label with color
        difficultyLabel.text = quest.difficulty
        setDifficultyColor(for: quest.difficulty)

        
        // Set due date and days left
        let daysLeft = calculateDaysLeft(until: quest.completionDate) // Assuming due date is same as completion date
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
        case "Easy":
            difficultyLabel.textColor = .green
        case "Normal":
            difficultyLabel.textColor = .blue
        case "Hard":
            difficultyLabel.textColor = .purple
        case "Extreme":
            difficultyLabel.textColor = .red
        case "Absurd":
            difficultyLabel.textColor = .brown
        default:
            difficultyLabel.textColor = .black
        }
    }
}
