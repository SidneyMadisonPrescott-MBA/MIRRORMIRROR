//
//  ViewController.swift
//  mirrorMirror
//
//  Created by Luis Ferrer Labarca on 11/8/15.
//  Copyright © 2015 MirrorMirror. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var feed: [JSON] = [JSON]()

class ViewController: UIViewController {

    @IBOutlet weak var left: UIView!
    @IBOutlet weak var right: UIView!
    @IBOutlet weak var yesArea: UIButton!
    @IBOutlet weak var noArea: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    func updatePicture() {
        
        feed.removeFirst()
        
        if feed.count != 0 {
            
            let picture = feed[0]["picture"].stringValue
            
            if let decodedData = NSData(base64EncodedString: picture, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                
                image.image = UIImage(data: decodedData)
            }
        }
    }
    
    @IBAction func noAction(sender: AnyObject) {
        
        let no = feed[0]["no"].intValue
        let id = feed[0]["id"].intValue
        
        print(no, id)
        
        Alamofire.request(.PUT, "http://ferrerluis.com/images", parameters: ["id": id, "no": no + 1])
            .responseJSON { (response) in
                if let json = response.result.value {
                    
                    print(JSON(json))
                }
        }
        
        noArea.hidden = true
        yesArea.hidden = true
    }
    
    @IBAction func yesAction(sender: AnyObject) {
        
        let yes = feed[0]["yes"].intValue
        let id = feed[0]["id"].intValue
        
        print(yes, id)
        
        Alamofire.request(.PUT, "http://ferrerluis.com/images", parameters: ["id": id,"yes": yes + 1])
            .responseJSON { (response) in
                if let json = response.result.value {
                    
                    print(JSON(json))
                }
        }
        
        noArea.hidden = true
        yesArea.hidden = true
    }
    
    func stylePage() {
        
        let roundedUpPath = UIBezierPath(roundedRect:image.bounds, byRoundingCorners:[UIRectCorner.TopRight, .TopLeft], cornerRadii: CGSizeMake(5, 5))
        let roundedUpLayer = CAShapeLayer()
        roundedUpLayer.path = roundedUpPath.CGPath
        image.layer.mask = roundedUpLayer
        image.clipsToBounds = true
        
        let roundedDownLeftPath = UIBezierPath(roundedRect:left.bounds, byRoundingCorners:[UIRectCorner.BottomLeft], cornerRadii: CGSizeMake(5, 5))
        let roundedDownRightPath = UIBezierPath(roundedRect:right.bounds, byRoundingCorners:[UIRectCorner.BottomRight], cornerRadii: CGSizeMake(5, 5))
        let roundedDownLeftLayer = CAShapeLayer()
        roundedDownLeftLayer.path = roundedDownLeftPath.CGPath
        let roundedDownRightLayer = CAShapeLayer()
        roundedDownRightLayer.path = roundedDownRightPath.CGPath
        
        left.layer.mask = roundedDownLeftLayer
        right.layer.mask = roundedDownRightLayer
    }
    
    func populate() {
        
        if feed.count == 0 {
            
            return
        }

        let picture = feed[0]["picture"].stringValue
        
        if let decodedData = NSData(base64EncodedString: picture, options: NSDataBase64DecodingOptions(rawValue: 0)) {
            
            image.image = UIImage(data: decodedData)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request(.GET, "http://ferrerluis.com/images")
            .responseJSON { (response) in
                if let json = response.result.value {
                    
                    for piece in JSON(json) {
                        
                        feed.append(piece.1)
                    }
                    
                    self.populate()
                }
        }
        
        stylePage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

