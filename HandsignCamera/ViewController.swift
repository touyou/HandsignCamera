////
////  ViewController.swift
////  HandsignCamera
////
////  Created by 藤井陽介 on 2020/07/20.
////
//
//import UIKit
//import RealityKit
//import ARKit
//import Vision
//
//class ViewController: UIViewController {
//
//    @IBOutlet var arView: ARView!
//
//    private var handPoseRequest = VNDetectHumanHandPoseRequest()
//
////    private let mlDispatchQueue = DispatchQueue(label: "dev.touyou.HandsignCamera.mlQueue")
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        arView.session.delegate = self
//
//        guard ARBodyTrackingConfiguration.isSupported else {
//            fatalError()
//        }
//
//        let configuration = ARBodyTrackingConfiguration()
//        configuration.frameSemantics.insert(.bodyDetection)
//        arView.session.run(configuration)
//
//        handPoseRequest.maximumHandCount = 1
//
////        loopMLUpdate()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        arView.session.pause()
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
////    private func addHandBubble(_ hand: Hand) {
////        DispatchQueue.main.async { [self] in
////            // 一旦消す
////            sceneView.scene.rootNode.childNodes.forEach {
////                $0.removeFromParentNode()
////            }
////            // 座標変換用
////            let infrontOfCamera = SCNVector3(0, 0, -0.3)
////            guard let cameraNode = sceneView.pointOfView else { return }
////            let pointInWorld = cameraNode.convertPosition(infrontOfCamera, to: nil)
////            var screenPos = sceneView.projectPoint(pointInWorld)
////
////            hand.allPoints.forEach { point in
////                guard let point = point else { return }
////                screenPos.x = Float(point.x)
////                screenPos.y = Float(point.y)
////
////                let finalPosition = sceneView.unprojectPoint(screenPos)
////
////                let sphere = SCNSphere(radius: 0.005)
////                sphere.firstMaterial?.diffuse.contents = UIColor.cyan
////                let sphereNode = SCNNode(geometry: sphere)
////                sphereNode.position = finalPosition
////                sceneView.scene.rootNode.addChildNode(sphereNode)
////            }
////        }
////    }
//
//    private func loopMLUpdate() {
////        mlDispatchQueue.async { [self] in
////            updateHandPose()
////        }
//    }
//
//    private func updateHandPose() {
////        guard let pixbuff = sceneView.session.currentFrame?.capturedImage else {
////            return
////        }
////
////        defer {
////            loopMLUpdate()
////        }
////
////        let handler = VNImageRequestHandler(cvPixelBuffer: pixbuff, orientation: .up, options: [:])
////
////        do {
////            try handler.perform([handPoseRequest])
////
////            guard let observation = handPoseRequest.results?.first as? VNRecognizedPointsObservation else {
////                return
////            }
////
////            let thumbPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyThumb)
////            let ringFingerPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyRingFinger)
////            let indexFingerPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyIndexFinger)
////            let middleFingerPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyMiddleFinger)
////            let littleFingerPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyLittleFinger)
////            print(thumbPoints)
////
//////            let hand = Hand(thumbPoints: thumbPoints, ringFingerPoints: ringFingerPoints, indexFingerPoints: indexFingerPoints, middleFingerPoints: middleFingerPoints, littleFingerPoints: littleFingerPoints)
//////            addHandBubble(hand)
////
////            loopMLUpdate()
////        } catch {
////            sceneView.session.pause()
////            let error = AppError.visionError(error: error)
////            DispatchQueue.main.async {
////                error.displayInViewController(self)
////            }
////        }
//    }
//}
//
//extension ViewController: ARSessionDelegate {
//
//    // MARK: - ARSessionDelegate
//
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        let pixbuff = frame.capturedImage
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixbuff, orientation: .up, options: [:])
//        do {
//            try handler.perform([handPoseRequest])
//
//            guard let observation = handPoseRequest.results?.first as? VNRecognizedPointsObservation else {
//                return
//            }
//
//            print(observation)
//            print(VNRecognizedPointGroupKey.all)
//
////            let thumbPoints = try observation.recognizedPoints(forGroupKey: .handLandmarkRegionKeyThumb)
////            print(thumbPoints)
//        } catch {
//            arView.session.pause()
//            let error = AppError.visionError(error: error)
//            DispatchQueue.main.async {
//                error.displayInViewController(self)
//            }
//        }
//    }
//}
