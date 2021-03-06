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
    var r:Double = 0.0
    var g:Double = 0.0
    var b:Double = 0.0
    var a:Double = 1.0
    
    static func buffer (size:Int) -> [Sample]
    {
        return [Sample](count: size, repeatedValue: Sample())
    }
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
    var buffer = Pixel.buffer(width * height)
    var index = 0
    
    repeat {
        
        let dw = UInt8 (255 * index % width / width)
        let dh = UInt8 (255 * index / width / height)
        let dd = UInt8 (255 - dh)
        
        buffer[index].r = dw
        buffer[index].g = dh
        buffer[index].b = dd
        index++
        
    } while index < width * height
    
    return buffer
}

func makeRays (width:Int, height:Int, origin:Vector, distance:Double, fov:Double) -> [Ray]
{
    var rays = [Ray](count:width*height, repeatedValue:Ray(origin:origin, direction:Vector(x:0, y:0, z:0)))
    
    var index = 0
    
    for h in 0..<height {
        
        let dy = Double(height/2 - h)
        
        for w in 0..<width {
        
            let dx = Double(w - width/2)
            
            rays[index].direction.x = dx
            rays[index].direction.y = dy
            rays[index].direction.z = distance
            
            rays[index].direction = rays[index].direction.unit()
            index++
        }
    }
    
    return rays
}

func simpleRaycast (rays:[Ray], width:Int, height:Int) -> [Pixel]
{
    var pixels = Pixel.buffer(rays.count)
    let plane =  Plane(ox: 0, oy: -4, oz: 0, nx: 0, ny: 1, nz: 0)
    
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
            
            let p = rays[index].t(t)
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

func intersection (scene:[STObject], ray:Ray) -> (point:Ray, obj:STObject)?
{
    var t:Double = Double.infinity
    var hit:STObject?
    
    for obj in scene
    {
        if let newT = obj.intersection(ray)
        {
            if newT < t && t > 0.00001
            {
                hit = obj
                t = newT
            }
        }
    }
    
    if t == Double.infinity { return nil }
    
    let pt = ray.t(t)
    let normal = hit!.normalAtPoint(pt)
    let r = Ray(origin:pt, direction:normal)
    return (r, hit!)
}

func simpleScene (scene:[STObject], rays:[Ray], width:Int, height:Int) -> [Pixel]
{
    var pixels = Pixel.buffer(rays.count)
    var index = 0
    
    repeat
    {
        let s = trace(scene, ray: rays[index], depth: 0, colour: Sample())
        
        var r = s.r * 255
        var g = s.g * 255
        var b = s.b * 255
        
        if r > 255 { r = 255 }
        if g > 255 { g = 255 }
        if b > 255 { b = 255 }
    
        pixels[index] = Pixel(a: 255, r:UInt8(r), g:UInt8(g), b:UInt8(b))
        
//        print("\(s) \(pixels[index])")
        
        index++
    
    } while index < rays.count
    
    return pixels
}

let BOUNCES = 10.0

func trace (scene:[STObject], ray:Ray, depth:Int, var colour:Sample) -> Sample
{
    if depth > Int(BOUNCES-1)
    {
//        print("depth5 \(colour) \(depth)")
        return colour
    }
    
    guard let hit = intersection(scene, ray: ray) else {
//        print("nohit \(colour) \(depth)")
        return colour
    }
    
    colour.r += hit.obj.diffuse.x / BOUNCES
    colour.g += hit.obj.diffuse.y / BOUNCES
    colour.b += hit.obj.diffuse.z / BOUNCES
    
//    print("returning \(colour) \(depth)")
    return trace(scene, ray:hit.point, depth:depth+1, colour:colour)
}
