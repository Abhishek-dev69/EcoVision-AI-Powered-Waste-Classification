//
//  ImpactEquivalenceManager.swift
//  EcoVision
//
//  Created by Abhishek on 22/02/26.
//

import Foundation

final class ImpactEquivalenceManager {

    static let shared = ImpactEquivalenceManager()

    private init() {}

    func treesSaved(co2: Double) -> Double {

        // 1 tree absorbs 21kg CO2/year
        return co2 / 21.0
    }

    func carKmEquivalent(co2: Double) -> Double {

        // car emits 0.12kg/km
        return co2 / 0.12
    }
}
