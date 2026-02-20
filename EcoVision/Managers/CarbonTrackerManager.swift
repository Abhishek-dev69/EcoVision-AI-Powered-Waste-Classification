import Foundation

final class CarbonTrackerManager {

    static let shared = CarbonTrackerManager()

    private init() {}

    func todayCO2() -> Double {

        let today = Calendar.current.startOfDay(for: Date())

        return HistoryManager.shared.fetch()
            .filter { $0.date >= today }
            .reduce(0) { $0 + $1.carbonFootprint }
    }

    func weekCO2() -> Double {

        let weekAgo = Calendar.current.date(
            byAdding: .day,
            value: -7,
            to: Date()
        )!

        return HistoryManager.shared.fetch()
            .filter { $0.date >= weekAgo }
            .reduce(0) { $0 + $1.carbonFootprint }
    }

    func weekChartData() -> [CarbonDataPoint] {

        let records = HistoryManager.shared.fetch()

        return records.map {

            CarbonDataPoint(
                date: $0.date,
                value: $0.carbonFootprint
            )
        }
    }
}

