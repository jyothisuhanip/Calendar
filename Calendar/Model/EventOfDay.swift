//
//  EventOfDay.swift
//  Calendar
//
//  Created by Jyothi Suhani on 02/03/20.
//  Copyright © 2020 Jyothi Suhani. All rights reserved.
//

import Foundation
class EventOfDay: Codable {
    var reminders: [EventData]?
}

class EventData: Codable {
    var day: Int?
    var month: Int?
    var year: Int?
    var events: [String]
}
