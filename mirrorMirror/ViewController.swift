//
//  ViewController.swift
//  mirrorMirror
//
//  Created by Luis Ferrer Labarca on 11/8/15.
//  Copyright © 2015 MirrorMirror. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var yesArea: UIButton!
    @IBOutlet weak var noArea: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    func stylePage() {
        
        let roundedUpPath = UIBezierPath(roundedRect:image.bounds, byRoundingCorners:[UIRectCorner.TopRight, .TopLeft], cornerRadii: CGSizeMake(5, 5))
        let roundedUpLayer = CAShapeLayer()
        roundedUpLayer.path = roundedUpPath.CGPath
        image.layer.mask = roundedUpLayer
        image.clipsToBounds = true
        
        let roundedDownLeftPath = UIBezierPath(roundedRect:noArea.bounds, byRoundingCorners:[UIRectCorner.BottomLeft], cornerRadii: CGSizeMake(5, 5))
        let roundedDownRightPath = UIBezierPath(roundedRect:yesArea.bounds, byRoundingCorners:[UIRectCorner.BottomRight], cornerRadii: CGSizeMake(5, 5))
        let roundedDownLeftLayer = CAShapeLayer()
        roundedDownLeftLayer.path = roundedDownLeftPath.CGPath
        let roundedDownRightLayer = CAShapeLayer()
        roundedDownRightLayer.path = roundedDownRightPath.CGPath
        
        noArea.layer.mask = roundedDownLeftLayer
        yesArea.layer.mask = roundedDownRightLayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stylePage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

