//
//  Hand.swift
//  HandsignCamera
//
//  Created by 藤井陽介 on 2020/07/20.
//

import Foundation
import Vision

// MARK: - Hand Structure
struct Hand: CustomStringConvertible {
    enum Finger {
        case thumb
        case ringFinger
        case indexFinger
        case middleFinger
        case littleFinger
    }

    enum Position {
        case mcp    // thumb: cmc
        case pip    // thumb: mp
        case dip    // thumb: ip
        case tip
    }

    let thumbPoints: [VNRecognizedPointKey: VNRecognizedPoint]
    let ringFingerPoints: [VNRecognizedPointKey: VNRecognizedPoint]
    let indexFingerPoints: [VNRecognizedPointKey: VNRecognizedPoint]
    let middleFingerPoints: [VNRecognizedPointKey: VNRecognizedPoint]
    let littleFingerPoints: [VNRecognizedPointKey: VNRecognizedPoint]

    var description: String {
        var _description = ""

        _description += "Thumb: CMC (\(thumbCMC?.x ?? -1.0), \(thumbCMC?.y ?? -1.0)) MP (\(thumbMP?.x ?? -1.0), \(thumbMP?.y ?? -1.0))\n"
            + "IP (\(thumbIP?.x ?? -1.0), \(thumbIP?.y ?? -1.0)) TIP (\(thumbTIP?.x ?? -1.0), \(thumbTIP?.y ?? -1.0))\n"
        _description += "Ring: MCP (\(ringMCP?.x ?? -1.0), \(ringMCP?.y ?? -1.0)) PIP (\(ringPIP?.x ?? -1.0), \(ringPIP?.y ?? -1.0))\n"
            + "DIP (\(ringDIP?.x ?? -1.0), \(ringDIP?.y ?? -1.0)) TIP (\(ringTIP?.x ?? -1.0), \(ringTIP?.y ?? -1.0))\n"
        _description += "Index: MCP (\(indexMCP?.x ?? -1.0), \(indexMCP?.y ?? -1.0)) PIP (\(indexPIP?.x ?? -1.0), \(indexPIP?.y ?? -1.0))\n"
            + "DIP (\(indexDIP?.x ?? -1.0), \(indexDIP?.y ?? -1.0)) TIP (\(indexTIP?.x ?? -1.0), \(indexTIP?.y ?? -1.0))\n"
        _description += "Middle: MCP (\(middleMCP?.x ?? -1.0), \(middleMCP?.y ?? -1.0)) PIP (\(middlePIP?.x ?? -1.0), \(middlePIP?.y ?? -1.0))\n"
            + "DIP (\(middleDIP?.x ?? -1.0), \(middleDIP?.y ?? -1.0)) TIP (\(middleTIP?.x ?? -1.0), \(middleTIP?.y ?? -1.0))\n"
        _description += "Little: MCP (\(littleMCP?.x ?? -1.0), \(littleMCP?.y ?? -1.0)) PIP (\(littlePIP?.x ?? -1.0), \(littlePIP?.y ?? -1.0))\n"
            + "DIP (\(littleDIP?.x ?? -1.0), \(littleDIP?.y ?? -1.0)) TIP (\(littleTIP?.x ?? -1.0), \(littleTIP?.y ?? -1.0))\n"

        return _description
    }
}

// MARK: - Computed Property
extension Hand {
    // MARK: Util
    var allPoints: [VNRecognizedPoint?] {
        return [
            thumbCMC, thumbMP, thumbIP, thumbTIP,
            ringMCP, ringPIP, ringDIP, ringTIP,
            indexMCP, indexPIP, indexDIP, indexTIP,
            middleMCP, middlePIP, middleDIP, middleTIP,
            littleMCP, littlePIP, littleDIP, littleTIP,
        ]
    }

    // MARK: Thumb
    var thumbCMC: VNRecognizedPoint? {
        return getPoint(.mcp, of: .thumb)
    }

    var thumbMP: VNRecognizedPoint? {
        return getPoint(.pip, of: .thumb)
    }

    var thumbIP: VNRecognizedPoint? {
        return getPoint(.dip, of: .thumb)
    }

    var thumbTIP: VNRecognizedPoint? {
        return getPoint(.tip, of: .thumb)
    }

    // MARK: Ring
    var ringMCP: VNRecognizedPoint? {
        return getPoint(.mcp, of: .ringFinger)
    }

    var ringPIP: VNRecognizedPoint? {
        return getPoint(.pip, of: .ringFinger)
    }

    var ringDIP: VNRecognizedPoint? {
        return getPoint(.dip, of: .ringFinger)
    }

    var ringTIP: VNRecognizedPoint? {
        return getPoint(.tip, of: .ringFinger)
    }

    // MARK: Index
    var indexMCP: VNRecognizedPoint? {
        return getPoint(.mcp, of: .indexFinger)
    }

    var indexPIP: VNRecognizedPoint? {
        return getPoint(.pip, of: .indexFinger)
    }

    var indexDIP: VNRecognizedPoint? {
        return getPoint(.dip, of: .indexFinger)
    }

    var indexTIP: VNRecognizedPoint? {
        return getPoint(.tip, of: .indexFinger)
    }

    // MARK: Middle
    var middleMCP: VNRecognizedPoint? {
        return getPoint(.mcp, of: .middleFinger)
    }

    var middlePIP: VNRecognizedPoint? {
        return getPoint(.pip, of: .middleFinger)
    }

    var middleDIP: VNRecognizedPoint? {
        return getPoint(.dip, of: .middleFinger)
    }

    var middleTIP: VNRecognizedPoint? {
        return getPoint(.tip, of: .middleFinger)
    }

    // MARK: Little
    var littleMCP: VNRecognizedPoint? {
        return getPoint(.mcp, of: .littleFinger)
    }

    var littlePIP: VNRecognizedPoint? {
        return getPoint(.pip, of: .littleFinger)
    }

    var littleDIP: VNRecognizedPoint? {
        return getPoint(.dip, of: .littleFinger)
    }

    var littleTIP: VNRecognizedPoint? {
        return getPoint(.tip, of: .littleFinger)
    }
}

// MARK: Utility private method
extension Hand {
    private func getPoint(_ position: Position, of finger: Finger) -> Vision.VNRecognizedPoint? {
        let points = getPoints(finger)
        let point: Vision.VNRecognizedPoint?
        switch (position, finger) {
        // Thumb
        case (.mcp, .thumb):
            point = points[.handLandmarkKeyThumbCMC]
        case (.pip, .thumb):
            point = points[.handLandmarkKeyThumbMP]
        case (.dip, .thumb):
            point = points[.handLandmarkKeyThumbIP]
        case (.tip, .thumb):
            point = points[.handLandmarkKeyThumbTIP]
        // Ring Finger
        case (.mcp, .ringFinger):
            point = points[.handLandmarkKeyRingMCP]
        case (.pip, .ringFinger):
            point = points[.handLandmarkKeyRingPIP]
        case (.dip, .ringFinger):
            point = points[.handLandmarkKeyRingDIP]
        case (.tip, .ringFinger):
            point = points[.handLandmarkKeyRingTIP]
        // Index Finger
        case (.mcp, .indexFinger):
            point = points[.handLandmarkKeyIndexMCP]
        case (.pip, .indexFinger):
            point = points[.handLandmarkKeyIndexPIP]
        case (.dip, .indexFinger):
            point = points[.handLandmarkKeyIndexDIP]
        case (.tip, .indexFinger):
            point = points[.handLandmarkKeyIndexTIP]
        // Middle Finger
        case (.mcp, .middleFinger):
            point = points[.handLandmarkKeyMiddleMCP]
        case (.pip, .middleFinger):
            point = points[.handLandmarkKeyMiddlePIP]
        case (.dip, .middleFinger):
            point = points[.handLandmarkKeyMiddleDIP]
        case (.tip, .middleFinger):
            point = points[.handLandmarkKeyMiddleTIP]
        // Little Finger
        case (.mcp, .littleFinger):
            point = points[.handLandmarkKeyLittleMCP]
        case (.pip, .littleFinger):
            point = points[.handLandmarkKeyLittlePIP]
        case (.dip, .littleFinger):
            point = points[.handLandmarkKeyLittleDIP]
        case (.tip, .littleFinger):
            point = points[.handLandmarkKeyLittleTIP]
        }

        if let point = point,
           point.confidence <= 0.3 {
            return nil
        }

        return point
    }

    private func getPoints(_ finger: Finger) -> [Vision.VNRecognizedPointKey: Vision.VNRecognizedPoint] {
        switch finger {
        case .thumb:
            return thumbPoints
        case .ringFinger:
            return ringFingerPoints
        case .indexFinger:
            return indexFingerPoints
        case .middleFinger:
            return middleFingerPoints
        case .littleFinger:
            return littleFingerPoints
        }
    }
}
