//
//  MetalRenderer.swift
//  peruna
//
//  Created by aaron on 2/6/25.
//
import MetalKit

public class MetalRenderer: NSObject, MTKViewDelegate {
    let view: PerunaView
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let vertexBuffer: MTLBuffer
    let pipelineState: MTLRenderPipelineState
    let height: Float
    let width: Float
    let shapes: [PShape] = []
    
    
    var backgroundColor = MTLClearColor(red: 53/255, green: 76/255, blue: 161/255, alpha: 1.0)
    
    var fillColor = SIMD4<Float>(204/255, 0.0, 53/255, 1.0)
//    var strokeColor = MTLClearColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1.0)
    var noStroke = false
    var noFill = false
    var strokeWeight = 5.0
    
    init(view: PerunaView) {
        self.view = view
        self.width = Float(view.width)
        self.height = Float(view.height)
        print("View dimensions: width = \(width), height = \(height)")
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("GPU not supported")
        }
        self.device = metalDevice
        guard let cQ = device.makeCommandQueue() else {
            fatalError("Could not create command queue")
        }
        self.commandQueue = cQ
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("could not create pipeline state")
        }
        
//        let vertices = [
//            Vertex(position: MetalRenderer.pixelToDNC(x: 150, y: 0, viewWidth: width, viewHeight: height), color: fillColor),
//            Vertex(position: MetalRenderer.pixelToDNC(x: 75, y: 100, viewWidth: width, viewHeight: height), color: fillColor),
//            Vertex(position: MetalRenderer.pixelToDNC(x: 225, y: 100, viewWidth: width, viewHeight: height), color: fillColor)
//        ]
        
        let vertices = MetalRenderer.createTriangleVertices(triangle: PTriangle(width: 100, height: 100, x: 200, y: 500), viewWidth: width, viewHeight: height)
        
        guard let vB = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: []) else {
            fatalError("Could not create vertex buffer")
        }
        
        self.vertexBuffer = vB
        
        super.init()
        
    }
    
    public static func pixelToDNC(x: Float, y: Float, z: Float = 0, viewWidth: Float, viewHeight: Float) -> SIMD3<Float> {
        let ndcX = Float((2.0 * x / viewWidth) - 1.0)
        let ndcY = Float(1.0 - (2.0 * y / viewHeight))
        let ndcZ = z ///Mark: Fix this for 3D
        
        return SIMD3<Float>(ndcX, ndcY, ndcZ)
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    public static func createTriangleVertices(triangle: PTriangle, viewWidth: Float, viewHeight: Float) -> [SIMD3<Float>] {
        var verts: [SIMD3<Float>] = []
        
        let topX = triangle.x
        let topY = triangle.y-triangle.height
        verts.append(MetalRenderer.pixelToDNC(x: topX, y: topY, viewWidth: viewWidth, viewHeight: viewHeight))

        let leftX = triangle.x - (triangle.width/2)
        let leftY = triangle.y
        verts.append(MetalRenderer.pixelToDNC(x: leftX, y: leftY, viewWidth: viewWidth, viewHeight: viewHeight))
        
        let rightX = triangle.x + (triangle.width/2)
        let rightY = triangle.y
        verts.append(MetalRenderer.pixelToDNC(x: rightX, y: rightY, viewWidth: viewWidth, viewHeight: viewHeight))
        
        print(verts)
        return verts
    }
    
    public func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            fatalError("Could not create Render pass descriptor")
        }
        renderPassDescriptor.colorAttachments[0].clearColor = backgroundColor
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        //yay, draw shapes
        
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
