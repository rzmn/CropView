//
//  CornerView.swift
//  CropViewController
//
//  Created by Никита Разумный on 11/5/17.
//  Copyright © 2017 resquare. All rights reserved.
//

import UIKit

class SECornerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.size.width / 2.0
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let position = superview!.convert(self.frame, to: nil)
        let touchPoint = position.origin

        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: -(position.size.width / 2 - SECropView.cornerSize / 2),
                            y: -(position.size.width / 2 - SECropView.cornerSize / 2))

        context.translateBy(x: -touchPoint.x,
                            y: -touchPoint.y)

        /* TODO: faster rendering
        isHidden = true
        (superview as! SECropView).areaQuadrangle.isHidden = true
        self.superview?.superview?.superview?.layer.render(in: context)
        (superview as! SECropView).areaQuadrangle.isHidden = false
        isHidden = false
         */
    }
    
    func scaleUp() {
        UIView.animate(withDuration: 0.15, animations: {
            self.layer.borderWidth = 0.5
            self.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
        }) { (_) in
            self.setNeedsDisplay()
        }
    }
    
    func scaleDown() {
        UIView.animate(withDuration: 0.15, animations: {
            self.layer.borderWidth = 1
            self.transform = CGAffineTransform.identity
        }) { (_) in
            self.setNeedsDisplay()
        }
    }
}
