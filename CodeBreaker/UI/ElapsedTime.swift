//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by Gabriel Williams on 03/01/2026.
//

import SwiftUI

struct ElapsedTime: View {
    var startTime: Date
    var endTime: Date?
    
    var body: some View {
        if let endTime {
            Text(endTime, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        } else {
            Text(TimeDataSource<Date>.currentDate, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        }
    }
}

