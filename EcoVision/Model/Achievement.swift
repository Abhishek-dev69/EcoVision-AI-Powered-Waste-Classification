//
//  Achievement.swift
//  EcoVision
//
//  Created by Abhishek on 22/02/26.
//

import Foundation

struct Achievement: Identifiable {

    let id = UUID()
    let title: String
    let icon: String
    let requirement: Int
}
