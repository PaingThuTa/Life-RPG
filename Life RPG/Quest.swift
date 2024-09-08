//
//  Quest.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 5/9/2567 BE.
//

import Foundation

struct Quest: Codable {
    var title: String
    var details: String
    var expValue: Int
    var difficulty: String
    let completionDate: Date
    var dueDate: Date
}



//Type something.
