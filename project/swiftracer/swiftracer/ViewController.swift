//
//  ViewController.swift
//  swiftracer
//
//  Created by Khrob Edmonds on 6/10/2015.
//  Copyright © 2015 khrob. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{
    @IBOutlet weak var image: BackgroundImage!
    
    @IBOutlet weak var xSlider: NSSlider!
    @IBOutlet weak var ySlider: NSSlider!
    @IBOutlet weak var zSlider: NSSlider!

    @IBOutlet weak var distanceSlider: NSSlider!

    let width =  400
    let height = 300
    
    @IBAction func uiChanged(sender: AnyObject)
    {
        print ("Redrawing (\(xSlider.doubleValue),\(ySlider.doubleValue),\(zSlider.doubleValue)) \(distanceSlider.doubleValue)")
        let rays = makeRays(width, height: height, origin: Vector(x:xSlider.doubleValue, y:ySlider.doubleValue, z:zSlider.doubleValue), distance: distanceSlider.doubleValue, fov: 90.0)
        let buffer = simpleRaycast(rays, width:width, height:height)
        let gradient = imageFromARGB32Bitmap (buffer, width:width, height:height)
        
        image.image = gradient
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        uiChanged(self)
    }
    
}

class TracerWindow : NSWindowController
{
    override func windowDidLoad()
    {
        window?.title = ""
        window?.titlebarAppearsTransparent = true
        window?.movableByWindowBackground = true
    }
}

class BackgroundImage: NSImageView
{
    override var mouseDownCanMoveWindow:Bool {
        get { return true }
    }
}
