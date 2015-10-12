//
//  Scene.swift
//  swiftracer
//
//  Created by Khrob Edmonds on 10/12/15.
//  Copyright © 2015 khrob. All rights reserved.
//

import Foundation

class STObject
{
    var diffuse:Vector = Vector(x:0.5,y:0.5,z:0.5)
    var specular:Double = 0.5
    
    /**
        Returns the normal at the point the ray intersects
        the object, or nil if there is no intersection
    **/
    func normalAtRay (ray:Ray) -> Vector?
    {
        return nil
    }
    
    /**
        Return the time t that the ray first intersects the 
        object, or nil if no hit occurs
    **/
    func intersection (ray:Ray) -> Double?
    {
        return nil
    }
}

class Sphere : STObject
{
    var centre:Vector = Vector(x: 0.0, y: 0.0, z: 0.0)
    var radius:Double = 1.0
    
    /** 
        Currently using a geometric solver. 
    **/
    override func intersection (ray: Ray) -> Double?
    {
        let rayToCenter = centre - ray.origin
        let timeAtProjection = rayToCenter ∙ ray.direction
        
        // Early out
        if timeAtProjection < 0
        {
            return nil
        }
        
        let radiusSquared = radius * radius
        let d2 = rayToCenter ∙ rayToCenter - timeAtProjection * timeAtProjection
        
        if d2 > radiusSquared
        {
            return nil
        }
        
        let dt = sqrt(radiusSquared - d2)
        let t0 = timeAtProjection + dt
        let t1 = timeAtProjection - dt
        
        if t0 > 0 && t0 > t1 { return t0 }
        if t1 > 0 && t1 > t0 { return t1 }
        
        return nil
    }
}

class Plane : STObject
{
    var normal:Vector = Vector (x: 0.0, y: 1.0, z: 0.0)
    var point:Vector = Vector (x: 0.0, y: 0.0, z: 0.0)
    
    override func intersection (ray:Ray) -> Double?
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
    
    /**
    If there's an intersection, returns a vector marking the
    point at which the ray hit the plane and the normal at that point
    **/
    func intersectionVector (ray:Ray) -> Ray?
    {
        guard let t = intersectionPoint(ray) else { return nil }
        return Ray(origin: t, direction: normal)
    }

    func intersectionPoint(ray:Ray) -> Vector?
    {
        if let t = intersection(ray) {
            return ray.atT(t)
        }
        return nil
    }
    
    override func normalAtRay (ray:Ray) -> Vector
    {
        return normal
    }
    
    init (ox:Double, oy:Double, oz:Double, nx:Double, ny:Double, nz:Double)
    {
        super.init()
        point = Vector(x: ox, y: oy, z: oz)
        normal = Vector(x: nx, y: ny, z: nz)
    }
}
