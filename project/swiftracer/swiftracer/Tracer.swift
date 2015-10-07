//
//  tracer.swift
//  swiftracer
//
//  Created by Khrob Edmonds on 6/10/2015.
//  Copyright © 2015 khrob. All rights reserved.
//

import Foundation
import AppKit
import CoreGraphics

/**
    Pixel buffer to CGImage routines derived from Joseph Lord's work at
    http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
**/

struct Sample
{
    let r:Double
    let g:Double
    let b:Double
    let a:Double
}

struct Pixel
{
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
}

let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)

func imageFromARGB32Bitmap(pixels:[Pixel], width:Int, height:Int) -> NSImage?
{
    assert(pixels.count == Int(width * height))
    
    var data = pixels
    let providerRef = CGDataProviderCreateWithCFData(
        NSData(bytes: &data, length: data.count * sizeof(Pixel))
    )
    
    if let cgim = CGImageCreate(width, height, 8, 32, width * sizeof(Pixel), rgbColorSpace, bitmapInfo, providerRef, nil, true, .RenderingIntentDefault)
    {
        return NSImage(CGImage: cgim, size: CGSizeMake(CGFloat(width),CGFloat(height)))
    }
    return nil
}

func simpleGradient (width:Int, height:Int) -> [Pixel]
{
    var buffer = [Pixel](count: width*height, repeatedValue: Pixel(a: 255, r: 0, g: 0, b: 0))
    var index = 0
    
    repeat {
        buffer[index].r = UInt8(index % 255)
        buffer[index].g = UInt8((index % 255) / 2)
        buffer[index].b = UInt8((index % 255) / 4)
        index++
    } while index < width * height
    
    return buffer
}
