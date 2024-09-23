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
    
    @IBOutlet weak var addQuestPageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsRestrictionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var questEXPValueLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    // Difficulty levels and corresponding EXP values
    var difficultyLevels: [String] = ["Easy", "Normal", "Hard", "Extreme", "Absurd"]
    let expValues = [100, 200, 300, 500, 1000]
    
    // Keys for UserDefaults
    let activeQuestsKey = "activeQuests"
    let allQuestsKey = "allQuests"
    
    // Keep track of the selected difficulty
    var selectedDifficultyIndex: Int = 1 // Default is "Normal" (index 1)
    
    // Completion handler to pass data back
    var addQuestCompletion: ((Quest) -> Void)?
    
    // Keep the Repeat Option Value
    var selectedRepeatOption: RepeatOption = .none
    
    // Localized titles for repeat options
    var repeatOptionTitles: [String] = []
    
    // Popup Button Implementation
    enum RepeatOption: Int {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UIPickerView
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
        
        // Set the default difficulty and corresponding EXP value
        difficultyPickerView.selectRow(selectedDifficultyIndex, inComponent: 0, animated: false)
        expValueLabel.text = "\(expValues[selectedDifficultyIndex])"
        
        datePicker.calendar = Calendar(identifier: .gregorian)
        
        setupRepeatButtonMenu()
        detailsTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        updateLocalizationUI()
        setupRepeatButtonMenu()
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
    
    func setupRepeatButtonMenu() {
        guard repeatOptionTitles.count >= 5 else {
            print("Error: repeatOptionTitles does not have enough items. Current count: \(repeatOptionTitles.count)")
            return // Exit early if titles are not available
        }
        
        let optionClosure = { (action: UIAction) in
            switch action.title {
            case self.repeatOptionTitles[0]: self.selectedRepeatOption = .none
            case self.repeatOptionTitles[1]: self.selectedRepeatOption = .daily
            case self.repeatOptionTitles[2]: self.selectedRepeatOption = .weekly
            case self.repeatOptionTitles[3]: self.selectedRepeatOption = .monthly
            case self.repeatOptionTitles[4]: self.selectedRepeatOption = .yearly
            default: break
            }
            self.repeatPopupButton.setTitle(action.title, for: .normal)
        }
        
        repeatPopupButton.menu = UIMenu(children : [
            UIAction(title: repeatOptionTitles[0], state: selectedRepeatOption == .none ? .on : .off, handler: optionClosure),
            UIAction(title: repeatOptionTitles[1], state: selectedRepeatOption == .daily ? .on : .off, handler: optionClosure),
            UIAction(title: repeatOptionTitles[2], state: selectedRepeatOption == .weekly ? .on : .off, handler: optionClosure),
            UIAction(title: repeatOptionTitles[3], state: selectedRepeatOption == .monthly ? .on : .off, handler: optionClosure),
            UIAction(title: repeatOptionTitles[4], state: selectedRepeatOption == .yearly ? .on : .off, handler: optionClosure)
        ])
        
        repeatPopupButton.showsMenuAsPrimaryAction = true
        repeatPopupButton.changesSelectionAsPrimaryAction = true
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
    
    @objc func updateLocalizationUI() {
        // To access another language
        addQuestPageLabel.text = "Add Quest".localized()
        titleLabel.text = "Title".localized()
        detailsLabel.text = "Details".localized()
        detailsRestrictionLabel.text = "*No more than 200 letters".localized()
        dueDateLabel.text = "Due Date".localized()
        repeatLabel.text = "Repeat".localized()
        questEXPValueLabel.text = "Quest EXP Value".localized()
        difficultyLabel.text = "Difficulty".localized()
        titleTextField.placeholder = "Enter your quest title".localized()
        detailsTextField.placeholder = "Enter task details".localized()
        
        // App Localize for Repeat options
        repeatOptionTitles = [
            RepeatOption.none.description.localized(),
            RepeatOption.daily.description.localized(),
            RepeatOption.weekly.description.localized(),
            RepeatOption.monthly.description.localized(),
            RepeatOption.yearly.description.localized()
        ]
        
        repeatPopupButton.setTitle(repeatOptionTitles[selectedRepeatOptionIndex()], for: .normal)
        
        
        // App localization for Difficulty's choices
        difficultyLevels[0] = "Easy".localized()
        difficultyLevels[1] = "Normal".localized()
        difficultyLevels[2] = "Hard".localized()
        difficultyLevels[3] = "Extreme".localized()
        difficultyLevels[4] = "Absurd".localized()
        
        difficultyPickerView.reloadAllComponents()
        
        doneButton.setTitle("Done".localized(), for: .normal)
        
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

