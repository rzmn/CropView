//
//  ImageViewController.swift
//  Example
//
//  Created by Никита Разумный on 2/3/18.
//  Copyright © 2018 example. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
