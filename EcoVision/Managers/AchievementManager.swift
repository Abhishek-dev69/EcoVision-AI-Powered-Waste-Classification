//
//  AchievementManager.swift
//  EcoVision
//
//  Created by Abhishek on 22/02/26.
//

import Foundation

final class AchievementManager {

    static let shared = AchievementManager()

    private init() {}

    let achievements = [

        Achievement(
            title: "First Scan",
            icon: "sparkles",
            requirement: 1
        ),

        Achievement(
            title: "Eco Beginner",
            icon: "leaf",
            requirement: 10
        ),

        Achievement(
            title: "Eco Hero",
            icon: "globe",
            requirement: 50
        ),

        Achievement(
            title: "Eco Champion",
            icon: "crown",
            requirement: 100
        )
    ]

    func unlockedAchievements() -> [Achievement] {

        let count = HistoryManager.shared.fetch().count

        return achievements.filter {
            count >= $0.requirement
        }
    }
}
