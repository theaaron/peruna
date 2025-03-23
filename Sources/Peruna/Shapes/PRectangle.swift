//
//  PRectangle.swift
//  peruna
//
//  Created by aaron on 3/22/25.
//

import MetalKit
import Foundation

class PRectangle: PShape {
    private let vertexBuffer: MTLBuffer
    private let uniformBuffer: MTLBuffer
    private let isStrokeBuffer: MTLBuffer
    private let strokeWidth: Float
    private let hasStroke: Bool
    
    init(device: MTLDevice,
         x: Float, y: Float,
         width: Float, height: Float,
         canvasWidth: Float, canvasHeight: Float,
         fillColor: SIMD4<Float> = SIMD4<Float>(1.0, 0.2, 0.5, 1.0),
         strokeColor: SIMD4<Float> = SIMD4<Float>(1.0, 1.0, 1.0, 1.0),
         strokeWidth: Float = 0,
         hasStroke: Bool) {
        
        self.strokeWidth = strokeWidth
        self.hasStroke = hasStroke
        
        // Convert coordinates to normalized device coordinates (-1 to 1)
        let ndcX = (x - (canvasWidth / 2)) / (canvasWidth / 2)
        let ndcY = ((canvasHeight / 2) - y) / (canvasHeight / 2)
        
        let ndcWidth = width / canvasWidth
        let ndcHeight = height / canvasHeight
        
        // Calculate corners for the outer rectangle (if stroke is enabled)
        let outerLeft = ndcX - (ndcWidth / 1)
        let outerRight = ndcX + (ndcWidth / 1)
        let outerTop = ndcY + (ndcHeight / 1)
        let outerBottom = ndcY - (ndcHeight / 1)
        
        // Calculate corners for the inner rectangle (for the stroke effect)
        let strokeWidthNDC = strokeWidth / min(canvasWidth, canvasHeight)
        let innerLeft = outerLeft + strokeWidthNDC
        let innerRight = outerRight - strokeWidthNDC
        let innerTop = outerTop - strokeWidthNDC
        let innerBottom = outerBottom + strokeWidthNDC
        
        var vertices: [Float] = []
        var isStroke: [Bool] = []
        
        if hasStroke && strokeWidth > 0 {
            // Create vertices for the outer rectangle (with stroke)
            // Bottom side
            vertices += [outerLeft, outerBottom, 0, 1]
            vertices += [outerRight, outerBottom, 0, 1]
            vertices += [innerLeft, innerBottom, 0, 1]
            
            vertices += [innerLeft, innerBottom, 0, 1]
            vertices += [outerRight, outerBottom, 0, 1]
            vertices += [innerRight, innerBottom, 0, 1]
            
            // Right side
            vertices += [outerRight, outerBottom, 0, 1]
            vertices += [outerRight, outerTop, 0, 1]
            vertices += [innerRight, innerBottom, 0, 1]
            
            vertices += [innerRight, innerBottom, 0, 1]
            vertices += [outerRight, outerTop, 0, 1]
            vertices += [innerRight, innerTop, 0, 1]
            
            // Top side
            vertices += [outerRight, outerTop, 0, 1]
            vertices += [outerLeft, outerTop, 0, 1]
            vertices += [innerRight, innerTop, 0, 1]
            
            vertices += [innerRight, innerTop, 0, 1]
            vertices += [outerLeft, outerTop, 0, 1]
            vertices += [innerLeft, innerTop, 0, 1]
            
            // Left side
            vertices += [outerLeft, outerTop, 0, 1]
            vertices += [outerLeft, outerBottom, 0, 1]
            vertices += [innerLeft, innerTop, 0, 1]
            
            vertices += [innerLeft, innerTop, 0, 1]
            vertices += [outerLeft, outerBottom, 0, 1]
            vertices += [innerLeft, innerBottom, 0, 1]
            
            // All of these vertices are for the stroke
            for _ in 0..<24 {
                isStroke.append(true)
            }
            
            // Fill center (if needed)
            vertices += [innerLeft, innerBottom, 0, 1]
            vertices += [innerRight, innerBottom, 0, 1]
            vertices += [innerLeft, innerTop, 0, 1]
            
            vertices += [innerLeft, innerTop, 0, 1]
            vertices += [innerRight, innerBottom, 0, 1]
            vertices += [innerRight, innerTop, 0, 1]
            
            // These vertices are for the fill
            for _ in 0..<6 {
                isStroke.append(false)
            }
        } else {
            // Default rectangle without stroke (original implementation)
            vertices += [outerLeft, outerBottom, 0, 1]
            vertices += [outerRight, outerBottom, 0, 1]
            vertices += [outerLeft, outerTop, 0, 1]
            
            vertices += [outerLeft, outerTop, 0, 1]
            vertices += [outerRight, outerBottom, 0, 1]
            vertices += [outerRight, outerTop, 0, 1]
            
            // All vertices are fill
            for _ in 0..<6 {
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
        
        let vertexCount = hasStroke && strokeWidth > 0 ? 30 : 6
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount)
    }

}
