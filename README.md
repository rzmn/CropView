# CropView
Crop rectangle view like in Notes App


## Demo
# ![Screenshot](https://raw.githubusercontent.com/rzmn/CropView/master/Pod/Assets/ScreenCauture.gif)

### Usage
``` swift
let cropView = SECropView()
cropView.frame = view.frame
cropView.configureWithCorners(corners: [CGPoint(x: 100, y: 120),
                                        CGPoint(x: 270, y: 170),
                                        CGPoint(x: 280, y: 450),
                                        CGPoint(x: 120, y: 400)])
view.addSubview(cropView)
```