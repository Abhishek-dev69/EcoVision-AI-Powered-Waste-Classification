import SwiftUI
import Charts

struct CarbonChartView: View {

    let data: [CarbonDataPoint]

    var body: some View {

        VStack(alignment: .leading) {

            Text("Weekly Carbon Impact")
                .font(.headline)

            if data.isEmpty {

                Text("No data available")
                    .foregroundColor(.secondary)
                    .frame(height: 200)

            } else {

                Chart(data) { item in

                    LineMark(
                        x: .value("Day", item.date, unit: .day),
                        y: .value("CO₂", item.value)
                    )
                    .foregroundStyle(.green)

                    AreaMark(
                        x: .value("Day", item.date, unit: .day),
                        y: .value("CO₂", item.value)
                    )
                    .foregroundStyle(.green.opacity(0.2))
                }
                .frame(height: 200)
            }
        }
    }
}

