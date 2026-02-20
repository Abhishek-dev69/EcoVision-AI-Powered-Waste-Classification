//
//  LocalStorage.swift
//  EcoVision
//
//  Production-ready scan history storage
//

import Foundation

final class LocalStorage {

    // MARK: Singleton

    static let shared = LocalStorage()

    private init() {}

    // MARK: Storage Key

    private let historyKey = "eco_scan_history_v1"

    // Optional: Limit history to prevent unlimited growth
    private let maxHistoryCount = 500

    // MARK: Save Record

    func save(record: ScanRecord) {

        var history = loadHistory()

        history.append(record)

        // Limit history size (WWDC-level optimization)
        if history.count > maxHistoryCount {
            history.removeFirst(history.count - maxHistoryCount)
        }

        do {
            let encoded = try JSONEncoder().encode(history)
            UserDefaults.standard.set(encoded, forKey: historyKey)
        } catch {
            print("❌ Failed to save scan record:", error)
        }
    }

    // MARK: Load History

    func loadHistory() -> [ScanRecord] {

        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            return []
        }

        do {
            let decoded = try JSONDecoder().decode([ScanRecord].self, from: data)
            return decoded
        } catch {
            print("❌ Failed to load scan history:", error)
            return []
        }
    }

    // MARK: Clear History

    func clearHistory() {

        UserDefaults.standard.removeObject(forKey: historyKey)

        print("🧹 Scan history cleared")
    }

    // MARK: Delete specific record

    func delete(record: ScanRecord) {

        var history = loadHistory()

        history.removeAll { $0.id == record.id }

        do {
            let encoded = try JSONEncoder().encode(history)
            UserDefaults.standard.set(encoded, forKey: historyKey)
        } catch {
            print("❌ Failed to delete record:", error)
        }
    }
}

