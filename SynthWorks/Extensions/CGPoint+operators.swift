//
//  CGPoint+operators.swift
//  CGPoint+operators
//
//  Created by Riccardo Persello on 02/08/21.
//

import CoreGraphics

// Simple algebric operations on CGPoints.

extension CGPoint {
    static func +(rhs: Self, lhs: Self) -> Self {
        return CGPoint(x: rhs.x + lhs.x, y: rhs.y + lhs.y)
    }
    
    static func -(rhs: Self, lhs: Self) -> Self {
        return CGPoint(x: rhs.x - lhs.x, y: rhs.y - lhs.y)
    }
    
    static func +=(rhs: inout Self, lhs: Self) {
        rhs.x += lhs.x
        rhs.y += lhs.y
    }
    
    static func -=(rhs: inout Self, lhs: Self) {
        rhs.x -= lhs.x
        rhs.y -= lhs.y
    }
}
