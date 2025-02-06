//
//  MetalRenderer.swift
//  peruna
//
//  Created by aaron on 2/6/25.
//
import MetalKit

class MetalRenderer: PerunaRenderer {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let commandBuffer: MTLCommandBuffer
    let pipeline: MTLRenderPipelineState
    
    init() {
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
    }
    
    func setup() {
        
    }
    
    func draw() {
        
    }
}

