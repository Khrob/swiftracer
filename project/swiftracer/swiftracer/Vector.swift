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
}

infix operator ∙ { associativity left precedence 140 }
func ∙ (v1:Vector, v2:Vector) -> Double
{
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
}

/** 
    I'll admit, I'm hesitant to overload this, but I think 
    it makes sense for vectors.
**/
func - (left:Vector, right:Vector) -> Vector
{
    return Vector (x: left.x-right.x, y: left.y-right.y, z: left.z-right.z)
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
            let r = point - ray.origin
            let numer = r ∙ normal
            
            let t = numer / denom
            
            if t > 0
            {
                return t
            }
        }
        return nil
    }
    
    func intersectionPoint (ray:Ray) -> Vector?
    {
        if let t = intersection(ray) {
            return ray.atT(t)
        }
        return nil
    }
    
    /**
        If there's an intersection, returns a vector marking the 
        point at which the ray hit the plane and the normal at that point
    **/
    func intersectionVector (ray:Ray) -> Ray?
    {
        guard let t = intersectionPoint(ray) else { return nil }
        return Ray(origin: t, direction: normal)
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
