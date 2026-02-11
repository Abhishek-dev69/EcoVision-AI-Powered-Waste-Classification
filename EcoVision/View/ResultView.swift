//
//  ResultView.swift
//  EcoVision
//
//  Created by Abhishek on 12/02/26.
//

import SwiftUI

struct ResultView: View {

    let result: DetectionResult?

    var body: some View {
        if let result,
           let item = Items.forLabel(result.label) {

            VStack(spacing: 16) {
                Text(item.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Confidence: \(Int(result.confidence * 100))%")
                    .foregroundColor(.secondary)

                Text("Carbon Footprint")
                    .font(.headline)

                Text(item.footprint)
                    .font(.title2)

                Divider()

                Text("Better Alternative")
                    .font(.headline)

                Text(item.suggestion)
                    .multilineTextAlignment(.center)
            }
            .padding()
        } else {
            Text("Unable to classify image")
        }
    }
}
