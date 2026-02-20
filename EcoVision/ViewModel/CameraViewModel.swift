//
//  CameraViewModel.swift
//  EcoVision
//
//  WWDC-level production ready version
//

import UIKit
import AVFoundation
import Combine
import Vision
import CoreML

@MainActor
final class CameraViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var result: DetectionResult?
    @Published var isShowingResult: Bool = false

    // MARK: - Private Properties

    private let classifier = WasteClassifierService()

    private var visionModel: VNCoreMLModel?
    private var visionRequest: VNCoreMLRequest?

    // Duplicate prevention
    private var lastSavedLabel: String?
    private var lastSaveTime: Date?

    private let saveCooldown: TimeInterval = 2.0


    // MARK: - Init

    init() {
        setupVision()
    }


    // MARK: - Image Classification (Gallery / Scan Camera)

    func classifyImage(_ image: UIImage) {

        guard let pixelBuffer = image.toPixelBuffer() else {
            print("❌ Failed to convert UIImage to pixelBuffer")
            return
        }

        classifier.classify(pixelBuffer: pixelBuffer) { [weak self] result in

            guard let self = self,
                  let result = result else { return }

            Task { @MainActor in

                self.result = result
                self.isShowingResult = true

                self.saveScanIfNeeded(result)
            }
        }
    }


    // MARK: - Setup Vision Model (Live Detection)

    private func setupVision() {

        guard let coreMLModel = try? VNCoreMLModel(
            for: EcoVisionWasteClassifier().model
        ) else {
            print("❌ Failed to load CoreML model")
            return
        }

        visionModel = coreMLModel

        visionRequest = VNCoreMLRequest(
            model: coreMLModel
        ) { [weak self] request, error in

            guard let self = self else { return }

            if let error = error {
                print("❌ Vision error:", error)
                return
            }

            guard let results = request.results as? [VNClassificationObservation],
                  let top = results.first else { return }

            let detection = DetectionResult(
                label: top.identifier,
                confidence: top.confidence
            )

            Task { @MainActor in

                self.result = detection

                // DO NOT auto navigate in live mode
                self.saveScanIfNeeded(detection)
            }
        }

        visionRequest?.imageCropAndScaleOption = .centerCrop
    }


    // MARK: - Process Live Camera Frame

    func processLiveFrame(_ pixelBuffer: CVPixelBuffer) {

        guard let request = visionRequest else { return }

        let handler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: .up
        )

        do {
            try handler.perform([request])
        }
        catch {
            print("❌ Live detection failed:", error)
        }
    }


    // MARK: - Save Scan History (CORE FIX)

    private func saveScanIfNeeded(_ detection: DetectionResult) {

        // Ignore weak detections
        guard detection.confidence > 0.60 else { return }

        let now = Date()

        // Prevent duplicate saves
        if detection.label == lastSavedLabel,
           let lastSaveTime,
           now.timeIntervalSince(lastSaveTime) < saveCooldown {
            return
        }

        lastSavedLabel = detection.label
        lastSaveTime = now

        // Get environmental data
        guard let item = Items.forLabel(detection.label) else {
            print("⚠️ Item not found in database:", detection.label)
            return
        }

        // CREATE SCAN RECORD (FIXED)
        let record = ScanRecord(
            label: detection.label,
            confidence: Double(detection.confidence),
            carbonFootprint: item.carbonFootprint,
            date: now
        )

        // SAVE TO HISTORY
        HistoryManager.shared.save(record: record)

        print("✅ Scan saved:", detection.label)
    }


    // MARK: - Reset duplicate guard

    func resetSaveGuard() {

        lastSavedLabel = nil
        lastSaveTime = nil
    }
}

