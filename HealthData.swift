//
//  HealthData.swift
//  homePageFinal
//
//  Created by GEU on 10/03/26.
//

import Foundation

struct PeriodEntry {
    var startDate: Date
    var endDate: Date
}

struct HealthDataManager {

    static var periodEntries: [PeriodEntry] = []

    static func addPeriod(start: Date, end: Date) {

        // Avoid duplicate entries for same day
        if periodEntries.contains(where: {
            Calendar.current.isDate($0.startDate, inSameDayAs: start)
        }) {
            return
        }

        let entry = PeriodEntry(startDate: start, endDate: end)
        periodEntries.append(entry)

        // Sort entries by date
        periodEntries.sort { $0.startDate < $1.startDate }

        print("Saved periods:", periodEntries)
    }
}
