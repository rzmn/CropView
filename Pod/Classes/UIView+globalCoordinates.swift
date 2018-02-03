//
//  UIView+globalCoordinates.swift
//  CropView
//
//  Created by Никита Разумный on 2/3/18.
//

import UIKit

extension UIView {
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}
