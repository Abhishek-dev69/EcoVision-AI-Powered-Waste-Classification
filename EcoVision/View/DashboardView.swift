import SwiftUI

struct DashboardView: View {

    @StateObject private var vm = DashboardViewModel()
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {

        NavigationStack {

            ZStack {

                // SAME gradient as ContentView
                EcoGradientBackground()

                ScrollView {

                    VStack(spacing: 20) {

                        Spacer().frame(height: 10)

                        //////////////////////////////////////////////////////
                        // MARK: Eco Score Card
                        //////////////////////////////////////////////////////

                        VStack(spacing: 10) {

                            Text("Eco Score")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            Text("\(vm.ecoScore)")
                                .font(.system(size: 46, weight: .bold))
                                .foregroundColor(.green)

                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(cardBackground)
                        .overlay(cardBorder)
                        .cornerRadius(20)
                        .shadow(color: shadowColor, radius: 12, y: 6)

                        //////////////////////////////////////////////////////
                        // MARK: Carbon Summary Card
                        //////////////////////////////////////////////////////

                        CarbonSummaryCard(
                            total: vm.totalCO2,
                            today: vm.todayCO2,
                            week: vm.weekCO2
                        )

                        //////////////////////////////////////////////////////
                        // MARK: Carbon Chart
                        //////////////////////////////////////////////////////

                        CarbonChartView(data: vm.chartData)
                            .padding()
                            .background(cardBackground)
                            .overlay(cardBorder)
                            .cornerRadius(20)
                            .shadow(color: shadowColor, radius: 12, y: 6)

                        //////////////////////////////////////////////////////
                        // MARK: Recent History
                        //////////////////////////////////////////////////////

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Recent Scans")
                                .font(.headline)

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

                            NavigationLink {

                                HistoryView()

                            } label: {

                                Text("View Full History →")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.green)
                            }
                            .padding(.top, 6)
                        }
                        .padding()
                        .background(cardBackground)
                        .overlay(cardBorder)
                        .cornerRadius(20)
                        .shadow(color: shadowColor, radius: 12, y: 6)

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

    //////////////////////////////////////////////////////
    // MARK: UI Helpers
    //////////////////////////////////////////////////////

    var cardBackground: some View {
        colorScheme == .dark
        ? Color.white.opacity(0.05)
        : Color.white.opacity(0.7)
    }

    var cardBorder: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(
                colorScheme == .dark
                ? Color.white.opacity(0.1)
                : Color.white.opacity(0.5)
            )
    }

    var shadowColor: Color {
        colorScheme == .dark
        ? .black.opacity(0.5)
        : .black.opacity(0.12)
    }
}

