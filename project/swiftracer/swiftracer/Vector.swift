//
//  Vector.swift
//  swiftracer
//
//  Created by Khrob Edmonds on 7/10/2015.
//  Copyright © 2015 khrob. All rights reserved.
//

import Foundation

struct Vector
{
    var x:Double
    var y:Double
    var z:Double
    
    func magnitudeSquared () -> Double
    {
        return x*x + y*y + z*z
    }
    
    func unit () -> Vector
    {
        let mag = sqrt(magnitudeSquared())
        return Vector(x: x/mag, y:y/mag, z:z/mag)
    }
    
    func minus (v2:Vector) -> Vector
    {
        return Vector(x: x-v2.x, y: y-v2.y, z: z-v2.z)
    }
}

infix operator ∙ { associativity left precedence 140 }
func ∙ (v1:Vector, v2:Vector) -> Double
{
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
}

struct Plane
{
    var normal:Vector
    var point:Vector
    
    func intersection (ray:Ray) -> Double?
    {
        let denom = ray.direction ∙ normal
        
        // Negative denomenator - no intersection
        if abs(denom) > 0.000001
        {
            let r = point.minus(ray.origin)
            let numer = r ∙ normal
            
            let t = numer / denom
            
            if t > 0
            {
                //print ("t: \(t)")
                return t
            }
        }
        return nil
    }
    
    func intersectionPoint(ray:Ray) -> Vector?
    {
        if let t = intersection(ray) {
            return ray.atT(t)
        }
        return nil
    }
}

struct Ray
{
    var origin:Vector
    var direction:Vector
    
    func atT (t:Double) -> Vector
    {
        return Vector (x:origin.x+direction.x*t, y:origin.y+direction.y*t, z:origin.z+direction.z*t)
    }
}
