//
//  CalendarExampleApp.swift
//  CalendarExample
//
//  Created by Colby Mehmen on 5/28/24.
//

import SwiftUI
import MooCal

@main
struct CalendarExampleApp: App {
    @ObservedObject var eventManager = ObjectManager<Event>(location: .events)
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                eventManager: eventManager,
                viewModel: .init()
            )
        }
    }
}
