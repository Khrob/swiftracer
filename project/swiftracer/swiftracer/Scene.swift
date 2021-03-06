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
    var emission:Double = 0.0
    var name:String = ""
    
    func normalAtPoint (pt:Vector) -> Vector
    {
        return Vector()
    }
    
    func intersection (ray:Ray) -> Double?
    {
        return nil
    }
}

class Sphere : STObject
{
    var centre:Vector = Vector(x: 0.0, y: 0.0, z: 0.0)
    var radius:Double = 1.0
    var radiusSquared:Double = 1.0
    
    /** 
        Currently using a geometric solver. 
    **/
    override func intersection (ray: Ray) -> Double?
    {
        let L = centre - ray.origin
        let tca = L ∙ ray.direction
        
        // Early out
        if tca < 0 { return nil }
        
        let d2 = L ∙ L - tca * tca
        
        if d2 > radiusSquared { return nil }
        
        let thc = sqrt(radiusSquared - d2)
        var t0 = tca + thc
        var t1 = tca - thc
        
        if t0 > t1 {
            let tmp = t0
            t0 = t1
            t1 = tmp
        }
        
        if t0 < 0 {
            t0 = t1
            if t0 < 0
            {
                return nil
            }
        }
        return t0
    }
    
    override func normalAtPoint (point:Vector) -> Vector
    {
        // division by radius should make this a unit vector, as long
        // as the point actually lies on the surface of the sphere
        return Vector(x:(point.x-centre.x)/radius, y:(point.y-centre.y)/radius, z: (point.z-centre.z)/radius)
    }
    
    init (x:Double, y:Double, z:Double, r:Double)
    {
        super.init ()
        
        centre = Vector (x: x, y: y, z: z)
        radius = r
        radiusSquared = r * r
    }
    
    convenience init (x:Double, y:Double, z:Double, rad:Double, r:Double, g:Double, b:Double, e:Double, name:String)
    {
        self.init (x:x, y:y, z:z, r:rad)
        self.name = name
        self.diffuse = Vector(x: r, y: g, z: b)
        self.emission = e
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
            return ray.t(t)
        }
        return nil
    }
    
    override func normalAtPoint (point:Vector) -> Vector
    {
        return normal
    }
    
    init (ox:Double, oy:Double, oz:Double, nx:Double, ny:Double, nz:Double)
    {
        super.init()
        point = Vector(x: ox, y: oy, z: oz)
        normal = Vector(x: nx, y: ny, z: nz)
    }
    
    convenience init (ox:Double, oy:Double, oz:Double, nx:Double, ny:Double, nz:Double, r:Double, g:Double, b:Double, e:Double, name:String)
    {
        self.init (ox:ox, oy:oy, oz:oz, nx:nx, ny:ny, nz:nz)
        self.name = name
        self.emission = e
        self.diffuse = Vector(x: r, y: g, z: b)
    }
}

let Cornell:[STObject] = [
    Plane(ox:   0.0, oy:   0.0, oz:  0.0, nx:  0.0, ny:  1.0, nz:  0.0, r:0.5,  g:0.75, b:0.5,  e:0.5, name: "floor"),
    Plane(ox: -10.0, oy:   0.0, oz:  0.0, nx:  1.0, ny:  0.0, nz:  0.0, r:0.5,  g:0.5,  b:0.75, e:0.0, name: "leftwall"),
    Plane(ox:  10.0, oy:   0.0, oz:  0.0, nx: -1.0, ny:  0.0, nz:  0.0, r:0.75, g:0.5,  b:0.5,  e:0.0, name: "rightwall"),
    Plane(ox:   0.0, oy:  20.0, oz:  0.0, nx:  0.0, ny: -1.0, nz:  0.0, r:0.75, g:0.75, b:0.5,  e:0.0, name: "ceiling"),
    Plane(ox:   0.0, oy:  20.0, oz: 20.0, nx:  0.0, ny:  0.0, nz: -1.0, r:0.5,  g:0.75, b:0.75, e:0.0, name: "backwall"),
    Sphere(x: 0, y: 2, z: 0, rad: 2, r:1.0, g:1.0, b:1.0, e:0.0, name: "sphere")
]
