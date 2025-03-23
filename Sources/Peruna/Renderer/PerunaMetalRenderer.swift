//
//  MetalRenderer.swift
//  peruna
//
//  Created by aaron on 2/6/25.
//
import SwiftUI
import MetalKit
import Combine

struct Uniforms {
    var fillColor: SIMD4<Float>   // 16 bytes
    var strokeColor: SIMD4<Float> // 16 bytes
    var hasStroke: Int32          // 4 bytes
}

// Metal Renderer
@available(macOS 10.15, *)
class PerunaMetalRenderer: NSObject, ObservableObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState!
    public var backgroundColor: SIMD4<Float>
    
    private var metalKitView: MTKView?
    
    
    var fillColor: SIMD4<Float>
    var strokeColor: SIMD4<Float>
    var hasStroke: Bool
    var hasFill: Bool
    
    private var animationTimer: AnyCancellable?
    private var startTime: TimeInterval = 0
    private var drawHandler: ((_ p: PerunaMetalRenderer, _ time: Double) -> Void)?
    
    // Canvas dimensions
    var width: Float = 300
    var height: Float = 300
    
    // Drawing buffer
    internal var shapes: [PShape] = []
    
    override init() {
        // Initialize Metal resources
        self.backgroundColor = SIMD4<Float>(0.1, 0.1, 0.1, 1.0)
        self.fillColor = SIMD4<Float>(204/255, 0.0, 53/255, 1.0)
        self.strokeColor = SIMD4<Float>(38/255, 38/255, 38/255, 1.0)
        self.hasStroke = true
        self.hasFill = true
        
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        self.device = device
        
        guard let queue = device.makeCommandQueue() else {
            fatalError("Could not create command queue")
        }
        self.commandQueue = queue
        
        super.init()
        setupRenderPipeline()
    }
    
    private func setupRenderPipeline() {
        // Define shaders as string
        let shaderSource = """
        #include <metal_stdlib>
        using namespace metal;

        struct VertexOut {
            float4 position [[position]];
            float4 color;
            bool isStroke;
        };

        struct Uniforms {
            packed_float4 fillColor;      // 16 bytes
            packed_float4 strokeColor;    // 16 bytes
            int32_t hasStroke;            // 4 bytes
        };

        vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
                                  constant float4 *positions [[buffer(0)]],
                                  constant bool *isStroke [[buffer(1)]],
                                  constant Uniforms &uniforms [[buffer(2)]]) {
            VertexOut out;
            out.position = positions[vertexID];
            out.isStroke = isStroke[vertexID];
            return out;
        }

        fragment float4 fragmentShader(VertexOut in [[stage_in]],
                                     constant Uniforms &uniforms [[buffer(0)]]) {
            return in.isStroke ? uniforms.strokeColor : uniforms.fillColor;
        }
        """
        
        // Create shader library
        let library: MTLLibrary
        do {
            library = try device.makeLibrary(source: shaderSource, options: nil)
        } catch {
            fatalError("Could not create shader library: \(error)")
        }
        
        // Get shader functions
        guard let vertexFunction = library.makeFunction(name: "vertexShader"),
              let fragmentFunction = library.makeFunction(name: "fragmentShader") else {
            fatalError("Could not create shader functions")
        }
        
        // Create render pipeline
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Could not create render pipeline state: \(error)")
        }
    }
    
    // MARK: - Animation Methods
    // this double may need to be a float - be on the look out
    func startAnimationLoop(drawHandler: @escaping (_ p: PerunaMetalRenderer, _ time: Double) -> Void) {
        self.drawHandler = drawHandler
        self.startTime = CACurrentMediaTime()
        
        // run the draw loop at 60fps ---- MAYBE THERE SHOULD BE 120FPS OPTION?
        self.animationTimer = Timer.publish(every: 1.0/60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let currentTime = CACurrentMediaTime()
                let elapsedTime = currentTime - self.startTime
                
                // MARK: MAYBE THIS SHOULD BE HANDLED IN THE BACKGROUND METHOD?
                self.clear()
                
                self.drawHandler?(self, elapsedTime)
                
                if let view = self.metalKitView {
                    view.setNeedsDisplay()
                }
            }
    }
    
    func stopAnimationLoop() {
        animationTimer?.cancel()
        animationTimer = nil
    }
    
    // MARK: - MTKViewDelegate
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        width = Float(size.width)
        height = Float(size.height)
        
        self.metalKitView = view
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        // Create command buffer
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        
        // Create render command encoder
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        view.clearColor = MTLClearColor(red: Double(self.backgroundColor.x), green: Double(self.backgroundColor.y), blue: Double(self.backgroundColor.z), alpha: Double(self.backgroundColor.w))
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // Draw all shapes
        for shape in shapes {
            shape.draw(encoder: renderEncoder)
        }
        
        renderEncoder.endEncoding()
        
        // Present drawable and commit command buffer
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func clear() {
        shapes.removeAll()
    }
    

    
    
}
