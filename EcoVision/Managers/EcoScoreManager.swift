//
//  EcoScoreManager.swift
//  EcoVision
//
//  Created by Abhishek on 20/02/26.
//

import Foundation

final class EcoScoreManager {

    static let shared = EcoScoreManager()

    private init() {}

    func calculateScore(records: [ScanRecord]) -> Int {

        guard !records.isEmpty else { return 100 }

        let totalCarbon =
            records.reduce(0) { $0 + $1.carbonFootprint }

        let avgCarbon =
            totalCarbon / Double(records.count)
        let score =
            max(0, 100 - Int(avgCarbon * 50))

        return min(score, 100)
    }

    func ecoLevel(score: Int) -> String {

        switch score {

        case 80...100:
            return "Eco Champion"

        case 60...79:
            return "Eco Friendly"

        case 40...59:
            return "Eco Learner"

        default:
            return "Needs Improvement"
        }
    }
}
