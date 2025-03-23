//
//  PTriangle.swift
//  Peruna
//
//  Created by aaron on 2/6/25.
//

import Foundation
import MetalKit

// MARK: - Triangle Implementation

class PTriangle: PShape {
    private let vertexBuffer: MTLBuffer
    private let uniformBuffer: MTLBuffer
    private let isStrokeBuffer: MTLBuffer
    private let strokeWidth: Float
    private let hasStroke: Bool
    
    init(device: MTLDevice,
         x1: Float, y1: Float,
         x2: Float, y2: Float,
         x3: Float, y3: Float,
         canvasWidth: Float, canvasHeight: Float,
         fillColor: SIMD4<Float> = SIMD4<Float>(1.0, 0.2, 0.5, 1.0),
         strokeColor: SIMD4<Float> = SIMD4<Float>(1.0, 1.0, 1.0, 1.0),
         strokeWidth: Float = 0,
         hasStroke: Bool) {
        
        self.strokeWidth = strokeWidth
        self.hasStroke = hasStroke
        
        // Convert coordinates to normalized device coordinates (-1 to 1)
        let ndcX1 = (x1 - (canvasWidth / 2)) / (canvasWidth / 2)
        let ndcY1 = ((canvasHeight / 2) - y1) / (canvasHeight / 2)
        let ndcX2 = (x2 - (canvasWidth / 2)) / (canvasWidth / 2)
        let ndcY2 = ((canvasHeight / 2) - y2) / (canvasHeight / 2)
        let ndcX3 = (x3 - (canvasWidth / 2)) / (canvasWidth / 2)
        let ndcY3 = ((canvasHeight / 2) - y3) / (canvasHeight / 2)
        
        var vertices: [Float] = []
        var isStroke: [Bool] = []
        
        if hasStroke && strokeWidth > 0 {
            // For a triangle with stroke, we need to create an inner triangle
            // and draw quads between the outer and inner triangles for the stroke
            
            // Calculate vectors for the sides of the triangle
            let v12x = ndcX2 - ndcX1
            let v12y = ndcY2 - ndcY1
            let v23x = ndcX3 - ndcX2
            let v23y = ndcY3 - ndcY2
            let v31x = ndcX1 - ndcX3
            let v31y = ndcY1 - ndcY3
            
            // Normalize the vectors
            let len12 = sqrt(v12x * v12x + v12y * v12y)
            let len23 = sqrt(v23x * v23x + v23y * v23y)
            let len31 = sqrt(v31x * v31x + v31y * v31y)
            
            let n12x = v12y / len12
            let n12y = -v12x / len12
            let n23x = v23y / len23
            let n23y = -v23x / len23
            let n31x = v31y / len31
            let n31y = -v31x / len31
            
            // Calculate stroke width in NDC space
            let strokeWidthNDC = strokeWidth / min(canvasWidth, canvasHeight)
            
            // Calculate inner triangle vertices by moving inward along normals
            let innerX1 = ndcX1 + n12x * strokeWidthNDC - n31x * strokeWidthNDC
            let innerY1 = ndcY1 + n12y * strokeWidthNDC - n31y * strokeWidthNDC
            let innerX2 = ndcX2 + n23x * strokeWidthNDC - n12x * strokeWidthNDC
            let innerY2 = ndcY2 + n23y * strokeWidthNDC - n12y * strokeWidthNDC
            let innerX3 = ndcX3 + n31x * strokeWidthNDC - n23x * strokeWidthNDC
            let innerY3 = ndcY3 + n31y * strokeWidthNDC - n23y * strokeWidthNDC
            
            // Add stroke vertices - three quads (6 triangles) connecting outer and inner triangles
            // First side (between points 1 and 2)
            vertices += [ndcX1, ndcY1, 0, 1]
            vertices += [ndcX2, ndcY2, 0, 1]
            vertices += [innerX1, innerY1, 0, 1]
            
            vertices += [innerX1, innerY1, 0, 1]
            vertices += [ndcX2, ndcY2, 0, 1]
            vertices += [innerX2, innerY2, 0, 1]
            
            // Second side (between points 2 and 3)
            vertices += [ndcX2, ndcY2, 0, 1]
            vertices += [ndcX3, ndcY3, 0, 1]
            vertices += [innerX2, innerY2, 0, 1]
            
            vertices += [innerX2, innerY2, 0, 1]
            vertices += [ndcX3, ndcY3, 0, 1]
            vertices += [innerX3, innerY3, 0, 1]
            
            // Third side (between points 3 and 1)
            vertices += [ndcX3, ndcY3, 0, 1]
            vertices += [ndcX1, ndcY1, 0, 1]
            vertices += [innerX3, innerY3, 0, 1]
            
            vertices += [innerX3, innerY3, 0, 1]
            vertices += [ndcX1, ndcY1, 0, 1]
            vertices += [innerX1, innerY1, 0, 1]
            
            // All these vertices are for stroke
            for _ in 0..<18 {
                isStroke.append(true)
            }
            
            // Add fill vertices (inner triangle)
            vertices += [innerX1, innerY1, 0, 1]
            vertices += [innerX2, innerY2, 0, 1]
            vertices += [innerX3, innerY3, 0, 1]
            
            // These vertices are for fill
            for _ in 0..<3 {
                isStroke.append(false)
            }
        } else {
            // Simple triangle without stroke
            vertices += [ndcX1, ndcY1, 0, 1]
            vertices += [ndcX2, ndcY2, 0, 1]
            vertices += [ndcX3, ndcY3, 0, 1]
            
            // All vertices are fill
            for _ in 0..<3 {
                isStroke.append(false)
            }
        }
        
        // Create vertex buffer
        guard let buffer = device.makeBuffer(bytes: vertices,
                                           length: vertices.count * MemoryLayout<Float>.size,
                                           options: []) else {
            fatalError("Could not create vertex buffer")
        }
        self.vertexBuffer = buffer
        
        // Create is-stroke buffer
        guard let strokeBuffer = device.makeBuffer(bytes: isStroke,
                                              length: isStroke.count * MemoryLayout<Bool>.size,
                                              options: []) else {
            fatalError("Could not create stroke buffer")
        }
        self.isStrokeBuffer = strokeBuffer
        
        // Create uniform buffer for colors
        let uniforms = Uniforms(fillColor: fillColor, strokeColor: strokeColor, hasStroke: hasStroke ? 1 : 0)
        guard let uniformsBuffer = device.makeBuffer(bytes: [uniforms],
                                                  length: MemoryLayout<Uniforms>.size,
                                                  options: []) else {
            fatalError("Could not create uniforms buffer")
        }
        self.uniformBuffer = uniformsBuffer
    }
    
    func draw(encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBuffer(isStrokeBuffer, offset: 0, index: 1)
        encoder.setVertexBuffer(uniformBuffer, offset: 0, index: 2)
        encoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 0)
        
        let vertexCount = hasStroke && strokeWidth > 0 ? 21 : 3
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount)
    }
}


