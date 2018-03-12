# CropView
Quadrangle view and image cropper like a Notes App



# Demo
![Screenshot](https://github.com/rzmn/CropView/blob/master/sample.gif)

# Usage
### Initialization
Set initial coordinates in points
``` swift
cropView.configureWithCorners(corners: [CGPoint(x: 120, y: 100),
                                        CGPoint(x: 270, y: 170),
                                        CGPoint(x: 280, y: 450),
                                        CGPoint(x: 120, y: 400)], on: imageView)
```
### Customisation
Customize color of your corners/contour and corners size
``` swift
// SECornerView.swift
static var cornerSize : CGFloat = 50.0
```
``` swift
// SECropView.swift
static var goodAreaColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
static var badAreaColor  = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
```
### Geometry
``` swift
// SEQuadrangleHelper.swift

// Crop image by quadrangle points in pixels
static public func cropImage(with image: UIImage, quad: [CGPoint]) throws -> UIImage
// get image frame in UIImageView and convert quadrangle coordinates into image pixels
static public func getCoordinatesOnImageWithoutScale(on imageView: UIImageView, with cropView: SECropView) throws -> Array<CGPoint>
// get quadrangle coordinates, related by UIImageView frame in pixels
static public func getCoordinatesOnImageView(on imageView: UIImageView, with cropView: SECropView) throws -> Array<CGPoint>
```

