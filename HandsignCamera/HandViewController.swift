//
//  HandViewController.swift
//  HandsignCamera
//
//  Created by 藤井陽介 on 2020/07/25.
//

import UIKit
import AVFoundation
import Vision

class HandViewController: UIViewController {

    @IBOutlet private var cameraView: CameraView!
    @IBOutlet private var resultLabel: UILabel!

    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private let pinchMaxDistance: CGFloat = 40
    private var cameraFeedSession: AVCaptureSession?
    private var handPoseRequest = VNDetectHumanHandPoseRequest()

    override func viewDidLoad() {
        super.viewDidLoad()

        handPoseRequest.maximumHandCount = 1
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            if cameraFeedSession == nil {
                cameraView.previewLayer.videoGravity = .resizeAspectFill
                try setupAVSession()
                cameraView.previewLayer.session = cameraFeedSession
            }
            cameraFeedSession?.startRunning()
        } catch {
            AppError.display(error, inViewController: self)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }

    func setupAVSession() throws {
        guard let videoDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else {
            throw AppError.captureSessionSetup(reason: "Could not find a back camera.")
        }

        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw AppError.captureSessionSetup(reason: "Could not create video device input.")
        }

        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high

        guard session.canAddInput(deviceInput) else {
            throw AppError.captureSessionSetup(reason: "Could not add video device input to the session.")
        }
        session.addInput(deviceInput)

        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.captureSessionSetup(reason: "Could not add video data output to the session.")
        }
        session.commitConfiguration()
        cameraFeedSession = session
    }

    private func convertCoordinate(_ point: VNRecognizedPoint) -> CGPoint {
        return CGPoint(x: point.location.x, y: 1 - point.location.y)
    }

    private func recognizeHandSign(_ hand: Hand) {
        guard let thumbPoint = hand.thumbTIP,
              let indexPoint = hand.indexTIP,
              let middlePoint = hand.middleTIP,
              let ringPoint = hand.ringTIP,
              let littlePoint = hand.littleTIP else {
            return
        }

        let previewLayer = cameraView.previewLayer
        let thumbPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: convertCoordinate(thumbPoint))
        let indexPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: convertCoordinate(indexPoint))
        let middlePointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: convertCoordinate(middlePoint))
        let ringPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: convertCoordinate(ringPoint))
        let littlePointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: convertCoordinate(littlePoint))

        let thumbIndexDist = thumbPointConverted.distance(from: indexPointConverted)
        let indexMiddleDist = indexPointConverted.distance(from: middlePointConverted)
        let middleRingDist = middlePointConverted.distance(from: ringPointConverted)
        let ringLittleDist = ringPointConverted.distance(from: littlePointConverted)

        let distArray = [thumbIndexDist, indexMiddleDist, middleRingDist, ringLittleDist]

        if distArray.filter({ $0 < pinchMaxDistance }).count == 4 {
            resultLabel.text = "Type 4: グー"
        } else if distArray.filter({ $0 >= pinchMaxDistance }).count == 4 {
            resultLabel.text = "Type 3: パー"
        } else if thumbIndexDist < pinchMaxDistance && distArray.filter({ $0 < pinchMaxDistance }).count == 1 {
            resultLabel.text = "Type 2: オーケー"
        } else if thumbIndexDist >= pinchMaxDistance && indexMiddleDist >= pinchMaxDistance && distArray.filter({ $0 >= pinchMaxDistance }).count == 2 {
            resultLabel.text = "Type 1: 銃"
        } else {
            resultLabel.text = "Unknown"
        }
    }
}


extension HandViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])

        do {
            try handler.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first as? VNRecognizedPointsObservation else {
                return
            }

            let thumbPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyThumb)
            let ringFingerPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyRingFinger)
            let indexFingerPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyIndexFinger)
            let middleFingerPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyMiddleFinger)
            let littleFingerPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyLittleFinger)

            let hand = Hand(thumbPoints: thumbPoints, ringFingerPoints: ringFingerPoints, indexFingerPoints: indexFingerPoints, middleFingerPoints: middleFingerPoints, littleFingerPoints: littleFingerPoints)
            DispatchQueue.main.async { [self] in
                recognizeHandSign(hand)
            }
        } catch {
            cameraFeedSession?.stopRunning()
            let error = AppError.visionError(error: error)
            DispatchQueue.main.async {
                error.displayInViewController(self)
            }
        }
    }
}

extension CGPoint {
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
}
