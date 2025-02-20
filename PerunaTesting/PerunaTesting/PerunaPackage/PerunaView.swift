//
//  PerunaView.swift
//  PerunaTesting
//
//  Created by aaron on 2/19/25.
//
import SwiftUI
import MetalKit

struct PerunaView: UIViewRepresentable {
    
    var width: CGFloat = UIScreen.main.bounds.width
    var height: CGFloat = UIScreen.main.bounds.height
    
    func makeCoordinator() -> MetalRenderer {
       MetalRenderer(view: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PerunaView>) -> MTKView {
        
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create Metal Device")
        }
        
        mtkView.device = metalDevice
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: UIViewRepresentableContext<PerunaView>) {
        
    }
    
}

