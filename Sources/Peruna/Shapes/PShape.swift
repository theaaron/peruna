//
//  PShape.swift
//  Peruna
//
//  Created by aaron on 2/6/25.
//

public protocol PShape {
    var vertices: [SIMD3<Float>] { get set }
    var colors: [SIMD4<Float>] { get set }
    func draw()
}
