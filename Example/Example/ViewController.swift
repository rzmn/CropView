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

    let cropView = SECropView()
    let imageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.image = #imageLiteral(resourceName: "paper.jpg")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageView.frame = view.frame
        cropView.frame = view.frame
        cropView.configureWithCorners(corners: [CGPoint(x: 100, y: 120),
                                                CGPoint(x: 270, y: 170),
                                                CGPoint(x: 280, y: 450),
                                                CGPoint(x: 120, y: 400)])
        view.addSubview(imageView)
        imageView.addSubview(cropView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

