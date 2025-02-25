//
//  PTriangle.swift
//  PerunaTesting
//
//  Created by aaron on 2/22/25.
//

import Foundation

public struct PTriangle: PShape {
    public var width: Float
    public var height: Float
    public var x: Float
    public var y: Float
    
    init(width: Float, height: Float, x: Float, y: Float) {
        self.width = width
        self.height = height
        self.x = x
        self.y = y
    }
}
