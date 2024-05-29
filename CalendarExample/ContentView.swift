//
//  ContentView.swift
//  CalendarExample
//
//  Created by Colby Mehmen on 5/28/24.
//

import SwiftUI
import MooCal

struct ContentView: View {
    @ObservedObject var eventManager: ObjectManager<Event>
    @ObservedObject var viewModel: ScrollableCalendarViewViewModel
    
    @State var sheetState: SheetState? = nil
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollableCalendarView<EmptyView, EmptyView, EmptyView>(
                calendarDayView: .classic(eventManager.objects),
                onSelection: { calendarDay in
                    onCalendarDaySelection(calendarDay)
                }
            )
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        guard let currentMonthId = viewModel.currentMonthId else {
                            return
                        }
                        proxy.scrollTo(currentMonthId)
                    }, label: {
                        Text("Today")
                            .bold()
                    })
                    .tint(Color.blue)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        sheetState = .eventInputSheet
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .tint(Color.blue)
                }
            }
            .sheet(item: $sheetState, content: { sheetState in
                switch self.sheetState {
                case .eventInputSheet, .none:
                    eventInputSheet()
                case .events(let calendarDay, let events):
                    let events = eventManager.objects.filter({$0.date.isInDay(calendarDay.date)})
                    calendarDayEventView(calendarDay: calendarDay, events: events)
                }
            })
        }
    }
    
    private func onCalendarDaySelection(_ calendarDay: CalendarDay) {
        self.sheetState = .events(calendarDay, eventManager.objects)
    }
    
    // View for inputting event info
    private func eventInputSheet() -> some View {
        NavigationView {
            EventInputSheet { newEvent in
                self.eventManager.add(newEvent)
            }
        }
        .navigationTitle("New Event")
    }
    
    // View for viewing, updating and modifying events
    private func calendarDayEventView(calendarDay: CalendarDay, events: [Event]) -> some View {
        NavigationView {
            DayEventView(events: events) { action in
                switch action {
                case .delete(let event):
                    self.eventManager.remove(event)
                    
                case .update(let event):
                    self.eventManager.update(event)
                }
            }
            .navigationTitle(calendarDay.date.formatted())
        }
    }
}

#Preview {
    NavigationView(content: {
        ContentView(eventManager: ObjectManager<Event>(location: .events), viewModel: .init())
    })
}
