//
//  AddTopicViewController.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 1/9/2567 BE.
//

import UIKit

class AddQuestViewController: UIViewController {
    
    // Outlets for the input fields
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var difficultyPickerView: UIPickerView! // UIPickerView for selecting difficulty
    @IBOutlet weak var expValueLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var repeatPopupView: UIButton! // "Beau Added"
    
    // Difficulty levels and corresponding EXP values
    let difficultyLevels = ["Easy", "Normal", "Hard", "Extreme", "Absurd"]
    let expValues = [100, 200, 300, 500, 1000]
    
    // Keep track of the selected difficulty
    var selectedDifficultyIndex: Int = 1 // Default is "Normal" (index 1)
    
    // Completion handler to pass data back
    var addQuestCompletion: ((Quest) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UIPickerView
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
        
        // Set the default difficulty and corresponding EXP value
        difficultyPickerView.selectRow(selectedDifficultyIndex, inComponent: 0, animated: false)
        expValueLabel.text = "\(expValues[selectedDifficultyIndex])"
        
        datePicker.calendar = Calendar(identifier: .gregorian)
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
        
        // Create a new quest with the selected date as both the completion and due date
        let quest = Quest(
            title: title,
            details: details,
            expValue: expValues[selectedDifficultyIndex], difficulty: difficultyLevels[selectedDifficultyIndex],
            completionDate: selectedDate,
            dueDate: selectedDate // You can customize this if the due date should be different
        )
        
        // Pass the quest back using the closure
        addQuestCompletion?(quest)
        
        // Dismiss the view or go back to the previous screen
        navigationController?.popViewController(animated: true)
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
