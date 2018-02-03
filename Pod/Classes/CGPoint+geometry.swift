//
//  CGPoint+geometry.swift
//  CropView
//
//  Created by Никита Разумный on 2/3/18.
//

import UIKit

extension CGPoint {
    func cartesian(for size: CGSize) -> CGPoint {
        return CGPoint(x: x, y: size.height - y)
    }
    static func cross(a: CGPoint, b: CGPoint) -> CGFloat {
        return a.x * b.y - a.y * b.x
    }
}
