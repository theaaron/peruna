//
//  PerunaCanvas.swift
//  peruna
//
//  Created by aaron on 3/22/25.
//


import SwiftUI
import MetalKit
import Combine

#if os(iOS)
@available(macOS 11.0, *)
struct PerunaCanvas: View {
    @StateObject public var p = PerunaMetalRenderer()
    let setupHandler: ((_ p: PerunaMetalRenderer) -> Void)?
    let drawHandler: ((_ p: PerunaMetalRenderer, _ time: Double) -> Void)?
    
    // Main initializer that takes a combined handler with time parameter
    init(_ handler: @escaping (_ p: PerunaMetalRenderer, _ time: Double) -> Void) {
        self.setupHandler = nil
        self.drawHandler = handler
    }
    
    // Alternative initializer that takes individual setup and draw handlers
    init(setup: ((_ p: PerunaMetalRenderer) -> Void)? = nil,
         draw: ((_ p: PerunaMetalRenderer, _ time: Double) -> Void)? = nil) {
        self.setupHandler = setup
        self.drawHandler = draw
    }
    
    // Legacy initializer for backward compatibility
    init(handler: @escaping (_ p: PerunaMetalRenderer) -> Void) {
        self.setupHandler = handler
        self.drawHandler = nil
    }
    
    var body: some View {
        
        PerunaMTKView(renderer: p)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                // Run setup once when the view appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    p.clear()
                    
                    // Run setup if provided
                    setupHandler?(p)
                    
                    // If we have a draw handler, enable animation
                    if let drawHandler = drawHandler {
                        p.startAnimationLoop(drawHandler: drawHandler)
                    }
                    // If we have no setup but a direct handler, use it as draw
                    else if setupHandler == nil && drawHandler == nil {
                        // This shouldn't happen with the current initializers
                    }
                }
            }
            .onDisappear {
                // Stop the animation when view disappears
                p.stopAnimationLoop()
            }
    }
}
#endif
