//
//  StreakManager.swift
//  EcoVision
//
//  Created by Abhishek on 22/02/26.
//

import Foundation

final class StreakManager {

    static let shared = StreakManager()

    private let streakKey = "eco_streak"
    private let lastScanKey = "last_scan_date"

    private init() {}

    func updateStreak() {

        let today = Calendar.current.startOfDay(for: Date())

        let lastScan = UserDefaults.standard.object(forKey: lastScanKey) as? Date

        var streak = UserDefaults.standard.integer(forKey: streakKey)

        if let lastScan {

            let days = Calendar.current.dateComponents(
                [.day],
                from: Calendar.current.startOfDay(for: lastScan),
                to: today
            ).day ?? 0

            if days == 1 {
                streak += 1
            }
            else if days > 1 {
                streak = 1
            }
        }
        else {
            streak = 1
        }

        UserDefaults.standard.set(streak, forKey: streakKey)
        UserDefaults.standard.set(today, forKey: lastScanKey)
    }
    func currentStreak() -> Int {
        UserDefaults.standard.integer(forKey: streakKey)
    }
}
