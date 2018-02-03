//
//  CropView.swift
//  CropViewController
//
//  Created by Никита Разумный on 11/5/17.
//  Copyright © 2017 resquare. All rights reserved.
//

import UIKit

extension CGPoint {
    func normalized(size: CGSize) -> CGPoint {
        return CGPoint(x: max(min(x, size.width), 0), y: max(min(y, size.height), 0))
    }
}

public class SECropView: UIView {
    static var goodAreaColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    static var badAreaColor  = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

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
        clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		backgroundColor = UIColor.clear
        clipsToBounds = true
    }
    
    public func configureWithCorners(corners : Array<CGPoint>) {
        
        
        self.corners = []
        for subview in subviews {
            if subview is SECornerView {
                subview.removeFromSuperview()
            }
        }
        
        for point in corners {
            let pointToAdd = point.normalized(size: bounds.size)
            let cornerToAdd = SECornerView(frame: CGRect(x: pointToAdd.x - SECornerView.cornerSize / 2.0,
                                                         y: pointToAdd.y - SECornerView.cornerSize / 2.0,
                                                         width: SECornerView.cornerSize,
                                                         height: SECornerView.cornerSize))
            addSubview(cornerToAdd)
            self.corners.append(cornerToAdd)
        }
        areaQuadrangle.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        areaQuadrangle.frame = bounds
        areaQuadrangle.backgroundColor = .clear
        areaQuadrangle.path = getPath()
        areaQuadrangle.isPathValid = SEQuadrangleHelper.checkConvex(corners: self.corners.map{ $0.center })
        addSubview(areaQuadrangle)
        for corner in self.corners {
            corner.layer.borderColor = (areaQuadrangle.isPathValid ? SECropView.goodAreaColor : SECropView.badAreaColor ).cgColor
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        areaQuadrangle.frame = bounds
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
        areaQuadrangle.isPathValid = SEQuadrangleHelper.checkConvex(corners: self.corners.map{ $0.center })
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
        
        let newCenter = CGPoint(x: corners[cornerOnTouch].center.x + derivative.x, y: corners[cornerOnTouch].center.y + derivative.y)
        
        corners[cornerOnTouch].center = newCenter.normalized(size: bounds.size)
        
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
        
        guard let firstPt = corners.first else { return CGMutablePath() }
        
        let initPt = CGPoint(x: firstPt.center.x - areaQuadrangle.frame.origin.x,
                             y: firstPt.center.y - areaQuadrangle.frame.origin.y)
        path.move(to: initPt)
        
        for i in 0 ..< corners.count - 1 {
            let pt = CGPoint(x: corners[(i + 1) % corners.count].center.x - areaQuadrangle.frame.origin.x,
                             y: corners[(i + 1) % corners.count].center.y - areaQuadrangle.frame.origin.y)
            path.addLine(to: pt)
            
        }
        path.closeSubpath()
        
        return path
    }

}
