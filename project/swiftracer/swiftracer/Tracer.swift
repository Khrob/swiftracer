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
    var r:UInt8 = 0
    var g:UInt8 = 0
    var b:UInt8 = 0
    
    static func buffer (size:Int) -> [Pixel]
    {
        return [Pixel](count: size, repeatedValue: Pixel())
    }
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
    
    repeat
    {
        let dw = UInt8 (255 * index % width / width)
        let dh = UInt8 (255 * index / width / height)
        let dd = UInt8 (255 - dh)
        
        buffer[index].r = dw
        buffer[index].g = dh
        buffer[index].b = dd
        index++
    }
        while index < width * height
    
    return buffer
}
func simpleRaycast (rays:[Ray], width:Int, height:Int) -> [Pixel]
{
    var pixels = Pixel.buffer(rays.count)
    let plane = Plane(normal:Vector(x:0, y:1, z:0), point:Vector(x:0, y:-4, z:0))
    
    var index = 0
    var max_t = 0.0
    
    repeat
    {
        if let t = plane.intersection(rays[index])
        {
            var inter = t * 255
            if inter > 255 { inter = 255 }
            let gray:UInt8 =  UInt8(255 - inter)
            
            pixels[index].r = gray / 2
            pixels[index].g = gray / 2
            pixels[index].b = gray / 2
            
            let p = rays[index].atT(t)
            let x = Int(abs(p.x))
            let y = Int(abs(p.z))
            
            if x % 2 == y % 2
            {
                pixels[index].r = gray / 4
                pixels[index].g = gray / 4
                pixels[index].b = gray / 4
            }

            if t > max_t { max_t = t }
        }
        else
        {
            let dw = UInt8 (255 * index % width / width)
            let dh = UInt8 (255 * index / width / height)
            let dd = UInt8 (255 - dh)
            
            pixels[index].r = dw
            pixels[index].g = dh
            pixels[index].b = dd
        }
        index++
        
    } while index < rays.count
    
    print ("max_t: \(max_t)")
    return pixels
}
