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
    @IBOutlet weak var imageView: UIImageView!
    
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
    
    @IBAction func saveImg(_ sender: Any) {
        do {
            let quad = try SEQuadrangleHelper.getCoordinatesOnImageWithoutScale(on: imageView, with: cropView)
            print(quad)
            guard let image = imageView.image else { return }
            let croppedImage = try SEQuadrangleHelper.cropImage(with: image, quad: quad)
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

