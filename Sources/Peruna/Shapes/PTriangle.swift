//
//  PTriangle.swift
//  Peruna
//
//  Created by aaron on 2/6/25.
//

class PTriangle: PShape {
    var vertices: [SIMD3<Float>]
    
    
    init(vertices: [SIMD3<Float>]) {
        let multi: Float = 1.0
        self.vertices = []
        for vertex in vertices {
            let vert: SIMD3<Float> = [vertex.x*multi, vertex.y*multi, vertex.z*multi]
            self.vertices.append(vert)
        }
        
    }

}
