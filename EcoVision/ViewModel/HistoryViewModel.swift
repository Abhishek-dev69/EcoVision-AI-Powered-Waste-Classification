//
//  HistoryViewModel.swift
//  EcoVision
//

import Foundation
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {

    @Published var records: [ScanRecord] = []

    // MARK: Load history

    func load() {

        records = HistoryManager.shared.fetch()
    }

    // MARK: Clear history

    func clear() {

        HistoryManager.shared.clear()

        load()
    }
}

