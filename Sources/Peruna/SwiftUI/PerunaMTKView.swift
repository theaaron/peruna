//
//  PerunaMTKView.swift
//  peruna
//
//  Created by aaron on 3/22/25.
//

import SwiftUI
import MetalKit

#if os(iOS)
struct PerunaMTKView: UIViewRepresentable {
    var renderer: MetalRenderer
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = renderer
        mtkView.device = renderer.device
        mtkView.clearColor = MTLClearColor(red: Double(renderer.backgroundColor.x), green: Double(renderer.backgroundColor.y), blue: Double(renderer.backgroundColor.z), alpha: Double(renderer.backgroundColor.w))
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.framebufferOnly = true
        
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        // Update view size
        renderer.width = Float(uiView.bounds.width)
        renderer.height = Float(uiView.bounds.height)
    }
}
#endif
