//
//  QuestEditViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 12/9/24.
//

import UIKit

class QuestEditViewController: UIViewController {
    
    // Outlets for editing quest fields
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var expValueLabel: UILabel!
    @IBOutlet weak var difficultyPickerView: UIPickerView!
    
    // Variable to hold the quest passed from QuestInfoViewController
    var quest: Quest?
    
    // Completion handler to pass the updated quest back
    var updateQuestCompletion: ((Quest) -> Void)?
    
    // Difficulty levels and corresponding EXP values
    let difficultyLevels = ["Easy", "Normal", "Hard", "Extreme", "Absurd"]
    let expValues = [100, 200, 300, 500, 1000]
    
    var selectedDifficultyIndex: Int = 1 // Default is "Normal"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pre-fill the text fields and labels with the quest data
        if let quest = quest {
            titleTextField.text = quest.title
            detailsTextField.text = quest.details
            
            // Set the date picker to the quest's due date
            datePicker.date = quest.dueDate
            
            // Set the difficulty picker and EXP value
            if let index = difficultyLevels.firstIndex(of: quest.difficulty) {
                selectedDifficultyIndex = index
                difficultyPickerView.selectRow(index, inComponent: 0, animated: false)
                expValueLabel.text = "\(expValues[index])"
            }
        }
        
        // Set up the UIPickerView delegate and data source
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
    }
    
    // Action for the Done button
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        // Ensure the title and details are not empty
        guard let title = titleTextField.text, !title.isEmpty,
              let details = detailsTextField.text, !details.isEmpty else {
            return // Handle empty fields (show an error if needed)
        }

        // Capture the updated quest details
        let updatedQuest = Quest(
            title: title,
            details: details,
            expValue: expValues[selectedDifficultyIndex], // Use the selected EXP value based on difficulty
            difficulty: difficultyLevels[selectedDifficultyIndex], // Use the selected difficulty level
            completionDate: quest?.completionDate ?? Date(), // Keep the same completion date
            dueDate: datePicker.date // Updated due date
        )

        // Pass the updated quest back to QuestInfoViewController
        updateQuestCompletion?(updatedQuest)

        // Dismiss or pop the view controller
        navigationController?.popViewController(animated: true)
    }
}

extension QuestEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Only 1 component for the difficulty options
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficultyLevels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return difficultyLevels[row] // Display the difficulty level name in the picker
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDifficultyIndex = row
        expValueLabel.text = "\(expValues[row])" // Update EXP value label when difficulty is selected
    }
}
