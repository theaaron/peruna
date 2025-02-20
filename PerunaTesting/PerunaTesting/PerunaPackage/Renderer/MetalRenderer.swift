//
//  MetalRenderer.swift
//  peruna
//
//  Created by aaron on 2/6/25.
//
import MetalKit

public class MetalRenderer: PerunaRenderer {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let commandBuffer: MTLCommandBuffer
    let pipelineState: MTLRenderPipelineState
    var backgroundColor = MTLClearColor(red: 53/255, green: 76/255, blue: 161/255, alpha: 1.0)
    var fillColor = MTLClearColor(red: 204/255, green: 0.0, blue: 53/255, alpha: 1.0)
    var strokeColor = MTLClearColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1.0)
    var noStroke = false
    var noFill = false
    var strokeWeight = 5.0
    
    public init() {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("GPU not supported")
        }
        self.device = metalDevice
        guard let cmdQ = self.device.makeCommandQueue() else {
            fatalError("Could not create Command Queue")
        }
        self.commandQueue = cmdQ
        guard let cmdBuf = self.commandQueue.makeCommandBuffer() else {
            fatalError("Could not create Command Buffer")
        }
        self.commandBuffer = cmdBuf
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Could not create Pipeline State")
        }
        
        
        
    }
    
    public func setup() {
        
    }
    
    public func draw() {
        
    }
}
