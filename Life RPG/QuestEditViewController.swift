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
    @IBOutlet weak var expValueLabel: UILabel!
    @IBOutlet weak var difficultyPickerView: UIPickerView!
    @IBOutlet weak var repeatPopupButton: UIButton!
    
    
    // Variable to hold the quest passed from QuestInfoViewController
    var quest: Quest?
    
    // Completion handler to pass the updated quest back
    var updateQuestCompletion: ((Quest) -> Void)?
    
    // Difficulty levels and corresponding EXP values
    let difficultyLevels = ["Easy", "Normal", "Hard", "Extreme", "Absurd"]
    let expValues = [100, 200, 300, 500, 1000]
    
    var selectedDifficultyIndex: Int = 1 // Default is "Normal"

    // Popup Button Implementation
    enum RepeatOption {
        case none
        case daily
        case weekly
        case monthly
        case yearly
        
        // String representation
        var description: String {
            switch self {
            case .none:
                return "None"
            case .daily:
                return "Every Day"
            case .weekly:
                return "Every Week"
            case .monthly:
                return "Every Month"
            case .yearly:
                return "Every Year"
            }
        }
    }
    
    // Keep the Repeat Option Value
    var selectedRepeatOption: RepeatOption = .none
    
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
            
            // Popup Repeat Button edits
            switch quest.repeats {
            case "None":
                selectedRepeatOption = .none
            case "Every Day":
                selectedRepeatOption = .daily
            case "Every Week":
                selectedRepeatOption = .weekly
            case "Every Month":
                selectedRepeatOption = .monthly
            case "Every Year":
                selectedRepeatOption = .yearly
            default:
                selectedRepeatOption = .none
            }
            repeatPopupButton.setTitle(selectedRepeatOption.description, for: .normal)
        }
        
        // Set up the UIPickerView delegate and data source
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
        
        // Set up the Repeat Popup Button
        setRepeatPopupButton()
    }
    
    private func setRepeatPopupButton() {
        let optionClosure = { (action: UIAction) in
            switch action.title {
            case "None":
                self.selectedRepeatOption = .none
            case "Every Day":
                self.selectedRepeatOption = .daily
            case "Every Week":
                self.selectedRepeatOption = .weekly
            case "Every Month":
                self.selectedRepeatOption = .monthly
            case "Every Year":
                self.selectedRepeatOption = .yearly
            default:
                break
            }
            self.repeatPopupButton.setTitle(self.selectedRepeatOption.description, for: .normal)
        }
        // Create the menu for repeat options
        repeatPopupButton.menu = UIMenu(children: [
            UIAction(title: "None", state: selectedRepeatOption == .none ? .on : .off, handler: optionClosure),
            UIAction(title: "Every Day", state: selectedRepeatOption == .daily ? .on : .off, handler: optionClosure),
            UIAction(title: "Every Week", state: selectedRepeatOption == .weekly ? .on : .off, handler: optionClosure),
            UIAction(title: "Every Month", state: selectedRepeatOption == .monthly ? .on : .off, handler: optionClosure),
            UIAction(title: "Every Year", state: selectedRepeatOption == .yearly ? .on : .off, handler: optionClosure)])
        
        repeatPopupButton.showsMenuAsPrimaryAction = true
        repeatPopupButton.changesSelectionAsPrimaryAction = true
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
            repeats: selectedRepeatOption.description,
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
