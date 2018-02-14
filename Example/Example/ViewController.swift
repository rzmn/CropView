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
        cropView.configureWithCorners(corners: [CGPoint(x: 120, y: 100),
                                                CGPoint(x: 270, y: 170),
                                                CGPoint(x: 280, y: 450),
                                                CGPoint(x: 120, y: 400)], on: imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
         if you want to re-set cropView coordinates
         cropView.setCorners(newCorners: [CGPoint(x: 240, y: 200),
         CGPoint(x: 540, y: 340),
         CGPoint(x: 560, y: 900),
         CGPoint(x: 240, y: 800)])
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

