//
//  QuestEditViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 12/9/24.
//

import UIKit

class QuestEditViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets for editing quest fields
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var expValueLabel: UILabel!
    @IBOutlet weak var difficultyPickerView: UIPickerView!
    @IBOutlet weak var repeatPopupButton: UIButton!
    
    @IBOutlet weak var editQuestPageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsRestrictionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var questEXPValueLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    // Variable to hold the quest passed from QuestInfoViewController
    var quest: Quest?
    
    // Completion handler to pass the updated quest back
    var updateQuestCompletion: ((Quest) -> Void)?
    
    // Difficulty levels and corresponding EXP values
    var difficultyLevels = ["Easy", "Normal", "Hard", "Extreme", "Absurd"]
    var expValues = [100, 200, 300, 500, 1000]
    
    var selectedDifficultyIndex: Int = 1 // Default is "Normal"

    // Keep the Repeat Option Value
    var selectedRepeatOption: RepeatOption = .none
    
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
            case .none: return "None".localized()
            case .daily: return "Every Day".localized()
            case .weekly: return "Every Week".localized()
            case .monthly: return "Every Month".localized()
            case .yearly: return "Every Year".localized()
            }
        }
    }
    
    let repeatOptionTitles: [String] = [
        RepeatOption.none.description,
        RepeatOption.daily.description,
        RepeatOption.weekly.description,
        RepeatOption.monthly.description,
        RepeatOption.yearly.description
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pre-fill the text fields and labels with the quest data
        if let quest = quest {
            titleTextField.text = quest.title
            detailsTextField.text = quest.details
            
            // Set the date picker to the quest's due date
            datePicker.date = quest.dueDate
            datePicker.minimumDate = Date()
            
            // Set the difficulty picker and EXP value
            if let index = difficultyLevels.firstIndex(of: quest.difficulty) {
                selectedDifficultyIndex = index
                difficultyPickerView.selectRow(index, inComponent: 0, animated: false)
                expValueLabel.text = "\(expValues[index])"
            }
            
            // Popup Repeat Button edits
            switch quest.repeats {
            case "None".localized(): selectedRepeatOption = .none
            case "Every Day".localized(): selectedRepeatOption = .daily
            case "Every Week".localized(): selectedRepeatOption = .weekly
            case "Every Month".localized(): selectedRepeatOption = .monthly
            case "Every Year".localized(): selectedRepeatOption = .yearly
            default: selectedRepeatOption = .none
            }
            // Set title based on the selectedRepeatOption
            repeatPopupButton.setTitle(selectedRepeatOption.description, for: .normal)
        }
        
        // Set up the UIPickerView delegate and data source
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
        
        // Set up the Repeat Popup Button
        setRepeatPopupButton()
        
        detailsTextField.delegate = self
                
        // Tap gesture to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // App Localize
        updateLocalizationUI()
//        updateLocalizedDifficultyLevels()
        
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true) // Dismisses the keyboard when tapping outside
        }

    // UITextFieldDelegate method to limit detailsTextField to 300 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == detailsTextField {
                let currentText = textField.text ?? ""
                let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
                // Check the character count
                if newText.count > 200 {
                    // Show an alert when the character count exceeds 300
                    showAlert()
                    return false // Prevent further input
                }
                return true // Allow input if under the character limit
            }
            return true
        }

        // Function to show an alert when the user passes 300 characters
    func showAlert() {
        let alert = UIAlertController(title: "Character Limit Reached", message: "You have reached the 200-character limit for details.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setRepeatPopupButton() {
        let optionClosure = { (action: UIAction) in
            switch action.title {
            case self.repeatOptionTitles[0]: self.selectedRepeatOption = .none
            case self.repeatOptionTitles[1]: self.selectedRepeatOption = .daily
            case self.repeatOptionTitles[2]: self.selectedRepeatOption = .weekly
            case self.repeatOptionTitles[3]: self.selectedRepeatOption = .monthly
            case self.repeatOptionTitles[4]: self.selectedRepeatOption = .yearly
            default: break
            }
            self.repeatPopupButton.setTitle(self.selectedRepeatOption.description, for: .normal)
        }
        // Create the menu for repeat options
        repeatPopupButton.menu = UIMenu(children: [
            UIAction(title: self.repeatOptionTitles[0], state: selectedRepeatOption == .none ? .on : .off, handler: optionClosure),
            UIAction(title: self.repeatOptionTitles[1], state: selectedRepeatOption == .daily ? .on : .off, handler: optionClosure),
            UIAction(title: self.repeatOptionTitles[2], state: selectedRepeatOption == .weekly ? .on : .off, handler: optionClosure),
            UIAction(title: self.repeatOptionTitles[3], state: selectedRepeatOption == .monthly ? .on : .off, handler: optionClosure),
            UIAction(title: self.repeatOptionTitles[4], state: selectedRepeatOption == .yearly ? .on : .off, handler: optionClosure)])
        
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
            id: quest?.id ?? UUID(),
            title: title,
            details: details,
            repeats: selectedRepeatOption.description,
            expValue: expValues[selectedDifficultyIndex], // Use the selected EXP value based on difficulty
            difficulty: difficultyLevels[selectedDifficultyIndex], // Use the selected difficulty level
            dueDate: datePicker.date // Updated due date
        )

        // Pass the updated quest back to QuestInfoViewController
        updateQuestCompletion?(updatedQuest)

        // Dismiss or pop the view controller
        navigationController?.popViewController(animated: true)
    }
    
    private func selectedRepeatOptionIndex() -> Int {
        switch selectedRepeatOption {
        case .none: return 0
        case .daily: return 1
        case .weekly: return 2
        case .monthly: return 3
        case .yearly: return 4
        }
        
    }
    
//    private func updateLocalizedDifficultyLevels() {
//        // App localization for Difficulty's choices
//        difficultyLevels = [
//            "Easy".localized(),
//            "Normal".localized(),
//            "Hard".localized(),
//            "Extreme".localized(),
//            "Absurd".localized()
//        ]
//        difficultyPickerView.reloadAllComponents()
//    }
    
    @objc func updateLocalizationUI() {
        // To access another language
        editQuestPageLabel.text = "Edit Quest Information".localized()
        titleLabel.text = "Title".localized()
        detailsLabel.text = "Details".localized()
        detailsRestrictionLabel.text = "*No more than 200 letters".localized()
        dueDateLabel.text = "Due Date".localized()
        repeatLabel.text = "Repeat".localized()
        questEXPValueLabel.text = "Quest EXP Value".localized()
        difficultyLabel.text = "Difficulty".localized()
        titleTextField.placeholder = "Enter your quest title".localized()
        detailsTextField.placeholder = "Enter task details".localized()
        
        doneButton.setTitle("Done".localized(), for: .normal)
        
        let repeatOptionTitles = [
            RepeatOption.none.description,
            RepeatOption.daily.description,
            RepeatOption.weekly.description,
            RepeatOption.monthly.description,
            RepeatOption.yearly.description
        ]

        repeatPopupButton.setTitle(repeatOptionTitles[selectedRepeatOptionIndex()], for: .normal)
        
        difficultyPickerView.selectRow(selectedDifficultyIndex, inComponent: 0, animated: false)
        
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
