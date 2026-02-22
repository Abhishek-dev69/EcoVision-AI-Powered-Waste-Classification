//
//  OnboardingView.swift
//  EcoVision
//
//  Created by Abhishek on 20/02/26.
//

//
//  OnboardingView.swift
//  EcoVision
//
//  WWDC-level onboarding experience
//

import SwiftUI

struct OnboardingView: View {

    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    @State private var currentPage = 0

    var body: some View {

        ZStack {

            EcoGradientBackground()

            VStack {

                Spacer()

                TabView(selection: $currentPage) {

                    OnboardingPage(
                        icon: "camera.viewfinder",
                        title: "Scan Waste Instantly",
                        description: "Use your camera to identify waste using on-device AI. No internet required."
                    )
                    .tag(0)

                    OnboardingPage(
                        icon: "leaf.arrow.circlepath",
                        title: "Understand Environmental Impact",
                        description: "See carbon footprint, decomposition time, and eco-friendly disposal guidance."
                    )
                    .tag(1)

                    OnboardingPage(
                        icon: "chart.bar.fill",
                        title: "Track Your Eco Progress",
                        description: "Monitor your eco score, carbon impact, and sustainable habits over time."
                    )
                    .tag(2)

                    OnboardingPage(
                        icon: "brain.head.profile",
                        title: "Runs Fully On-Device",
                        description: "Your privacy is protected. All AI processing happens locally on your device."
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                Spacer()

                Button {

                    if currentPage < 3 {
                        currentPage += 1
                    } else {
                        hasSeenOnboarding = true
                    }

                } label: {

                    HStack {

                        Spacer()

                        Text(currentPage == 3 ? "Get Started" : "Next")

                        Image(systemName: "arrow.right")

                        Spacer()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
                    .shadow(color: .green.opacity(0.4), radius: 10)
                }
                .padding(.horizontal, 30)

                Spacer().frame(height: 40)
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// MARK: Onboarding Page
//////////////////////////////////////////////////////////////

struct OnboardingPage: View {

    let icon: String
    let title: String
    let description: String

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {

        VStack(spacing: 25) {

            Image(systemName: icon)
                .font(.system(size: 70))
                .foregroundColor(.green)
                .shadow(radius: 10)

            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(
                    colorScheme == .dark ? .white : .black
                )

            Text(description)
                .font(.system(size: 17))
                .foregroundColor(
                    colorScheme == .dark
                    ? .white.opacity(0.7)
                    : .black.opacity(0.6)
                )
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
    }
}
