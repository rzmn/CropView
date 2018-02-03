//
//  SECropError.swift
//  CropView
//
//  Created by Никита Разумный on 2/3/18.
//

import UIKit

public enum SECropError: Error {
    case missingSuperview
    case missingImageOnImageView
    case invalidNumberOfCorners
    case nonConvexRect
    case missingImageWhileCropping
    case unknown
}
