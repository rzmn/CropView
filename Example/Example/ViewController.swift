//
//  ViewController.swift
//  Example
//
//  Created by Никита Разумный on 11/6/17.
//  Copyright © 2017 example. All rights reserved.
//

import UIKit
import CropView
import AVFoundation

class ViewController: UIViewController {

    let cropView = SECropView()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // points are defined in the coordinate system of the image
        cropView.configureWithCorners(corners: [CGPoint(x: 100, y: 120),
                                                CGPoint(x: 270, y: 170),
                                                CGPoint(x: 280, y: 450),
                                                CGPoint(x: 120, y: 400)], on: imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /**
         if you want to re-set cropView coordinates
         cropView.setCorners(newCorners: [CGPoint(x: 0, y: 120),
         CGPoint(x: 70, y: 1170),
         CGPoint(x: 80, y: 450),
         CGPoint(x: 20, y: 400)])
         */
    }
    
    @IBAction func saveImg(_ sender: Any) {
        do {
            guard let corners = cropView.cornerLocations else { return }
            guard let image = imageView.image else { return }
            
            let croppedImage = try SEQuadrangleHelper.cropImage(with: image, quad: corners)
            
            performSegue(withIdentifier: "doCrop", sender: croppedImage)
        } catch let error as SECropError {
            print(error)
        } catch {
            print("Something went wrong, are you feeling OK?")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let vc = segue.destination as? ImageViewController else { return }
        guard let img = sender as? UIImage else { return }
        vc.image = img
    }
}

