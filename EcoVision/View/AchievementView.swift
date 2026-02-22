//
//  AchievementView.swift
//  EcoVision
//

import SwiftUI

struct AchievementView: View {

    let achievement: Achievement

    var body: some View {

        VStack(spacing: 8) {

            Image(systemName: achievement.icon)
                .font(.title)
                .foregroundColor(.green)

            Text(achievement.title)
                .font(.caption)
                .multilineTextAlignment(.center)

        }
        .frame(width: 90, height: 90)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

