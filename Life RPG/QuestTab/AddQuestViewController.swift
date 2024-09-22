//
//  AddTopicViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 1/9/2567 BE.
//

import UIKit

class AddQuestViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets for the input fields
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var difficultyPickerView: UIPickerView!
    @IBOutlet weak var expValueLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var repeatPopupButton: UIButton!
    
    // Difficulty levels and corresponding EXP values
    let difficultyLevels = ["Easy", "Normal", "Hard", "Extreme", "Absurd"]
    let expValues = [100, 200, 300, 500, 1000]
    
    // Keys for UserDefaults
    let activeQuestsKey = "activeQuests"
    let allQuestsKey = "allQuests"
    
    // Keep track of the selected difficulty
    var selectedDifficultyIndex: Int = 1 // Default is "Normal" (index 1)
    
    // Completion handler to pass data back
    var addQuestCompletion: ((Quest) -> Void)?
    
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
        
        // Setup UIPickerView
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
        
        // Set the default difficulty and corresponding EXP value
        difficultyPickerView.selectRow(selectedDifficultyIndex, inComponent: 0, animated: false)
        expValueLabel.text = "\(expValues[selectedDifficultyIndex])"
        
        datePicker.calendar = Calendar(identifier: .gregorian)
        
        setRepeatPopupButton()
        detailsTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // Handle character limit for the detailsTextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == detailsTextField {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= 200 // Limit to 200 characters
        }
        return true
    }

    // Function to show an alert when the user passes 200 characters
    func showAlert() {
        let alert = UIAlertController(title: "Character Limit Reached", message: "You have reached the 200-character limit for details.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // Repeat Pop-up Button
    func setRepeatPopupButton() {
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
            self.repeatPopupButton.setTitle(action.title, for: .normal)
        }
        
        repeatPopupButton.menu = UIMenu(children : [
            UIAction(title: "None", state: selectedRepeatOption == .none ? .on : .off, handler: optionClosure),
            UIAction(title: "Every Day", state: selectedRepeatOption == .daily ? .on : .off, handler: optionClosure),
            UIAction(title: "Every Week", state: selectedRepeatOption == .weekly ? .on : .off, handler: optionClosure),
            UIAction(title: "Every Month", state: selectedRepeatOption == .monthly ? .on : .off, handler: optionClosure),
            UIAction(title: "Every Year", state: selectedRepeatOption == .yearly ? .on : .off, handler: optionClosure)
        ])
        
        repeatPopupButton.showsMenuAsPrimaryAction = true
        repeatPopupButton.changesSelectionAsPrimaryAction = true
    }

    // Action for Done button
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let details = detailsTextField.text, !details.isEmpty else {
            // Show error if fields are empty
            return
        }
        
        // Get the selected date from the date picker
        let selectedDate = datePicker.date
        
        // Create a new quest with the selected date
        let quest = Quest(
            title: title,
            details: details,
            repeats: selectedRepeatOption.description,
            expValue: expValues[selectedDifficultyIndex],
            difficulty: difficultyLevels[selectedDifficultyIndex],
            dueDate: selectedDate,
            status: .Inprogress  // All new quests are "In Progress" by default
        )

        // Save the new quest to active quests
        saveToActiveQuests(quest)

        // Save the new quest to all quests
        saveToAllQuests(quest)
        
        // Pass the quest back using the closure
        addQuestCompletion?(quest)
        
        // Dismiss the view or go back to the previous screen
        navigationController?.popViewController(animated: true)
    }

    // Save to Active Quests (only quests in progress)
    func saveToActiveQuests(_ newQuest: Quest) {
        var activeQuests: [Quest] = []
        
        // Load existing active quests
        if let savedData = UserDefaults.standard.data(forKey: activeQuestsKey) {
            let decoder = JSONDecoder()
            if let loadedQuests = try? decoder.decode([Quest].self, from: savedData) {
                activeQuests = loadedQuests
            }
        }
        
        // Add the new quest and save back to UserDefaults
        activeQuests.append(newQuest)
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(activeQuests) {
            UserDefaults.standard.set(encodedData, forKey: activeQuestsKey)
        }
    }

    // Save to All Quests (including completed, canceled, and in progress)
    func saveToAllQuests(_ newQuest: Quest) {
        var allQuests: [Quest] = []
        
        // Load existing all quests
        if let savedData = UserDefaults.standard.data(forKey: allQuestsKey) {
            let decoder = JSONDecoder()
            if let loadedQuests = try? decoder.decode([Quest].self, from: savedData) {
                allQuests = loadedQuests
            }
        }
        
        // Add the new quest and save back to UserDefaults
        allQuests.append(newQuest)
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(allQuests) {
            UserDefaults.standard.set(encodedData, forKey: allQuestsKey)
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddQuestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Only 1 component for the difficulty options
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficultyLevels.count // Number of difficulty levels
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return difficultyLevels[row] // Display the difficulty level name in the picker
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update the selected difficulty index
        selectedDifficultyIndex = row
        
        // Update the EXP value label based on the selected difficulty
        expValueLabel.text = "\(expValues[row])"
    }
}
