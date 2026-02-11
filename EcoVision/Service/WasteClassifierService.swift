//
//  WasteClassifierService.swift
//  EcoVision
//
//  Created by Abhishek on 12/02/26.
//

import Vision
import CoreML
import UIKit

final class WasteClassifierService {

    private let model: VNCoreMLModel

    init() {
        let config = MLModelConfiguration()
        let mlModel = try! EcoVisionWasteClassifier(configuration: config).model
        self.model = try! VNCoreMLModel(for: mlModel)
    }

    func classify(
        pixelBuffer: CVPixelBuffer,
        completion: @escaping (DetectionResult?) -> Void
    ) {
        let request = VNCoreMLRequest(model: model) { request, _ in
            guard
                let results = request.results as? [VNClassificationObservation],
                let best = results.first
            else {
                completion(nil)
                return
            }

            let confidenceThreshold: Float = 0.6

            guard best.confidence >= confidenceThreshold else {
                completion(
                    DetectionResult(
                        label: "Unknown",
                        confidence: best.confidence
                    )
                )
                return
            }

            completion(
                DetectionResult(
                    label: best.identifier,
                    confidence: best.confidence
                )
            )
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
}
