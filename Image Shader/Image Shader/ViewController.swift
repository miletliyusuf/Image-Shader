//
//  ViewController.swift
//  Image Shader
//
//  Created by Maneesh Madan on 01/02/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var imageForView = UIImage()
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var imageToFilter: UIImageView!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIVignette",
        "CIVignetteEffect",
        "CIColorMonochrome",
        "CIColorPosterize",
        "CIFalseColor",
        "CIMaximumComponent",
        "CIMinimumComponent",
    ]

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 100
        let buttonHeight: CGFloat = 110
        let gapBetweenButtons: CGFloat = 5
        
        var itemCount = 0
        
        for i in 0..<CIFilterNames.count {
            itemCount = i
            
            // Button properties
            let filterButton = UIButton(type: .Custom)
            filterButton.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(ViewController.filterButtonTapped(_:)), forControlEvents: .TouchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            // Create filters for each button
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: originalImage.image!)
            let filter = CIFilter(name: "\(CIFilterNames[i])" )
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
            let imageForButton = UIImage(CGImage: filteredImageRef);
            
            // Assign filtered image to the button
            filterButton.setBackgroundImage(imageForButton, forState: .Normal)
            
            // Add Buttons in the Scroll View
            xCoord +=  buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButton)
        } // END FOR LOOP
        
        
        // Resize Scroll View
        filtersScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCount+2), yCoord)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterButtonTapped(sender: UIButton) {
        let button = sender as UIButton
        
        imageToFilter.image = button.backgroundImageForState(UIControlState.Normal)
    }

    @IBAction func saveButton(sender: AnyObject) {
        
        // Save the image into camera roll
        UIImageWriteToSavedPhotosAlbum(imageToFilter.image!, nil, nil, nil)
        
        let alert = UIAlertView(title: "Filters", message: "Your image has been saved to Photo Library", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    
    @IBAction func cameraButton(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage.contentMode = .ScaleAspectFill
            imageForView = pickedImage
            originalImage.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
}
/* var CIFilterNames = [
 "CIColorCrossPolynomial",
 "CIColorCube",
 "CIColorCubeWithColorSpace",
 "CIColorInvert",
 "CIColorMap",
 "CIColorMonochrome",
 "CIColorPosterize",
 "CIFalseColor",
 "CIMaskToAlpha",
 "CIMaximumComponent",
 "CIMinimumComponent",
 "CIPhotoEffectChrome",
 "CIPhotoEffectFade",
 "CIPhotoEffectInstant",
 "CIPhotoEffectMono",
 "CIPhotoEffectNoir",
 "CIPhotoEffectProcess",
 "CIPhotoEffectTonal",
 "CIPhotoEffectTransfer",
 "CISepiaTone",
 "CIVignette",
 "CIVignetteEffect"
 ]*/
