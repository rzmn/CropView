//
//  AreaView.swift
//  CropViewController
//
//  Created by Никита Разумный on 11/5/17.
//  Copyright © 2017 resquare. All rights reserved.
//

import UIKit

class SEAreaView: UIView {

    var cropView : SECropView?
    var isPathValid = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentMode = .redraw
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.commit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let path = cropView?.path else { return }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.clip(to: rect)

        context?.addPath(path)
        context?.setLineWidth(1)
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        
        
        context?.setStrokeColor((isPathValid ? SECropView.goodAreaColor : SECropView.badAreaColor).cgColor)
        context?.strokePath()
        
        context?.saveGState()
        context?.addRect(bounds)
        context?.addPath(path)
        
        context?.setFillColor(UIColor(white: 0.3, alpha: 0.2).cgColor)
        context?.drawPath(using: .eoFill)
        
        context?.restoreGState()
    }
}
