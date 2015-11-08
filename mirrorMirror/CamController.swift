//
//  CamController.swift
//  mirrorMirror
//
//  Created by Luis Ferrer Labarca on 11/8/15.
//  Copyright © 2015 MirrorMirror. All rights reserved.
//

import UIKit
import Alamofire

var photo: UIImage?

class CamController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageview: UIImageView!
  
    @IBAction func acceptPicture(sender: AnyObject) {
        
        let base64String = UIImagePNGRepresentation(imageview.image!)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        print(base64String)
        
        Alamofire.request(.POST, "http://ferrerluis.com/images", parameters: ["picture": base64String], encoding: .JSON)
            .responseJSON { (response) in
                if let json = response.result.value {
                    
                    print(true)
                }
        }
        
        performSegueWithIdentifier("photoSelected", sender: self)
    }
    
//    @IBAction func librarybutton(sender: UIButton) {
//        
//        let picker = UIImagePickerController()
//        
//        picker.delegate = self
//        picker.sourceType = .PhotoLibrary
//        
//        presentViewController(picker, animated: true, completion: nil)
//    }
    
    @IBAction func photobutton(sender: AnyObject) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageview.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}