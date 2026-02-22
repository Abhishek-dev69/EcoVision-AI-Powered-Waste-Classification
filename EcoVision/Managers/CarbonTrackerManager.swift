import Foundation

final class CarbonTrackerManager {

    static let shared = CarbonTrackerManager()

    private init() {}

    // MARK: Today CO₂

    func todayCO2() -> Double {

        let calendar = Calendar.current

        return HistoryManager.shared.fetch()
            .filter {
                calendar.isDateInToday($0.date)
            }
            .reduce(0) { $0 + $1.carbonFootprint }
    }

    // MARK: Week CO₂ total

    func weekCO2() -> Double {

        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -6, to: Date())!

        return HistoryManager.shared.fetch()
            .filter { $0.date >= weekAgo }
            .reduce(0) { $0 + $1.carbonFootprint }
    }

    // MARK: Weekly chart data (FIXED)

    func weekChartData() -> [CarbonDataPoint] {

        let calendar = Calendar.current
        let records = HistoryManager.shared.fetch()

        var result: [CarbonDataPoint] = []

        // Generate last 7 days including today
        for offset in (0..<7).reversed() {

            guard let date = calendar.date(
                byAdding: .day,
                value: -offset,
                to: Date()
            ) else { continue }

            let dayTotal =
                records
                .filter {
                    calendar.isDate($0.date, inSameDayAs: date)
                }
                .reduce(0) { $0 + $1.carbonFootprint }

            result.append(
                CarbonDataPoint(
                    date: calendar.startOfDay(for: date),
                    value: dayTotal
                )
            )
        }

        return result
    }
}

