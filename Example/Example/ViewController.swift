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
        view.image = #imageLiteral(resourceName: "note.jpg")
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
        cropView.configureWithCorners(corners: [CGPoint(x: 10, y: 10),
                                                CGPoint(x: 10, y: 100),
                                                CGPoint(x: 150, y: 150),
                                                CGPoint(x: 100, y: 10)])
        view.addSubview(imageView)
        imageView.addSubview(cropView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

