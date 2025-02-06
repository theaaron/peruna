/// Peruna is a creative coding library for Swift that makes it easy to create visual and interactive art.
///
/// ## Overview
/// Peruna provides a set of tools and utilities for artists and developers to express their creativity through code.
/// Start with basic building blocks like colors and shapes, then combine them to create complex visual experiences.
///

import Foundation
import MetalKit
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif

public class Peruna {
    private let renderer: MetalRenderer
    
    public func rect(_ x: Float, _ y: Float, _ w: Float, _ h: Float)
    public func rect(x: Float,y: Float, w: Float, h: Float)
}

//class MetalContext {
//    let device: MTLDevice?
//    let view: MTKView
//    let frame: CGRect
//    
//    @MainActor init() {
//        guard let device = MTLCreateSystemDefaultDevice() else { fatalError("GPU not found") }
//        self.device = device
//        self.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
//        self.view = MTKView(frame: frame, device: device)
//        self.view.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
//    }
//    
//    @MainActor public func changCanvasBG(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
//        self.view.clearColor = MTLClearColor(red: r, green: g, blue: b, alpha: a)
//    }
//    
//    @MainActor public func changeCanvasSize(w: CGFloat, h: CGFloat) {
//        self.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
//    }
//}
//
//@MainActor internal let metalContext = MetalContext()
//
//@MainActor func setup( _ userSetupMethod: () -> Void) {
//    #if canImport(PlaygroundSupport)
//    PlaygroundPage.current.liveView = metalContext.view
//    #endif
//    
//    userSetupMethod()
//}
//
//func draw(_ userDrawMethod: () -> Void) {
//    userDrawMethod()
//}
//
//
///// Creates a metal clear color from RGB or grayscale values.
/////
///// Use this function to create ``MTLClearColor`` instances with RGB values in the familiar 0-255 range
///// instead of normalized 0-1 values.
/////
///// You can create colors using either RGB values:
///// ```swift
///// let red = color(255, 0, 0)
///// ```
/////
///// Or using a single grayscale value:
///// ```swift
///// let gray = color(128)
///// ```
/////
///// - Parameters:
/////   - r: Red component (0-255)
/////   - g: Green component (0-255)
/////   - b: Blue component (0-255)
/////   - a: Alpha component (0-255), defaults to 255 (fully opaque)
///// - Returns: An ``MTLClearColor`` instance with the specified color values
//func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 255) -> MTLClearColor {
//    return MTLClearColor(red: r/255, green: g/255, blue: b/255, alpha: a/255)
//}
//
///// Creates a metal clear color from a grayscale value.
/////
///// Use this function to create grayscale ``MTLClearColor`` instances where all RGB components
///// have the same value.
/////
///// ```swift
///// let mediumGray = color(128)
///// ```
/////
///// - Parameters:
/////   - gray: Grayscale value (0-255)
/////   - a: Alpha component (0-255), defaults to 255 (fully opaque)
///// - Returns: An ``MTLClearColor`` instance with the specified grayscale value
/////
//func color(_ gray: CGFloat, _ a: CGFloat = 255) -> MTLClearColor {
//    return MTLClearColor(red: gray/255, green: gray/255, blue: gray/255, alpha: a/255)
//}
//
//struct ColorExample {
//    let colorExample = color(255, 255, 255)
//}
