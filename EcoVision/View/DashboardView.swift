//
//  DashboardView.swift
//  EcoVision
//
//  WWDC-level Dashboard with Eco Score, Streak, Achievements, Impact
//

import SwiftUI

struct DashboardView: View {

    @StateObject private var vm = DashboardViewModel()
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {

        NavigationStack {

            ZStack {

                //////////////////////////////////////////////////////
                // MARK: Eco Gradient Background
                //////////////////////////////////////////////////////

                EcoGradientBackground()

                //////////////////////////////////////////////////////
                // MARK: Scroll Content
                //////////////////////////////////////////////////////

                ScrollView {

                    VStack(spacing: 20) {

                        Spacer().frame(height: 10)

                        //////////////////////////////////////////////////////
                        // MARK: Eco Score Ring Card
                        //////////////////////////////////////////////////////

                        VStack(spacing: 12) {

                            Text("Eco Score")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            EcoScoreRingView(score: vm.ecoScore)

                        }
                        .cardStyle(colorScheme)

                        //////////////////////////////////////////////////////
                        // MARK: Streak Card 🔥 NEW
                        //////////////////////////////////////////////////////

                        VStack(spacing: 10) {

                            Text("Current Streak")
                                .font(.headline)

                            HStack(spacing: 8) {

                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)

                                Text("\(vm.currentStreak) days")
                                    .font(.system(size: 28, weight: .bold))
                            }

                            Text("Keep scanning daily to grow your streak")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .cardStyle(colorScheme)

                        //////////////////////////////////////////////////////
                        // MARK: Trees Saved 🌳 NEW
                        //////////////////////////////////////////////////////

                        VStack(spacing: 10) {

                            Text("Environmental Impact")
                                .font(.headline)

                            HStack {

                                VStack {

                                    Text("\(vm.totalCO2, specifier: "%.2f") kg")
                                        .font(.title2.bold())

                                    Text("CO₂ tracked")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                VStack {

                                    Text("\(vm.treesSaved)")
                                        .font(.title2.bold())

                                    Text("Trees saved equivalent")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .cardStyle(colorScheme)

                        //////////////////////////////////////////////////////
                        // MARK: Carbon Summary
                        //////////////////////////////////////////////////////

                        CarbonSummaryCard(
                            total: vm.totalCO2,
                            today: vm.todayCO2,
                            week: vm.weekCO2
                        )
                        .cardStyle(colorScheme)

                        //////////////////////////////////////////////////////
                        // MARK: Carbon Chart
                        //////////////////////////////////////////////////////

                        CarbonChartView(data: vm.chartData)
                            .cardStyle(colorScheme)

                        //////////////////////////////////////////////////////
                        // MARK: Achievements 🏆 NEW
                        //////////////////////////////////////////////////////

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Achievements")
                                .font(.headline)

                            ScrollView(.horizontal, showsIndicators: false) {

                                HStack(spacing: 16) {

                                    ForEach(vm.achievements) { achievement in

                                        AchievementView(
                                            achievement: achievement
                                        )
                                    }
                                }
                            }
                        }
                        .cardStyle(colorScheme)

                        //////////////////////////////////////////////////////
                        // MARK: Recent History
                        //////////////////////////////////////////////////////

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Recent Scans")
                                .font(.headline)

                            if vm.history.isEmpty {

                                Text("No scans yet")
                                    .foregroundColor(.secondary)

                            } else {

                                ForEach(vm.history.prefix(5)) { record in

                                    HStack {

                                        Text(record.label)

                                        Spacer()

                                        Text(
                                            "\(record.carbonFootprint, specifier: "%.2f") kg"
                                        )
                                        .foregroundColor(.secondary)
                                    }

                                    Divider()
                                }
                            }

                            NavigationLink {

                                HistoryView()

                            } label: {

                                Text("View Full History →")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.green)
                            }
                        }
                        .cardStyle(colorScheme)

                        Spacer().frame(height: 30)
                    }
                    .padding()
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            vm.loadDashboardData()
        }
    }
}

//////////////////////////////////////////////////////////////
// MARK: Card Style Modifier
//////////////////////////////////////////////////////////////

extension View {

    func cardStyle(_ scheme: ColorScheme) -> some View {

        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                scheme == .dark
                ? Color.white.opacity(0.05)
                : Color.white.opacity(0.7)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        scheme == .dark
                        ? Color.white.opacity(0.1)
                        : Color.white.opacity(0.5)
                    )
            )
            .cornerRadius(20)
            .shadow(
                color: scheme == .dark
                ? .black.opacity(0.5)
                : .black.opacity(0.12),
                radius: 12,
                y: 6
            )
    }
}

