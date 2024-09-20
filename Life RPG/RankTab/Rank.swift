//
//  Rank.swift
//  Life RPG
//
//  Created by Beau on 19/9/2567 BE.
//

import Foundation

struct Rank: Decodable {
    let id: String
    let name: String
    let alternateNames: [String]?
    let species: String
    let gender: String
    let house: String?
    let dateOfBirth: String? // Format: "MM-DD-YYYY"
    let yearOfBirth: Int?
    let isWizard: Bool?
    let ancestry: String
    let eyeColour: String?
    let hairColour: String?
    let wand: Wand?
    let patronus: String?
    let isHogwartsStudent: Bool?
    let isHogwartsStaff: Bool?
    let actor: String
    let alternateActors: [String]?
    let isAlive: Bool?
    let image: String?
    
    // Alphabet Rankings
    var alphabetRank: String?
    
    struct Wand: Decodable {
        let wood: String?
        let core: String?
        let length: Float?
    }
}
