//
//  StringLocalization.swift
//  Life RPG
//
//  Created by Beau on 22/9/2567 BE.
//

import Foundation

// Key used to store the user's language preference in UserDefaults
let LocalizeUserDefaultKey = "LocalizeUserDefaultKey"

// Default language, can be dynamically updated based on UserDefaults
var LocalizeDefaultLanguage: String {
    get {
        // Return the language stored in UserDefaults or default to "en"
        return UserDefaults.standard.string(forKey: LocalizeUserDefaultKey) ?? "en"
    }
    set {
        // Update the value in UserDefaults when the language changes
        UserDefaults.standard.setValue(newValue, forKey: LocalizeUserDefaultKey)
    }
}

// String extension to load the localized string based on the current language
extension String {
    func localized() -> String {
        // Try to find the bundle for the current language
        if let path = Bundle.main.path(forResource: LocalizeDefaultLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            // Return the localized string from the appropriate bundle
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return self // Fallback to the string itself if localization fails
    }
}
