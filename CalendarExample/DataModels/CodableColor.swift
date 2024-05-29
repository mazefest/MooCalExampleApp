//
//  CodableColor.swift
//  CalendarExample
//
//  Created by Colby Mehmen on 5/28/24.
//

import Foundation
import SwiftUI

struct CodableColor: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init(color: Color) {
        if let components = color.cgColor?.components, components.count >= 4 {
            self.red = Double(components[0])
            self.green = Double(components[1])
            self.blue = Double(components[2])
            self.alpha = Double(components[3])
        } else {
            self.red = 0
            self.green = 0
            self.blue = 0
            self.alpha = 1
        }
    }
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }
}
