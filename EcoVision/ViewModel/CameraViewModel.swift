import UIKit
import AVFoundation
import Combine
import Vision
import CoreML

final class CameraViewModel: ObservableObject {

    @Published var result: DetectionResult?
    @Published var isShowingResult = false

    private let classifier = WasteClassifierService()

    private var visionModel: VNCoreMLModel?
    private var visionRequest: VNCoreMLRequest?

    init() {
        setupVision()
    }

    // Existing function (KEEP)
    func classifyImage(_ image: UIImage) {

        guard let pixelBuffer = image.toPixelBuffer() else { return }

        classifier.classify(pixelBuffer: pixelBuffer) { [weak self] result in

            DispatchQueue.main.async {
                self?.result = result
                self?.isShowingResult = result != nil
            }
        }
    }

    // NEW: Setup Vision
    private func setupVision() {

        guard let coreMLModel = try? VNCoreMLModel(
            for: EcoVisionWasteClassifier().model
        ) else {
            return
        }

        visionModel = coreMLModel

        visionRequest = VNCoreMLRequest(model: coreMLModel) { [weak self] request, error in

            guard let results = request.results as? [VNClassificationObservation],
                  let top = results.first else { return }

            DispatchQueue.main.async {

                let detection = DetectionResult(
                    label: top.identifier,
                    confidence: top.confidence
                )

                self?.result = detection
                self?.isShowingResult = true
            }
        }

        visionRequest?.imageCropAndScaleOption = .centerCrop
    }

    // NEW: Live detection
    func processLiveFrame(_ pixelBuffer: CVPixelBuffer) {

        guard let request = visionRequest else { return }

        let handler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: .up
        )

        try? handler.perform([request])
    }
}

