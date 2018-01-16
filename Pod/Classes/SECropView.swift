//
//  CropView.swift
//  CropViewController
//
//  Created by Никита Разумный on 11/5/17.
//  Copyright © 2017 resquare. All rights reserved.
//

import UIKit

public class SECropView: UIView {
    static let goodAreaColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    static let badAreaColor  = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

    var areaQuadrangle = SEAreaView()
    
    fileprivate var corners = Array<SECornerView>()
    fileprivate var cornerOnTouch = -1

	var isPathvalid: Bool {
		return areaQuadrangle.isPathValid
	}

	public var cornerLocations: [CGPoint] {
		return corners.flatMap { $0.center }
	}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		backgroundColor = UIColor.clear
    }
    
    public func configureWithCorners(corners : Array<CGPoint>) {
        
        
        self.corners = []
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        for point in corners {
            let cornerToAdd = SECornerView(frame: CGRect(x: point.x - SECornerView.cornerSize / 2.0,
                                                         y: point.y - SECornerView.cornerSize / 2.0,
                                                         width: SECornerView.cornerSize,
                                                         height: SECornerView.cornerSize))
            addSubview(cornerToAdd)
            self.corners.append(cornerToAdd)
        }
        areaQuadrangle.frame = frame
        areaQuadrangle.backgroundColor = .clear
        areaQuadrangle.path = getPath()
        areaQuadrangle.isPathValid = checkConvex()
        addSubview(areaQuadrangle)
        for corner in self.corners {
            corner.layer.borderColor = (areaQuadrangle.isPathValid ? SECropView.goodAreaColor : SECropView.badAreaColor ).cgColor
        }
    }
    
    fileprivate func update(scale : Int) {
        guard cornerOnTouch != -1 else { return }
        
        switch scale {
        case +1:
            corners[cornerOnTouch].scaleUp()
            bringSubview(toFront: corners[cornerOnTouch])
            bringSubview(toFront: areaQuadrangle)
        case -1:
            corners[cornerOnTouch].scaleDown()
        default: break
            
        }
        corners[cornerOnTouch].setNeedsDisplay()
        areaQuadrangle.path = getPath()
        areaQuadrangle.isPathValid = checkConvex()
        areaQuadrangle.setNeedsDisplay()
        for corner in corners {
            corner.layer.borderColor = (areaQuadrangle.isPathValid ? SECropView.goodAreaColor : SECropView.badAreaColor ).cgColor
        }
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard touches.count == 1 && corners.count > 2 else {
            return
        }
        let point = touches.first!.location(in: self)
        
        var bestDistance : CGFloat = 1000.0 * 1000.0 * 1000.0
        
        for i in 0 ..< corners.count {
            let tmpPoint = corners[i].center
            let distance : CGFloat =
                (point.x - tmpPoint.x) * (point.x - tmpPoint.x) +
                (point.y - tmpPoint.y) * (point.y - tmpPoint.y)
            if distance < bestDistance {
                bestDistance = distance
                cornerOnTouch = i
            }
        }
        update(scale: +1)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard cornerOnTouch != -1 && touches.count == 1 else {
            return
        }
        
        let from = touches.first!.previousLocation(in: self)
        let to = touches.first!.location(in: self)
        
        let derivative = CGPoint(x: to.x - from.x, y: to.y - from.y)
        
        corners[cornerOnTouch].center = CGPoint(x: corners[cornerOnTouch].center.x + derivative.x, y: corners[cornerOnTouch].center.y + derivative.y)
        
        update(scale: 0)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard cornerOnTouch != -1 && touches.count == 1 else {
            return
        }
        update(scale: -1)
        cornerOnTouch = -1
    }
    
    fileprivate func getPath() -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: (corners.first?.center)!)
        
        for i in 0 ..< corners.count - 1 {
            path.addLine(to: corners[(i + 1) % corners.count].center)
            
        }
        path.closeSubpath()
        
        return path
    }
    
    fileprivate func checkConvex() -> Bool {
        guard corners.count > 2 else {
            return false
        }
        var positiveCount = 0
        var negativeCount = 0
        for i in 0 ..< corners.count {
            let p0 = corners[i].center
            let p1 = corners[(i + 1) % corners.count].center
            let p2 = corners[(i + 2) % corners.count].center
            
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
