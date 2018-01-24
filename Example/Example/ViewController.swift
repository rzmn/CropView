//
//  ViewController.swift
//  Example
//
//  Created by Никита Разумный on 11/6/17.
//  Copyright © 2017 example. All rights reserved.
//

import UIKit
import CropView

class ViewController: UIViewController {

    @IBOutlet weak var cropView: SECropView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cropView.configureWithCorners(corners: [CGPoint(x: 100, y: 120),
                                                CGPoint(x: 270, y: 170),
                                                CGPoint(x: 280, y: 450),
                                                CGPoint(x: 120, y: 400)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

