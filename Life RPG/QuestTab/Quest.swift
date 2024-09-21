//
//  Quest.swift
//  Life RPG
//
//  Created by Paing Thu Ta on 5/9/2567 BE.
//

import Foundation

enum QuestStatus: String, Codable {
    case Inprogress = "In Progress"
    case completed = "Completed"
    case canceled = "Canceled"
}

struct Quest: Codable {
    var title: String
    var details: String
    var repeats: String
    var expValue: Int
    var difficulty: String
    var dueDate: Date
    var status: QuestStatus = .Inprogress
}


