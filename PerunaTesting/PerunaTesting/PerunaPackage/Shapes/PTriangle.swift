//
//  PTriangle.swift
//  PerunaTesting
//
//  Created by aaron on 2/22/25.
//

import Foundation

struct PTriangle: PShape {
    var vertices: [SIMD3<Float>]
    var width: Float
    var height: Float
    var x: Float
    var y: Float
    
    init(vertices: [SIMD3<Float>], width: Float, height: Float, x: Float, y: Float) {
        var pts = [SIMD3<Float>]()
        for i in 0..<3 {
            
            pts[i] = [0, 0, 0]
        }
        self.vertices = pts
        self.width = width
        self.height = height
        self.x = x
        self.y = y
    }
}
