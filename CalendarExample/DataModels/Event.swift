//
//  CalendarEvent.swift
//  CalendarExample
//
//  Created by Colby Mehmen on 5/28/24.
//

import Foundation
import SwiftData
import MooCal
import SwiftUI

public struct Event: ClassicCalendarData, CalendarData, Identifiable, Codable {
    public var id: UUID
    public var date: Date
    public var color: Color
    public var title: String
    public var creator: String
    
    enum CodingKeys: String, CodingKey {
        case id, date, color, title, creator
    }
    
    public init(id: UUID = UUID(), date: Date, color: Color, title: String, creator: String) {
        self.id = id
        self.date = date
        self.color = color
        self.title = title
        self.creator = creator
    }
    
    // Custom init for decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        let codableColor = try container.decode(CodableColor.self, forKey: .color)
        color = codableColor.color
        title = try container.decode(String.self, forKey: .title)
        creator = try container.decode(String.self, forKey: .creator)
    }
    
    // Custom encode method
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        let codableColor = CodableColor(color: color)
        try container.encode(codableColor, forKey: .color)
        try container.encode(title, forKey: .title)
        try container.encode(creator, forKey: .creator)
    }
    
}
