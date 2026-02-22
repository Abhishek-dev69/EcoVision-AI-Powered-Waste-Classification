import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {

    //////////////////////////////////////////////////////
    // MARK: Published State
    //////////////////////////////////////////////////////

    @Published var history: [ScanRecord] = []

    @Published var ecoScore: Int = 0

    @Published var totalCO2: Double = 0
    @Published var todayCO2: Double = 0
    @Published var weekCO2: Double = 0

    @Published var currentStreak: Int = 0

    @Published var treesSaved: Double = 0

    @Published var achievements: [Achievement] = []

    @Published var chartData: [CarbonDataPoint] = []

    //////////////////////////////////////////////////////
    // MARK: Load Dashboard Data
    //////////////////////////////////////////////////////

    func loadDashboardData() {

        let records = HistoryManager.shared.fetch()

        history = records

        ecoScore = EcoScoreManager.shared.calculateScore(records: records)

        totalCO2 = ImpactManager.shared.totalCO2Saved()

        todayCO2 = CarbonTrackerManager.shared.todayCO2()

        weekCO2 = CarbonTrackerManager.shared.weekCO2()

        chartData = CarbonTrackerManager.shared.weekChartData()

        currentStreak = StreakManager.shared.currentStreak()

        // FIXED
        treesSaved = ImpactEquivalenceManager.shared.treesSaved(co2: totalCO2)

        achievements = AchievementManager.shared.unlockedAchievements()
    }
}

