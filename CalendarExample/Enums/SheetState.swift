//
//  SheetState.swift
//  CalendarExample
//
//  Created by Colby Mehmen on 5/28/24.
//

import Foundation
import MooCal

enum SheetState: Hashable, Identifiable {
    var id: Self { return self }
    case eventInputSheet
    case events(CalendarDay, [Event])
    
    var title: String {
        switch self {
        case .eventInputSheet:
            return "Event Input Sheet"
        case .events(_, _):
            return "Events"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.title)
        
        switch self {
        case .events(_, let events):
            hasher.combine(events)
        default:
            break
        }
    }
}
