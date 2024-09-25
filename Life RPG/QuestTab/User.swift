//
//  User.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 25/9/24.
//

import Foundation


class User {
    var currentLevel: Int {
        didSet {
            UserDefaults.standard.set(currentLevel, forKey: UserDefaultsKeys.currentLevel)
            UserDefaults.standard.synchronize()
        }
    }
    
    var currentExp: Int {
        didSet {
            UserDefaults.standard.set(currentExp, forKey: UserDefaultsKeys.currentExp)
            checkForLevelUp()
            UserDefaults.standard.synchronize()
        }
    }
    
    var currentRank: String {
        didSet {
            UserDefaults.standard.set(currentRank, forKey: UserDefaultsKeys.currentRank)
            UserDefaults.standard.synchronize()
            //currentRank = "E"
        }
        
    }

    init(currentLevel: Int, currentExp: Int, currentRank: String) {
        self.currentLevel = UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentLevel)
        self.currentExp = UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentExp)
        self.currentRank = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentRank) ?? "E"
        updateRank()
    }

    
    func addExp(_ exp: Int) {
        currentExp += exp
        checkForLevelUp()
        UserDefaults.standard.set(currentExp, forKey: UserDefaultsKeys.currentExp)
        UserDefaults.standard.synchronize()
    }

        // Optional: Logic for handling level-ups
     func checkForLevelUp() {
        while currentExp >= expToNextLevel() {
            currentExp -= expToNextLevel()
            currentLevel += 1
            currentRank = calculateRank(for: currentLevel)
        }
    }
    
    
    func updateRank() {
        currentRank = calculateRank(for: currentLevel)
    }
    
    func expToNextLevel() -> Int {
        switch currentLevel {
        case 1...20: return 1000
        case 21...40: return 1500
        case 41...80: return 2000
        case 81...160: return 2500
        case 161...320: return 3000
        case 321...640: return 3500
        case 641...1280: return 4000
        case 1281...9999: return 4500
        default: return 1000
        }
    }
    
    func calculateRank(for level: Int) -> String {
        switch level {
        case 1...20: return "E"
        case 21...40: return "D"
        case 41...80: return "C"
        case 81...160: return "B"
        case 161...320: return "A"
        case 321...640: return "S"
        case 641...1280: return "SS"
        case 1281...9999: return "SSS"
        default: return "F"
        }
    }

    
}
