//
//  AreaView.swift
//  CropViewController
//
//  Created by Никита Разумный on 11/5/17.
//  Copyright © 2017 resquare. All rights reserved.
//

import UIKit

class SEAreaView: UIView {

    var path = CGMutablePath()
    var isPathValid = true
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.clip(to: rect)

        context?.addPath(path)
        context?.setLineWidth(1)
        context?.setLineCap(.round)
        context?.setLineJoin(.round)

        context?.setStrokeColor((isPathValid ? SECropView.goodAreaColor : SECropView.badAreaColor).cgColor)

        context?.strokePath()
    }

}
