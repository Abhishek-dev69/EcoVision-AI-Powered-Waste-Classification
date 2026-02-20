import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {

    // MARK: Published UI State

    @Published var history: [ScanRecord] = []

    @Published var ecoScore: Int = 0

    @Published var totalCO2: Double = 0
    @Published var todayCO2: Double = 0
    @Published var weekCO2: Double = 0

    @Published var chartData: [CarbonDataPoint] = []

    // MARK: Load everything

    func loadDashboardData() {

        let records = HistoryManager.shared.fetch()

        history = records

        ecoScore = ImpactManager.shared.calculateEcoScore()

        totalCO2 = ImpactManager.shared.totalCO2Saved()

        todayCO2 = CarbonTrackerManager.shared.todayCO2()

        weekCO2 = CarbonTrackerManager.shared.weekCO2()

        chartData = CarbonTrackerManager.shared.weekChartData()
    }
}

