//
//  StringLocalization.swift
//  Life RPG
//
//  Created by Beau on 22/9/2567 BE.
//

import Foundation

let LocalizeUserDefaultKey = "LocalizeUserDefaultKey"
var LocalizeDefaultLanguage = "en"

extension String {
    func localized() -> String {
        if let path = Bundle.main.path(forResource: LocalizeDefaultLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return ""
    }
}
