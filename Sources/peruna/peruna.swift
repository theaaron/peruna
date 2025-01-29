import Foundation
import MetalKit
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif

class MetalContext {
    let device: MTLDevice?
    let view: MTKView
    let frame: CGRect
    
    @MainActor init() {
        guard let device = MTLCreateSystemDefaultDevice() else { fatalError("GPU not found") }
        self.device = device
        self.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        self.view = MTKView(frame: frame, device: device)
        self.view.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
    }
    
    @MainActor public func changCanvasBG(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.view.clearColor = MTLClearColor(red: r, green: g, blue: b, alpha: a)
    }
    
    @MainActor public func changeCanvasSize(w: CGFloat, h: CGFloat) {
        self.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
}

@MainActor internal let metalContext = MetalContext()

@MainActor func setup( _ userSetupMethod: () -> Void) {
    #if canImport(PlaygroundSupport)
    PlaygroundPage.current.liveView = metalContext.view
    #endif
    
    userSetupMethod()
}

func draw(_ userDrawMethod: () -> Void) {
    userDrawMethod()
}



func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 255) -> MTLClearColor {
    return MTLClearColor(red: r/255, green: g/255, blue: b/255, alpha: a/255)
}

func color(_ gray: CGFloat, _ a: CGFloat = 255) -> MTLClearColor {
    return MTLClearColor(red: gray/255, green: gray/255, blue: gray/255, alpha: a/255)
}
