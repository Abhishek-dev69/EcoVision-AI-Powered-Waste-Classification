import Foundation

struct ScanRecord: Identifiable, Codable {

    let id: UUID
    let label: String
    let confidence: Double
    let carbonFootprint: Double
    let date: Date

    init(
        id: UUID = UUID(),
        label: String,
        confidence: Double,
        carbonFootprint: Double,
        date: Date
    ) {
        self.id = id
        self.label = label
        self.confidence = confidence
        self.carbonFootprint = carbonFootprint
        self.date = date
    }
}

