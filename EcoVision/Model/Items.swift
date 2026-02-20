//
//  Items.swift
//  EcoVision
//
//  Production-ready eco intelligence database
//

import Foundation

struct Items: Identifiable, Codable, Hashable {

    // MARK: Identity
    let id: UUID

    // MARK: CoreML label (must match model output)
    let label: String

    // MARK: Display info
    let title: String
    let icon: String

    // MARK: Environmental data
    let carbonFootprint: Double   // kg CO₂e
    let decompositionTime: String
    let recyclable: Bool

    // MARK: Guidance
    let disposalMethod: String
    let suggestion: String
    let impactExplanation: String

    // MARK: Init
    init(
        label: String,
        title: String,
        icon: String,
        carbonFootprint: Double,
        decompositionTime: String,
        recyclable: Bool,
        disposalMethod: String,
        suggestion: String,
        impactExplanation: String
    ) {
        self.id = UUID()
        self.label = label
        self.title = title
        self.icon = icon
        self.carbonFootprint = carbonFootprint
        self.decompositionTime = decompositionTime
        self.recyclable = recyclable
        self.disposalMethod = disposalMethod
        self.suggestion = suggestion
        self.impactExplanation = impactExplanation
    }

    // MARK: Computed helpers

    /// Formatted carbon footprint string
    var carbonFootprintFormatted: String {
        String(format: "%.2f kg CO₂e", carbonFootprint)
    }

    /// Recyclable text
    var recyclableText: String {
        recyclable ? "Recyclable" : "Not Recyclable"
    }

    /// Recyclable icon
    var recyclableIcon: String {
        recyclable ? "checkmark.circle.fill" : "xmark.circle.fill"
    }

    /// Recyclable color
    var recyclableColorName: String {
        recyclable ? "green" : "red"
    }

    // MARK: Database

    static let all: [Items] = [

        Items(
            label: "Plastic",
            title: "Plastic Waste",
            icon: "waterbottle",
            carbonFootprint: 0.15,
            decompositionTime: "450 years",
            recyclable: true,
            disposalMethod: "Dispose in plastic recycling bin",
            suggestion: "Use reusable bottles or cloth bags instead.",
            impactExplanation: "Plastic persists for centuries and harms marine ecosystems."
        ),

        Items(
            label: "Paper",
            title: "Paper Waste",
            icon: "doc.fill",
            carbonFootprint: 0.04,
            decompositionTime: "2–6 weeks",
            recyclable: true,
            disposalMethod: "Place in paper recycling bin",
            suggestion: "Switch to digital alternatives whenever possible.",
            impactExplanation: "Recycling paper saves trees and reduces landfill burden."
        ),

        Items(
            label: "Glass",
            title: "Glass Waste",
            icon: "wineglass.fill",
            carbonFootprint: 0.17,
            decompositionTime: "1 million years",
            recyclable: true,
            disposalMethod: "Dispose in glass recycling container",
            suggestion: "Reuse jars and containers before recycling.",
            impactExplanation: "Glass is infinitely recyclable and saves energy when reused."
        ),

        Items(
            label: "Metallic_Materials",
            title: "Metal Waste",
            icon: "cylinder.fill",
            carbonFootprint: 1.50,
            decompositionTime: "50–500 years",
            recyclable: true,
            disposalMethod: "Place in metal recycling bin",
            suggestion: "Recycle cans and metal containers.",
            impactExplanation: "Recycling metal reduces mining and saves significant energy."
        ),

        Items(
            label: "Organic_Vegetation_Waste",
            title: "Organic Waste",
            icon: "leaf.fill",
            carbonFootprint: 0.02,
            decompositionTime: "2–8 weeks",
            recyclable: true,
            disposalMethod: "Place in compost bin",
            suggestion: "Compost organic waste to enrich soil.",
            impactExplanation: "Organic waste can be converted into nutrient-rich compost."
        ),

        Items(
            label: "Food_Scraps",
            title: "Food Waste",
            icon: "fork.knife",
            carbonFootprint: 0.08,
            decompositionTime: "1–6 months",
            recyclable: true,
            disposalMethod: "Use composting system",
            suggestion: "Reduce food waste and compost leftovers.",
            impactExplanation: "Food waste in landfills releases methane, a potent greenhouse gas."
        ),

        Items(
            label: "Electronic_Waste",
            title: "Electronic Waste",
            icon: "desktopcomputer",
            carbonFootprint: 1.20,
            decompositionTime: "Thousands of years",
            recyclable: false,
            disposalMethod: "Dispose at certified e-waste facility",
            suggestion: "Return electronics to certified recycling centers.",
            impactExplanation: "E-waste contains toxic chemicals harmful to humans and environment."
        ),

        Items(
            label: "Textile",
            title: "Textile Waste",
            icon: "tshirt.fill",
            carbonFootprint: 0.60,
            decompositionTime: "1–5 years",
            recyclable: true,
            disposalMethod: "Donate or recycle textiles",
            suggestion: "Donate clothes or reuse creatively.",
            impactExplanation: "Textile waste contributes heavily to landfill pollution."
        )
    ]

    // MARK: Lookup

    static func forLabel(_ label: String) -> Items? {

        let normalized = label
            .replacingOccurrences(of: "_", with: " ")
            .lowercased()

        return all.first {
            $0.label
                .replacingOccurrences(of: "_", with: " ")
                .lowercased() == normalized
        }
    }

    // MARK: Safe fallback

    static let unknown = Items(
        label: "Unknown",
        title: "Unknown Waste",
        icon: "questionmark.circle",
        carbonFootprint: 0,
        decompositionTime: "Unknown",
        recyclable: false,
        disposalMethod: "Consult local waste authority",
        suggestion: "Try scanning again with better lighting.",
        impactExplanation: "Unable to determine environmental impact."
    )
}

