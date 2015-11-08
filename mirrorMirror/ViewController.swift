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
//
var feed: [JSON] = [JSON]()
//
class ViewController: UIViewController {
//
    @IBOutlet weak var left: UIView!
    @IBOutlet weak var right: UIView!
    @IBOutlet weak var yesArea: UIButton!
    @IBOutlet weak var noArea: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var warning: UILabel!
    
    func updateLabels() {
        
        noArea.hidden = true
        yesArea.hidden = true
        noLabel.hidden = false
        noLabel.text = String(feed[0]["no"].intValue)
        yesLabel.hidden = false
        yesLabel.text = String(feed[0]["yes"].intValue)
    }
    
    func updatePicture() {
        
        feed.removeFirst()
        
        if feed.count != 0 {
            
            let picture = feed[0]["picture"].stringValue
            
            if let decodedData = NSData(base64EncodedString: picture, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                
                image.image = UIImage(data: decodedData)
            }
            
            
        } else {
            
            container.hidden = true
            warning.hidden = false
        }
    }
    
    @IBAction func swipeUp(sender: AnyObject) {
        
        if yesArea.hidden && noArea.hidden {
            
            if feed.count == 0 {
                
                container.hidden = true
                warning.hidden = false
                
                return
            }
            
            updatePicture()
            
            noLabel.hidden = true
            yesLabel.hidden = true
            noArea.hidden = false
            yesArea.hidden = false
        }
    }
    
    @IBAction func noAction(sender: AnyObject) {
        
        feed[0]["no"].intValue += 1
        let no = feed[0]["no"].intValue
        let id = feed[0]["id"].intValue
        
        Alamofire.request(.PUT, "http://ferrerluis.com/images", parameters: ["id": id, "no": no], encoding: .JSON)
            .responseJSON { (response) in
                if let json = response.result.value {
                    
                    print(true)
                }
        }
        
        updateLabels()
    }
    
    @IBAction func yesAction(sender: AnyObject) {
        
        feed[0]["yes"].intValue += 1
        let yes = feed[0]["yes"].intValue
        let id = feed[0]["id"].intValue
        
        print(yes, id)
        
        Alamofire.request(.PUT, "http://ferrerluis.com/images", parameters: ["id": id, "yes": yes], encoding: .JSON)
            .responseJSON { (response) in
                if let json = response.result.value {
                    
                    print(true)
                }
        }
        
        updateLabels()
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
        
        noLabel.hidden = true
        yesLabel.hidden = true
        warning.hidden = true
        
        if feed.count == 0 {
            
            container.hidden = true
            warning.hidden = false
        }
        
        Alamofire.request(.GET, "http://ferrerluis.com/images")
            .responseJSON { (response) in
                if let json = response.result.value {
                    
                    for piece in JSON(json) {
                        
                        feed.append(piece.1)
                    }
                    
                    self.warning.hidden = true
                    self.container.hidden = false
                    self.populate()
                }
        }
        
        stylePage()
//
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

