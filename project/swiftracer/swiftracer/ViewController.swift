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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let buffer = simpleGradient(480,height: 300)
        let gradient = imageFromARGB32Bitmap (buffer, width: 480, height: 300)
        
        image.image = gradient
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
