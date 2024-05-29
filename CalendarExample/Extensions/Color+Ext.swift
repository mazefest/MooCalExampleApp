//
//  Color+Ext.swift
//  CalendarExample
//
//  Created by Colby Mehmen on 5/28/24.
//

import Foundation
import SwiftUI
import MooCal

extension Color {
    init(codableColor: CodableColor) {
        self.init(red: codableColor.red, green: codableColor.green, blue: codableColor.blue, opacity: codableColor.alpha)
    }
}
