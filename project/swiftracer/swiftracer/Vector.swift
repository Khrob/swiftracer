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
    var x:Double = 0.0
    var y:Double = 0.0
    var z:Double = 0.0
    
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

func - (left:Vector, right:Vector) -> Vector
{
    return Vector (x: left.x-right.x, y: left.y-right.y, z: left.z-right.z)
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
