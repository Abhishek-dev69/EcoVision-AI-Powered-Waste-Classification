import SwiftUI

struct EcoScoreRingView: View {

    let score: Int
    let maxScore: Int = 100

    @State private var animatedScore: Double = 0

    @Environment(\.colorScheme) private var colorScheme

    var progress: Double {
        Double(score) / Double(maxScore)
    }

    var body: some View {

        ZStack {

            // MARK: Background Ring

            Circle()
                .stroke(
                    Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.15),
                    lineWidth: 18
                )

            // MARK: Progress Ring

            Circle()
                .trim(from: 0, to: animatedScore)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            .green,
                            .mint,
                            .cyan,
                            .green
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: 18,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .shadow(
                    color: .green.opacity(0.6),
                    radius: 10
                )

            // MARK: Inner Glow

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.green.opacity(0.25),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )

            // MARK: Score Text

            VStack(spacing: 4) {

                Text("\(score)")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.green)

                Text("Eco Score")
                    .font(.system(size: 14))
                    .foregroundColor(
                        colorScheme == .dark
                        ? .white.opacity(0.7)
                        : .black.opacity(0.6)
                    )
            }
        }
        .frame(width: 160, height: 160)
        .onAppear {

            withAnimation(
                .easeOut(duration: 1.2)
            ) {
                animatedScore = progress
            }
        }
    }
}
