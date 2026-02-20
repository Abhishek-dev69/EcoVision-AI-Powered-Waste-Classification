//
//  CarbonDataPoint.swift
//  EcoVision
//
//  Created by Abhishek on 20/02/26.
//

import Foundation

struct CarbonDataPoint: Identifiable {

    let id = UUID()

    let date: Date

    let value: Double
}
