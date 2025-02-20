//
//  PerunaView.swift
//  PerunaTesting
//
//  Created by aaron on 2/19/25.
//
import SwiftUI
import MetalKit

struct PerunaView: UIViewRepresentable {
    
    func makeCoordinator() -> MetalRenderer {
        MetalRenderer(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PerunaView>) -> MTKView {
        
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: UIViewRepresentableContext<PerunaView>) {
    }
}

