//
//  MetalRenderer+Shapes.swift
//  peruna
//
//  Created by aaron on 3/22/25.
//


import MetalKit
import Foundation

typealias PColor = SIMD4<Float>

@available(macOS 10.15, *)
extension PerunaMetalRenderer {
    
    /// Draws a rectangle at the specified position with the given dimensions using unnamed parameters.
    /// - Parameters:
    ///   - x: The x-coordinate of the rectangle's top-left corner.
    ///   - y: The y-coordinate of the rectangle's top-left corner.
    ///   - width: The width of the rectangle.
    ///   - height: The height of the rectangle.
    func rect(_ x: Float, _ y: Float, _ width: Float, _ height: Float) {
                
        let rect = PRectangle(
            device: device,
            x: x, y: y,
            width: width, height: height,
            canvasWidth: self.width, canvasHeight: self.height,
            fillColor: self.fillColor,
            strokeColor: self.strokeColor,
            strokeWidth: 3,
            hasStroke: self.hasStroke
        )
        shapes.append(rect)
    }
    
    /// Draws a rectangle at the specified position with the given dimensions using named parameters.
    /// - Parameters:
    ///   - x: The x-coordinate of the rectangle's top-left corner.
    ///   - y: The y-coordinate of the rectangle's top-left corner.
    ///   - width: The width of the rectangle.
    ///   - height: The height of the rectangle.
    func rect(x: Float, y: Float, width: Float, height: Float) {
        
        
        let rect = PRectangle(
            device: device,
            x: x, y: y,
            width: width, height: height,
            canvasWidth: self.width, canvasHeight: self.height,
            fillColor: self.fillColor,
            strokeColor: self.strokeColor,
            strokeWidth: 3,
            hasStroke: self.hasStroke
        )
        shapes.append(rect)
    }
    
    /// Draws a triangle with the specified vertex coordinates using unnamed parameters.
    /// - Parameters:
    ///   - x1: The x-coordinate of the first vertex.
    ///   - y1: The y-coordinate of the first vertex.
    ///   - x2: The x-coordinate of the second vertex.
    ///   - y2: The y-coordinate of the second vertex.
    ///   - x3: The x-coordinate of the third vertex.
    ///   - y3: The y-coordinate of the third vertex.
    func triangle(_ x1: Float, _ y1: Float, _ x2: Float, _ y2: Float, _ x3: Float, _ y3: Float) {
        
        let triangle = PTriangle(
            device: device,
            x1: x1, y1: y1,
            x2: x2, y2: y2,
            x3: x3, y3: y3,
            canvasWidth: self.width, canvasHeight: self.height,
            fillColor: self.fillColor,
            strokeColor: self.strokeColor,
            strokeWidth: 3,
            hasStroke: self.hasStroke
        )
        shapes.append(triangle)
    }
    
    /// Draws a triangle with the specified vertex coordinates using named parameters.
    /// - Parameters:
    ///   - x1: The x-coordinate of the first vertex.
    ///   - y1: The y-coordinate of the first vertex.
    ///   - x2: The x-coordinate of the second vertex.
    ///   - y2: The y-coordinate of the second vertex.
    ///   - x3: The x-coordinate of the third vertex.
    ///   - y3: The y-coordinate of the third vertex.
    func triangle(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float) {
        triangle(x1, y1, x2, y2, x3, y3)
    }
    
    /// Draws an ellipse at the specified position with the given dimensions using unnamed parameters.
    /// - Parameters:
    ///   - x: The x-coordinate of the ellipse's center.
    ///   - y: The y-coordinate of the ellipse's center.
    ///   - width: The width of the ellipse.
    ///   - height: The height of the ellipse.
    func ellipse(_ x: Float, _ y: Float, _ width: Float, _ height: Float) {
        
        let ellipse = PEllipse(
            device: device,
            x: x, y: y,
            width: width, height: height,
            canvasWidth: self.width, canvasHeight: self.height,
            fillColor: self.fillColor,
            strokeColor: self.strokeColor,
            strokeWidth: 3,
            hasStroke: self.hasStroke
        )
        shapes.append(ellipse)
    }
    
    /// Draws an ellipse at the specified position with the given dimensions using named parameters.
    /// - Parameters:
    ///   - x: The x-coordinate of the ellipse's center.
    ///   - y: The y-coordinate of the ellipse's center.
    ///   - width: The width of the ellipse.
    ///   - height: The height of the ellipse.
    func ellipse(x: Float, y: Float, width: Float, height: Float) {
        ellipse(x, y, width, height)
    }
    
    /// Draws a circle at the specified position with the given diameter using unnamed parameters.
    /// - Parameters:
    ///   - x: The x-coordinate of the circle's center.
    ///   - y: The y-coordinate of the circle's center.
    ///   - diameter: The diameter of the circle.
    func circle(_ x: Float, _ y: Float, _ diameter: Float) {
        ellipse(x, y, diameter, diameter)
    }
    
    /// Draws a circle at the specified position with the given diameter using named parameters.
    /// - Parameters:
    ///   - x: The x-coordinate of the circle's center.
    ///   - y: The y-coordinate of the circle's center.
    ///   - diameter: The diameter of the circle.
    func circle(x: Float, y: Float, diameter: Float) {
        circle(x, y, diameter)
    }
}

