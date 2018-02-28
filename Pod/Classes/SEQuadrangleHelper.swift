//
//  SEQuadrangleHelper.swift
//  CropView
//
//  Created by Никита Разумный on 2/3/18.
//

import UIKit
import Foundation
import AVFoundation

public class SEQuadrangleHelper {
    
    static internal func orderPointsInQuadrangle(quad: [CGPoint]) throws -> [CGPoint] {
        func orderArrayClockwise(quad: [CGPoint]) -> [CGPoint] {
            // oriented area of quadrangle: cloclwise if it > 0
            var square : CGFloat = 0.0
            for i in 0 ..< quad.count - 1 {
                square += CGPoint.cross(a: CGPoint(x: quad[i].x - quad[0].x, y: quad[i].y - quad[0].y),
                                        b: CGPoint(x: quad[i + 1].x - quad[0].x, y: quad[i + 1].y - quad[0].y))
            }
            return square > 0 ? quad : quad.reversed()
        }
        
        func findTopLeftPointIndex(quad: [CGPoint]) throws -> Int {
            var topLeftPointIdx : Int = -1
            var topLeftShiftValue : CGFloat = 1000.0 * 1000.0 * 1000.0
            
            for i in 0 ..< quad.count {
                let shiftValue = quad[i].y + quad[i].x
                if shiftValue < topLeftShiftValue {
                    topLeftPointIdx = i
                    topLeftShiftValue = shiftValue
                }
            }
            guard topLeftPointIdx != -1 else { throw SECropError.unknown }
            return topLeftPointIdx
        }
        
        guard quad.count == 4 else { throw SECropError.invalidNumberOfCorners }
        guard checkConvex(corners: quad) else { throw SECropError.nonConvexRect }
        
        let orderedQuad = orderArrayClockwise(quad: quad)
        let topLeftIdx = try findTopLeftPointIndex(quad: orderedQuad)
        return orderedQuad.shifted(by: orderedQuad.count - topLeftIdx)
    }
    
    static public func cropImage(with image: UIImage, quad: [CGPoint]) throws -> UIImage {
        
        let ciImage = CIImage(image: image)
        
        let perspectiveCorrection = CIFilter(name: "CIPerspectiveCorrection")
        let imgSize = CGSize(width: image.size.width * image.scale,
                             height: image.size.height * image.scale)
        
        let orderedQuad = try orderPointsInQuadrangle(quad: quad)
        let context = CIContext(options: nil)
        print("ordered quad: ", orderedQuad)
        
        guard let transform = perspectiveCorrection else { throw SECropError.unknown }
        transform.setValue(CIVector(cgPoint: orderedQuad[0].cartesian(for: imgSize)),
                           forKey: "inputTopLeft")
        transform.setValue(CIVector(cgPoint: orderedQuad[1].cartesian(for: imgSize)),
                           forKey: "inputTopRight")
        transform.setValue(CIVector(cgPoint: orderedQuad[2].cartesian(for: imgSize)),
                           forKey: "inputBottomRight")
        transform.setValue(CIVector(cgPoint: orderedQuad[3].cartesian(for: imgSize)),
                           forKey: "inputBottomLeft")
        transform.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let perspectiveCorrectedImg = transform.outputImage, let cgImage = context.createCGImage(perspectiveCorrectedImg, from: perspectiveCorrectedImg.extent) else { throw SECropError.unknown }
        
        return UIImage(cgImage: cgImage)
    }

    static internal func checkConvex(corners: [CGPoint]) -> Bool {
        guard corners.count > 2 else {
            return false
        }
        var positiveCount = 0
        var negativeCount = 0
        for i in 0 ..< corners.count {
            let p0 = corners[i]
            let p1 = corners[(i + 1) % corners.count]
            let p2 = corners[(i + 2) % corners.count]
            
            let cross = (p1.x - p0.x) * (p2.y - p1.y) - (p1.y - p0.y) * (p2.x - p1.x);
            if cross > 0 {
                positiveCount += 1
            } else if cross < 0 {
                negativeCount += 1
            }
        }
        return positiveCount == corners.count || negativeCount == corners.count
    }
}
