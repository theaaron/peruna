//
//  PShape.swift
//  Peruna
//
//  Created by aaron on 2/6/25.
//
import MetalKit

protocol PShape {
    func draw(encoder: MTLRenderCommandEncoder)
}
